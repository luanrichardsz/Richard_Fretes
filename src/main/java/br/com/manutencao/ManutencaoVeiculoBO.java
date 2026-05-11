package br.com.manutencao;

import br.com.connection.ConnectionFactory;
import br.com.exception.CadastroException;
import br.com.frete.FreteDAO;
import br.com.manutencao.ManutencaoVeiculo.StatusManutencao;
import br.com.util.ValidationUtils;
import br.com.veiculo.Veiculo;
import br.com.veiculo.VeiculoDAO;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
public class ManutencaoVeiculoBO {

    private final ManutencaoVeiculoDAO manutencaoDAO;
    private final VeiculoDAO veiculoDAO;
    private final FreteDAO freteDAO;

    public ManutencaoVeiculoBO() {
        this(new ManutencaoVeiculoDAO(), new VeiculoDAO(), new FreteDAO());
    }

    public ManutencaoVeiculoBO(ManutencaoVeiculoDAO manutencaoDAO, VeiculoDAO veiculoDAO, FreteDAO freteDAO) {
        this.manutencaoDAO = manutencaoDAO;
        this.veiculoDAO = veiculoDAO;
        this.freteDAO = freteDAO;
    }

    public void salvar(ManutencaoVeiculo manutencao) throws CadastroException {
        validarManutencao(manutencao, false);

        Connection conn = null;
        try {
            conn = abrirConexao();
            conn.setAutoCommit(false);
            manutencaoDAO.salvar(conn, manutencao);
            manutencaoDAO.sincronizarEstadoVeiculo(conn, manutencao.getVeiculoId());
            conn.commit();
        } catch (SQLException e) {
            rollbackSilencioso(conn);
            throw new CadastroException("Erro ao salvar a manutenção do veículo.", e);
        } finally {
            fecharSilencioso(conn);
        }
    }

    public void atualizar(ManutencaoVeiculo manutencao) throws CadastroException {
        validarManutencao(manutencao, true);

        Connection conn = null;
        try {
            conn = abrirConexao();
            conn.setAutoCommit(false);
            ManutencaoVeiculo atual = manutencaoDAO.buscarPorId(manutencao.getId());
            manutencaoDAO.atualizar(conn, manutencao);
            manutencaoDAO.sincronizarEstadoVeiculo(conn, manutencao.getVeiculoId());
            if (atual != null && atual.getVeiculoId() != null && !atual.getVeiculoId().equals(manutencao.getVeiculoId())) {
                manutencaoDAO.sincronizarEstadoVeiculo(conn, atual.getVeiculoId());
            }
            conn.commit();
        } catch (SQLException e) {
            rollbackSilencioso(conn);
            throw new CadastroException("Erro ao atualizar a manutenção do veículo.", e);
        } finally {
            fecharSilencioso(conn);
        }
    }

    public void deletar(Integer manutencaoId) throws CadastroException {
        if (manutencaoId == null || manutencaoId <= 0) {
            throw new CadastroException("Manutenção inválida.");
        }

        ManutencaoVeiculo manutencao = manutencaoDAO.buscarPorId(manutencaoId);
        if (manutencao == null) {
            throw new CadastroException("Manutenção não encontrada.");
        }

        if (manutencao.getStatus() == StatusManutencao.EM_ANDAMENTO) {
            throw new CadastroException("Não é permitido excluir uma manutenção em andamento. Conclua ou cancele primeiro.");
        }

        Connection conn = null;
        try {
            conn = abrirConexao();
            conn.setAutoCommit(false);
            try (java.sql.PreparedStatement stmt = conn.prepareStatement("DELETE FROM manutencao_veiculo WHERE id = ?")) {
                stmt.setInt(1, manutencaoId);
                stmt.executeUpdate();
            }
            manutencaoDAO.sincronizarEstadoVeiculo(conn, manutencao.getVeiculoId());
            conn.commit();
        } catch (SQLException e) {
            rollbackSilencioso(conn);
            throw new CadastroException("Erro ao excluir a manutenção do veículo.", e);
        } finally {
            fecharSilencioso(conn);
        }
    }

    private void validarManutencao(ManutencaoVeiculo manutencao, boolean emEdicao) throws CadastroException {
        if (manutencao == null) {
            throw new CadastroException("Manutenção inválida.");
        }

        if (emEdicao && (manutencao.getId() == null || manutencao.getId() <= 0)) {
            throw new CadastroException("Manutenção inválida.");
        }

        if (manutencao.getVeiculoId() == null || manutencao.getVeiculoId() <= 0) {
            throw new CadastroException("Veículo é obrigatório.");
        }

        Veiculo veiculo = veiculoDAO.buscarPorId(manutencao.getVeiculoId());
        if (veiculo == null) {
            throw new CadastroException("Veículo não encontrado para a manutenção.");
        }

        if (manutencao.getTipo() == null) {
            throw new CadastroException("Tipo de manutenção é obrigatório.");
        }

        if (manutencao.getStatus() == null) {
            throw new CadastroException("Status da manutenção é obrigatório.");
        }

        if (ValidationUtils.estaVazio(manutencao.getDescricao())) {
            throw new CadastroException("Descrição da manutenção é obrigatória.");
        }

        if (manutencao.getDataPrevista() == null) {
            throw new CadastroException("Data prevista é obrigatória.");
        }

        if (manutencao.getCusto() == null) {
            manutencao.setCusto(BigDecimal.ZERO);
        }

        if (manutencao.getCusto().compareTo(BigDecimal.ZERO) < 0) {
            throw new CadastroException("O custo da manutenção não pode ser negativo.");
        }

        if (manutencao.getStatus() == StatusManutencao.CONCLUIDA && manutencao.getDataRealizacao() == null) {
            throw new CadastroException("Informe a data de realização para concluir a manutenção.");
        }

        if (manutencao.getStatus() != StatusManutencao.CONCLUIDA && manutencao.getDataRealizacao() != null) {
            throw new CadastroException("A data de realização só pode ser informada para manutenção concluída.");
        }

        if (manutencao.getDataRealizacao() != null && manutencao.getDataRealizacao().isBefore(manutencao.getDataPrevista())) {
            throw new CadastroException("A data de realização não pode ser anterior à data prevista.");
        }

        if (manutencao.getStatus() == StatusManutencao.EM_ANDAMENTO) {
            if (freteDAO.existeFreteEmTransitoParaVeiculo(manutencao.getVeiculoId(), null)) {
                throw new CadastroException("Não é permitido iniciar manutenção enquanto o veículo estiver em frete EM TRÂNSITO.");
            }

            if (veiculo.getStatus() == Veiculo.StatusVeiculo.EM_VIAGEM) {
                throw new CadastroException("Não é permitido iniciar manutenção para um veículo em viagem.");
            }

            Integer manutencaoIgnorada = emEdicao ? manutencao.getId() : null;
            if (manutencaoDAO.existeManutencaoEmAndamento(manutencao.getVeiculoId(), manutencaoIgnorada)) {
                throw new CadastroException("Já existe uma manutenção em andamento para este veículo.");
            }
        }

        if (veiculo.getStatus() == Veiculo.StatusVeiculo.EM_MANUTENCAO && manutencao.getStatus() == StatusManutencao.CANCELADA) {
            Integer manutencaoIgnorada = emEdicao ? manutencao.getId() : null;
            if (manutencaoDAO.existeManutencaoEmAndamento(manutencao.getVeiculoId(), manutencaoIgnorada)) {
                throw new CadastroException("Ainda existe outra manutenção em andamento para este veículo.");
            }
        }

        manutencao.setDescricao(manutencao.getDescricao().trim());
        if (manutencao.getFornecedorOficina() != null) {
            manutencao.setFornecedorOficina(manutencao.getFornecedorOficina().trim());
        }
        if (manutencao.getObservacao() != null) {
            manutencao.setObservacao(manutencao.getObservacao().trim());
        }
    }

    public ResumoManutencaoVeiculo resumirVeiculo(Integer veiculoId) {
        return manutencaoDAO.resumirPorVeiculo(veiculoId);
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
