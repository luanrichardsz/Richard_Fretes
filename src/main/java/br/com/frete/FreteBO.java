package br.com.frete;

import br.com.connection.ConnectionFactory;
import br.com.endereco.EnderecoDAO;
import br.com.frete.FreteDAO;
import br.com.motorista.MotoristaDAO;
import br.com.veiculo.VeiculoDAO;
import br.com.exception.FreteException;
import br.com.endereco.Endereco;
import br.com.frete.Frete;
import br.com.motorista.Motorista;
import br.com.veiculo.Veiculo;
import br.com.util.ValidationUtils;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.sql.Connection;
import java.sql.SQLException;

public class FreteBO {

    private final FreteDAO freteDAO;
    private final EnderecoDAO enderecoDAO;
    private final MotoristaDAO motoristaDAO;
    private final VeiculoDAO veiculoDAO;

    public FreteBO() {
        this(new FreteDAO(), new EnderecoDAO(), new MotoristaDAO(), new VeiculoDAO());
    }

    public FreteBO(FreteDAO freteDAO) {
        this(freteDAO, new EnderecoDAO(), new MotoristaDAO(), new VeiculoDAO());
    }

    public FreteBO(FreteDAO freteDAO, EnderecoDAO enderecoDAO, MotoristaDAO motoristaDAO, VeiculoDAO veiculoDAO) {
        this.freteDAO = freteDAO;
        this.enderecoDAO = enderecoDAO;
        this.motoristaDAO = motoristaDAO;
        this.veiculoDAO = veiculoDAO;
    }

    public void salvar(Frete frete) throws FreteException {
        validarFrete(frete, false);

        Connection conn = null;
        try {
            conn = abrirConexao();
            conn.setAutoCommit(false);
            freteDAO.salvar(conn, frete);
            conn.commit();
        } catch (SQLException e) {
            rollbackSilencioso(conn);
            throw new FreteException("Erro ao salvar o frete.", e);
        } finally {
            fecharSilencioso(conn);
        }
    }

    public void atualizar(Frete frete) throws FreteException {
        Frete freteAtual = freteDAO.buscarPorId(frete.getId());
        if (freteAtual == null) {
            throw new FreteException("Frete não encontrado.");
        }

        frete.setNumeroFrete(freteAtual.getNumeroFrete());
        frete.setDataEmissao(freteAtual.getDataEmissao());
        validarFrete(frete, true, freteAtual);
        validarTransicaoStatus(freteAtual.getStatus(), frete.getStatus());
        aplicarDatasDeStatus(frete, freteAtual);

        Connection conn = null;
        try {
            conn = abrirConexao();
            conn.setAutoCommit(false);
            freteDAO.atualizar(conn, frete);
            sincronizarStatusVeiculo(conn, freteAtual, frete);
            conn.commit();
        } catch (SQLException e) {
            rollbackSilencioso(conn);
            throw new FreteException("Erro ao atualizar o frete.", e);
        } finally {
            fecharSilencioso(conn);
        }
    }

    public String gerarProximoNumeroFrete() {
        return freteDAO.gerarProximoNumeroFrete(LocalDate.now().getYear());
    }

    private void validarFrete(Frete frete, boolean emEdicao) throws FreteException {
        validarFrete(frete, emEdicao, null);
    }

    private void validarFrete(Frete frete, boolean emEdicao, Frete freteAtual) throws FreteException {
        if (frete == null) {
            throw new FreteException("Frete inválido.");
        }

        if (!emEdicao) {
            frete.setNumeroFrete(gerarProximoNumeroFrete());
            frete.setStatus(Frete.StatusFrete.EMITIDO);
        }

        if (ValidationUtils.estaVazio(frete.getNumeroFrete())) {
            throw new FreteException("Número do frete é obrigatório.");
        }

        String numeroFrete = frete.getNumeroFrete().trim().toUpperCase();
        if (!emEdicao && !numeroFrete.matches("^FRT-\\d{4}-\\d{4,5}$")) {
            throw new FreteException("Número do frete inválido.");
        }

        if (freteDAO.existeNumeroParaOutroFrete(numeroFrete, emEdicao ? frete.getId() : null)) {
            throw new FreteException("Já existe um frete cadastrado com este número.");
        }

        validarIdPositivo(frete.getRemetenteId(), "Remetente");
        validarIdPositivo(frete.getDestinatarioId(), "Destinatário");
        validarIdPositivo(frete.getEnderecoOrigemId(), "Endereço de origem");
        validarIdPositivo(frete.getEnderecoDestinoId(), "Endereço de destino");
        validarIdPositivo(frete.getMotoristaId(), "Motorista");
        validarIdPositivo(frete.getVeiculoId(), "Veículo");

        preencherIbgesPelosEnderecos(frete);
        boolean mesmoMotorista = freteAtual != null && frete.getMotoristaId().equals(freteAtual.getMotoristaId());
        boolean mesmoVeiculo = freteAtual != null && frete.getVeiculoId().equals(freteAtual.getVeiculoId());

        Veiculo veiculo = validarVeiculoDisponivelParaFrete(frete.getVeiculoId(), mesmoVeiculo);
        validarMotoristaDisponivelParaFrete(
            frete.getMotoristaId(),
            frete.getDataEmissao().toLocalDate(),
            mesmoMotorista ? frete.getId() : null,
            mesmoMotorista
        );

        if (frete.getRemetenteId().equals(frete.getDestinatarioId())) {
            throw new FreteException("Remetente e destinatário não podem ser o mesmo cliente.");
        }

        if (!ValidationUtils.estaVazio(frete.getChaveNfe())) {
            String chaveNfe = ValidationUtils.manterSomenteDigitos(frete.getChaveNfe());
            if (chaveNfe.length() != 44) {
                throw new FreteException("Chave NFe inválida.");
            }
            frete.setChaveNfe(chaveNfe);
        }

        if (!ValidationUtils.estaVazio(frete.getOrigemIbge())) {
            String origemIbge = ValidationUtils.manterSomenteDigitos(frete.getOrigemIbge());
            if (origemIbge.length() != 7) {
                throw new FreteException("Código IBGE de origem inválido.");
            }
            frete.setOrigemIbge(origemIbge);
        }

        if (!ValidationUtils.estaVazio(frete.getDestinoIbge())) {
            String destinoIbge = ValidationUtils.manterSomenteDigitos(frete.getDestinoIbge());
            if (destinoIbge.length() != 7) {
                throw new FreteException("Código IBGE de destino inválido.");
            }
            frete.setDestinoIbge(destinoIbge);
        }

        if (ValidationUtils.estaVazio(frete.getNaturezaCarga())) {
            throw new FreteException("Natureza da carga é obrigatória.");
        }

        validarDecimalPositivo(frete.getPesoBruto(), "Peso bruto");
        if (frete.getPesoBruto().compareTo(BigDecimal.valueOf(veiculo.getCapacidadeCargaKg())) > 0) {
            throw new FreteException("O peso bruto da carga não pode exceder a capacidade de carga do veículo.");
        }
        if (frete.getVolumes() == null || frete.getVolumes() <= 0) {
            throw new FreteException("Volumes inválidos.");
        }
        validarDecimalPositivo(frete.getDistanciaKm(), "Distância");
        validarDecimalPositivo(frete.getValorFreteBruto(), "Valor do frete bruto");
        validarDecimalNaoNegativo(frete.getValorPedagio(), "Valor do pedágio");
        validarDecimalNaoNegativo(frete.getAliquotaIcms(), "Alíquota ICMS");
        validarDecimalNaoNegativo(frete.getValorIcms(), "Valor ICMS");
        frete.setValorTotal(calcularValorTotal(frete));
        validarDecimalPositivo(frete.getValorTotal(), "Valor total");

        if (frete.getPrevisaoEntrega() == null) {
            throw new FreteException("Previsão de entrega é obrigatória.");
        }

        if (!frete.getPrevisaoEntrega().isAfter(frete.getDataEmissao().toLocalDate())) {
            throw new FreteException("A data prevista de entrega deve ser posterior à data de emissão.");
        }

        frete.setNumeroFrete(numeroFrete);
        frete.setNaturezaCarga(frete.getNaturezaCarga().trim());
    }

    private void preencherIbgesPelosEnderecos(Frete frete) throws FreteException {
        Endereco enderecoOrigem = enderecoDAO.buscarPorId(frete.getEnderecoOrigemId());
        if (enderecoOrigem == null) {
            throw new FreteException("Endereço de origem selecionado não foi encontrado.");
        }

        String origemIbge = ValidationUtils.manterSomenteDigitos(enderecoOrigem.getCodigoIbge());
        if (origemIbge.length() != 7) {
            throw new FreteException("O endereço de origem não possui um código IBGE válido.");
        }

        Endereco enderecoDestino = enderecoDAO.buscarPorId(frete.getEnderecoDestinoId());
        if (enderecoDestino == null) {
            throw new FreteException("Endereço de destino selecionado não foi encontrado.");
        }

        String destinoIbge = ValidationUtils.manterSomenteDigitos(enderecoDestino.getCodigoIbge());
        if (destinoIbge.length() != 7) {
            throw new FreteException("O endereço de destino não possui um código IBGE válido.");
        }

        frete.setOrigemIbge(origemIbge);
        frete.setDestinoIbge(destinoIbge);
    }

    private void validarMotoristaDisponivelParaFrete(
            Integer motoristaId,
            LocalDate dataEmissao,
            Integer freteIdIgnorado,
            boolean permitirMotoristaJaVinculado)
            throws FreteException {
        Motorista motorista = motoristaDAO.buscarPorId(motoristaId);

        if (motorista == null) {
            throw new FreteException("Motorista selecionado não foi encontrado.");
        }

        if (motorista.getStatus() != Motorista.StatusMotorista.ATIVO) {
            throw new FreteException("O motorista deve estar com status Ativo para ser atribuído ao frete.");
        }

        if (!permitirMotoristaJaVinculado && freteDAO.existeFreteEmExecucaoParaMotorista(motoristaId, freteIdIgnorado)) {
            throw new FreteException(
                "O motorista não pode possuir frete em status SAÍDA CONFIRMADA ou EM TRÂNSITO."
            );
        }

        if (motorista.getValidadeCnh() == null || motorista.getValidadeCnh().isBefore(dataEmissao)) {
            throw new FreteException("A CNH do motorista deve estar válida na data de emissão do frete.");
        }
    }

    private Veiculo validarVeiculoDisponivelParaFrete(Integer veiculoId, boolean permitirVeiculoJaVinculado)
            throws FreteException {
        Veiculo veiculo = veiculoDAO.buscarPorId(veiculoId);

        if (veiculo == null) {
            throw new FreteException("Veículo selecionado não foi encontrado.");
        }

        if (!permitirVeiculoJaVinculado && veiculo.getStatus() != Veiculo.StatusVeiculo.DISPONIVEL) {
            throw new FreteException("O veículo deve estar com status Disponível para ser atribuído a um novo frete.");
        }

        if (veiculo.getSeguroValidade() == null) {
            throw new FreteException("O veículo selecionado não possui validade informada.");
        }

        if (veiculo.getSeguroValidade().isBefore(LocalDate.now())) {
            throw new FreteException("Não é possível gerar frete com a validade do veículo vencida.");
        }

        return veiculo;
    }

    private void validarTransicaoStatus(Frete.StatusFrete statusAtual, Frete.StatusFrete novoStatus) throws FreteException {
        if (statusAtual == novoStatus) {
            return;
        }

        switch (statusAtual) {
            case EMITIDO:
                if (novoStatus != Frete.StatusFrete.SAIDA_CONFIRMADA && novoStatus != Frete.StatusFrete.CANCELADO) {
                    throw new FreteException("Transição de status inválida para o frete.");
                }
                return;
            case SAIDA_CONFIRMADA:
                if (novoStatus != Frete.StatusFrete.EM_TRANSITO && novoStatus != Frete.StatusFrete.CANCELADO) {
                    throw new FreteException("Transição de status inválida para o frete.");
                }
                return;
            case EM_TRANSITO:
                if (novoStatus != Frete.StatusFrete.ENTREGUE && novoStatus != Frete.StatusFrete.NAO_ENTREGUE) {
                    throw new FreteException("Transição de status inválida para o frete.");
                }
                return;
            case ENTREGUE:
            case NAO_ENTREGUE:
            case CANCELADO:
                throw new FreteException("Não é permitido alterar o status de um frete finalizado.");
            default:
                throw new FreteException("Transição de status inválida para o frete.");
        }
    }

    private void aplicarDatasDeStatus(Frete frete, Frete freteAtual) {
        frete.setDataSaida(freteAtual.getDataSaida());
        frete.setDataEntrega(freteAtual.getDataEntrega());

        if (freteAtual.getStatus() != Frete.StatusFrete.SAIDA_CONFIRMADA
                && frete.getStatus() == Frete.StatusFrete.SAIDA_CONFIRMADA
                && frete.getDataSaida() == null) {
            frete.setDataSaida(LocalDateTime.now());
        }

        if (freteAtual.getStatus() != Frete.StatusFrete.ENTREGUE
                && freteAtual.getStatus() != Frete.StatusFrete.NAO_ENTREGUE
                && (frete.getStatus() == Frete.StatusFrete.ENTREGUE || frete.getStatus() == Frete.StatusFrete.NAO_ENTREGUE)
                && frete.getDataEntrega() == null) {
            frete.setDataEntrega(LocalDateTime.now());
        }
    }

    private void sincronizarStatusVeiculo(Connection conn, Frete freteAtual, Frete freteAtualizado) throws SQLException {
        if (freteAtual.getStatus() != Frete.StatusFrete.SAIDA_CONFIRMADA
                && freteAtualizado.getStatus() == Frete.StatusFrete.SAIDA_CONFIRMADA) {
            veiculoDAO.atualizarStatus(conn, freteAtualizado.getVeiculoId(), Veiculo.StatusVeiculo.EM_VIAGEM);
            return;
        }

        if (freteAtual.getStatus() != Frete.StatusFrete.ENTREGUE
                && freteAtual.getStatus() != Frete.StatusFrete.NAO_ENTREGUE
                && (freteAtualizado.getStatus() == Frete.StatusFrete.ENTREGUE
                || freteAtualizado.getStatus() == Frete.StatusFrete.NAO_ENTREGUE)) {
            veiculoDAO.atualizarStatus(conn, freteAtualizado.getVeiculoId(), Veiculo.StatusVeiculo.DISPONIVEL);
        }
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

    private BigDecimal calcularValorTotal(Frete frete) {
        return frete.getValorFreteBruto()
                .add(frete.getValorPedagio())
                .add(frete.getValorIcms());
    }

    private void validarIdPositivo(Integer valor, String campo) throws FreteException {
        if (valor == null || valor <= 0) {
            throw new FreteException(campo + " inválido.");
        }
    }

    private void validarDecimalPositivo(BigDecimal valor, String campo) throws FreteException {
        if (valor == null || valor.compareTo(BigDecimal.ZERO) <= 0) {
            throw new FreteException(campo + " inválido.");
        }
    }

    private void validarDecimalNaoNegativo(BigDecimal valor, String campo) throws FreteException {
        if (valor == null || valor.compareTo(BigDecimal.ZERO) < 0) {
            throw new FreteException(campo + " inválido.");
        }
    }
}
