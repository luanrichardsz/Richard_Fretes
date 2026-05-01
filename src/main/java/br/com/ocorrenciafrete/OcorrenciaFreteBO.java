package br.com.ocorrenciafrete;

import br.com.connection.ConnectionFactory;
import br.com.ocorrenciafrete.OcorrenciaFreteDAO;
import br.com.exception.FreteException;
import br.com.frete.Frete;
import br.com.frete.FreteDAO;
import br.com.veiculo.Veiculo;
import br.com.veiculo.VeiculoDAO;
import br.com.ocorrenciafrete.OcorrenciaFrete;
import br.com.util.ValidationUtils;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;

public class OcorrenciaFreteBO {

    private final OcorrenciaFreteDAO ocorrenciaDAO;
    private final FreteDAO freteDAO;
    private final VeiculoDAO veiculoDAO;

    public OcorrenciaFreteBO() {
        this(new OcorrenciaFreteDAO(), new FreteDAO(), new VeiculoDAO());
    }

    public OcorrenciaFreteBO(OcorrenciaFreteDAO ocorrenciaDAO) {
        this(ocorrenciaDAO, new FreteDAO(), new VeiculoDAO());
    }

    public OcorrenciaFreteBO(OcorrenciaFreteDAO ocorrenciaDAO, FreteDAO freteDAO, VeiculoDAO veiculoDAO) {
        this.ocorrenciaDAO = ocorrenciaDAO;
        this.freteDAO = freteDAO;
        this.veiculoDAO = veiculoDAO;
    }

    public void salvar(OcorrenciaFrete ocorrencia) throws FreteException {
        Frete frete = validarOcorrencia(ocorrencia);

        Connection conn = null;
        try {
            conn = abrirConexao();
            conn.setAutoCommit(false);
            ocorrenciaDAO.salvar(conn, ocorrencia);
            atualizarFreteEntregaSeNecessario(conn, frete, ocorrencia);
            conn.commit();
        } catch (SQLException e) {
            rollbackSilencioso(conn);
            throw new FreteException("Erro ao registrar a ocorrência.", e);
        } finally {
            fecharSilencioso(conn);
        }
    }

    public void atualizar(OcorrenciaFrete ocorrencia) throws FreteException {
        Frete frete = validarOcorrencia(ocorrencia);

        Connection conn = null;
        try {
            conn = abrirConexao();
            conn.setAutoCommit(false);
            ocorrenciaDAO.atualizar(conn, ocorrencia);
            atualizarFreteEntregaSeNecessario(conn, frete, ocorrencia);
            conn.commit();
        } catch (SQLException e) {
            rollbackSilencioso(conn);
            throw new FreteException("Erro ao atualizar a ocorrência.", e);
        } finally {
            fecharSilencioso(conn);
        }
    }

    private Frete validarOcorrencia(OcorrenciaFrete ocorrencia) throws FreteException {
        if (ocorrencia == null) {
            throw new FreteException("Ocorrência inválida.");
        }

        if (ocorrencia.getFreteId() == null || ocorrencia.getFreteId() <= 0) {
            throw new FreteException("Frete inválido.");
        }

        if (ocorrencia.getTipo() == null) {
            throw new FreteException("Tipo da ocorrência é obrigatório.");
        }

        if (ocorrencia.getDataHora() == null) {
            throw new FreteException("Data/hora da ocorrência é obrigatória.");
        }

        Frete frete = freteDAO.buscarPorId(ocorrencia.getFreteId());
        if (frete == null) {
            throw new FreteException("Frete não encontrado para a ocorrência.");
        }

        if (frete.getStatus() == Frete.StatusFrete.ENTREGUE
                || frete.getStatus() == Frete.StatusFrete.NAO_ENTREGUE
                || frete.getStatus() == Frete.StatusFrete.CANCELADO) {
            throw new FreteException("Não é permitido registrar ocorrência para frete ENTREGUE, NÃO ENTREGUE ou CANCELADO.");
        }

        LocalDateTime ultimaDataHora = ocorrenciaDAO.buscarUltimaDataHoraPorFrete(ocorrencia.getFreteId(), ocorrencia.getId());
        if (ultimaDataHora != null && ocorrencia.getDataHora().isBefore(ultimaDataHora)) {
            throw new FreteException("A data/hora da ocorrência não pode ser anterior à ocorrência mais recente do frete.");
        }

        if (ValidationUtils.estaVazio(ocorrencia.getMunicipio())) {
            throw new FreteException("Município é obrigatório.");
        }

        if (ValidationUtils.estaVazio(ocorrencia.getUf()) || !ocorrencia.getUf().trim().matches("^[A-Za-z]{2}$")) {
            throw new FreteException("UF inválida.");
        }

        if (!ValidationUtils.estaVazio(ocorrencia.getRecebedorDocumento())) {
            String documento = ValidationUtils.manterSomenteDigitos(ocorrencia.getRecebedorDocumento());
            if (!(documento.length() == 11 || documento.length() == 14)) {
                throw new FreteException("Documento do recebedor inválido.");
            }
            ocorrencia.setRecebedorDocumento(documento);
        }

        if (ocorrencia.getTipo() == OcorrenciaFrete.TipoOcorrencia.ENTREGA_REALIZADA) {
            if (frete.getStatus() != Frete.StatusFrete.EM_TRANSITO) {
                throw new FreteException("Só é permitido registrar Entrega Realizada para frete em trânsito.");
            }
            if (ValidationUtils.estaVazio(ocorrencia.getRecebedorNome())
                    || ValidationUtils.estaVazio(ocorrencia.getRecebedorDocumento())) {
                throw new FreteException("Entrega Realizada exige nome e documento do recebedor.");
            }
        }

        ocorrencia.setMunicipio(ocorrencia.getMunicipio().trim());
        ocorrencia.setUf(ocorrencia.getUf().trim().toUpperCase());

        if (ocorrencia.getRecebedorNome() != null) {
            ocorrencia.setRecebedorNome(ocorrencia.getRecebedorNome().trim());
        }

        if (ocorrencia.getDescricao() != null) {
            ocorrencia.setDescricao(ocorrencia.getDescricao().trim());
        }

        if (ocorrencia.getFotoEvidenciaUrl() != null) {
            ocorrencia.setFotoEvidenciaUrl(ocorrencia.getFotoEvidenciaUrl().trim());
        }

        return frete;
    }

    private void atualizarFreteEntregaSeNecessario(Connection conn, Frete frete, OcorrenciaFrete ocorrencia)
            throws SQLException {
        if (ocorrencia.getTipo() != OcorrenciaFrete.TipoOcorrencia.ENTREGA_REALIZADA) {
            return;
        }

        frete.setStatus(Frete.StatusFrete.ENTREGUE);
        if (frete.getDataEntrega() == null) {
            frete.setDataEntrega(ocorrencia.getDataHora());
        }
        freteDAO.atualizar(conn, frete);
        veiculoDAO.atualizarStatus(conn, frete.getVeiculoId(), Veiculo.StatusVeiculo.DISPONIVEL);
    }

    private Connection abrirConexao() throws SQLException {
        class ConnectionProvider extends ConnectionFactory {
            private Connection abrir() throws SQLException {
                return getConnection();
            }
        }

        return new ConnectionProvider().abrir();
    }

    private void rollbackSilencioso(Connection conn) {
        if (conn == null) {
            return;
        }

        try {
            conn.rollback();
        } catch (SQLException ignored) {
        }
    }

    private void fecharSilencioso(Connection conn) {
        if (conn == null) {
            return;
        }

        try {
            conn.close();
        } catch (SQLException ignored) {
        }
    }
}
