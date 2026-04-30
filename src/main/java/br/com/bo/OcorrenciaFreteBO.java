package br.com.bo;

import br.com.dao.OcorrenciaFreteDAO;
import br.com.exception.FreteException;
import br.com.model.OcorrenciaFrete;
import br.com.util.ValidationUtils;

public class OcorrenciaFreteBO {

    private final OcorrenciaFreteDAO ocorrenciaDAO;

    public OcorrenciaFreteBO() {
        this(new OcorrenciaFreteDAO());
    }

    public OcorrenciaFreteBO(OcorrenciaFreteDAO ocorrenciaDAO) {
        this.ocorrenciaDAO = ocorrenciaDAO;
    }

    public void salvar(OcorrenciaFrete ocorrencia) throws FreteException {
        validarOcorrencia(ocorrencia);
        ocorrenciaDAO.salvar(ocorrencia);
    }

    public void atualizar(OcorrenciaFrete ocorrencia) throws FreteException {
        validarOcorrencia(ocorrencia);
        ocorrenciaDAO.atualizar(ocorrencia);
    }

    private void validarOcorrencia(OcorrenciaFrete ocorrencia) throws FreteException {
        if (ocorrencia == null) {
            throw new FreteException("Ocorrência inválida.");
        }

        if (ocorrencia.getFreteId() == null || ocorrencia.getFreteId() <= 0) {
            throw new FreteException("Frete inválido.");
        }

        if (ocorrencia.getTipo() == null) {
            throw new FreteException("Tipo da ocorrência é obrigatório.");
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
    }
}
