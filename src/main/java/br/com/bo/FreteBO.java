package br.com.bo;

import br.com.dao.FreteDAO;
import br.com.exception.FreteException;
import br.com.model.Frete;
import br.com.util.ValidationUtils;

import java.math.BigDecimal;
import java.time.LocalDate;

public class FreteBO {

    private final FreteDAO freteDAO;

    public FreteBO() {
        this(new FreteDAO());
    }

    public FreteBO(FreteDAO freteDAO) {
        this.freteDAO = freteDAO;
    }

    public void salvar(Frete frete) throws FreteException {
        validarFrete(frete, false);
        freteDAO.salvar(frete);
    }

    public void atualizar(Frete frete) throws FreteException {
        validarFrete(frete, true);
        freteDAO.atualizar(frete);
    }

    private void validarFrete(Frete frete, boolean emEdicao) throws FreteException {
        if (frete == null) {
            throw new FreteException("Frete inválido.");
        }

        if (ValidationUtils.estaVazio(frete.getNumeroFrete())) {
            throw new FreteException("Número do frete é obrigatório.");
        }

        String numeroFrete = frete.getNumeroFrete().trim().toUpperCase();
        if (!numeroFrete.matches("^[A-Z0-9-]{4,20}$")) {
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
