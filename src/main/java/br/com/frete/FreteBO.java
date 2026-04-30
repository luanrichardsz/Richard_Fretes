package br.com.frete;

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
        freteDAO.salvar(frete);
    }

    public void atualizar(Frete frete) throws FreteException {
        validarFrete(frete, true);
        freteDAO.atualizar(frete);
    }

    public String gerarProximoNumeroFrete() {
        return freteDAO.gerarProximoNumeroFrete(LocalDate.now().getYear());
    }

    private void validarFrete(Frete frete, boolean emEdicao) throws FreteException {
        if (frete == null) {
            throw new FreteException("Frete inválido.");
        }

        if (!emEdicao) {
            frete.setNumeroFrete(gerarProximoNumeroFrete());
        }

        if (ValidationUtils.estaVazio(frete.getNumeroFrete())) {
            throw new FreteException("Número do frete é obrigatório.");
        }

        String numeroFrete = frete.getNumeroFrete().trim().toUpperCase();
        if (!numeroFrete.matches("^FRT-\\d{4}-\\d{4,5}$")) {
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
        validarMotoristaDisponivelParaFrete(frete.getMotoristaId());
        validarVeiculoDisponivelParaFrete(frete.getVeiculoId());

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

        if (frete.getPrevisaoEntrega().isBefore(LocalDate.now())) {
            throw new FreteException("A previsão de entrega não pode ser anterior à data atual.");
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

    private void validarMotoristaDisponivelParaFrete(Integer motoristaId) throws FreteException {
        Motorista motorista = motoristaDAO.buscarPorId(motoristaId);

        if (motorista == null) {
            throw new FreteException("Motorista selecionado não foi encontrado.");
        }

        if (motorista.getValidadeCnh() == null || motorista.getValidadeCnh().isBefore(LocalDate.now())) {
            throw new FreteException("Não é possível gerar frete com a CNH do motorista vencida.");
        }
    }

    private void validarVeiculoDisponivelParaFrete(Integer veiculoId) throws FreteException {
        Veiculo veiculo = veiculoDAO.buscarPorId(veiculoId);

        if (veiculo == null) {
            throw new FreteException("Veículo selecionado não foi encontrado.");
        }

        if (veiculo.getSeguroValidade() == null) {
            throw new FreteException("O veículo selecionado não possui validade informada.");
        }

        if (veiculo.getSeguroValidade().isBefore(LocalDate.now())) {
            throw new FreteException("Não é possível gerar frete com a validade do veículo vencida.");
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
