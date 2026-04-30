package br.com.bo;

import br.com.dao.EnderecoDAO;
import br.com.exception.CadastroException;
import br.com.model.Endereco;
import br.com.util.ValidationUtils;

public class EnderecoBO {

    private final EnderecoDAO enderecoDAO;

    public EnderecoBO() {
        this(new EnderecoDAO());
    }

    public EnderecoBO(EnderecoDAO enderecoDAO) {
        this.enderecoDAO = enderecoDAO;
    }

    public void salvar(Endereco endereco) throws CadastroException {
        validarEndereco(endereco);
        enderecoDAO.salvar(endereco);
    }

    public void atualizar(Endereco endereco) throws CadastroException {
        validarEndereco(endereco);
        enderecoDAO.atualizar(endereco);
    }

    private void validarEndereco(Endereco endereco) throws CadastroException {
        if (endereco == null) {
            throw new CadastroException("Endereço inválido.");
        }

        if (endereco.getClienteId() == null) {
            throw new CadastroException("Cliente responsável pelo endereço é obrigatório.");
        }

        String cep = ValidationUtils.manterSomenteDigitos(endereco.getCep());
        if (cep.length() != 8) {
            throw new CadastroException("CEP inválido.");
        }

        if (ValidationUtils.estaVazio(endereco.getLogradouro())) {
            throw new CadastroException("Logradouro é obrigatório.");
        }

        if (ValidationUtils.estaVazio(endereco.getBairro())) {
            throw new CadastroException("Bairro é obrigatório.");
        }

        if (ValidationUtils.estaVazio(endereco.getMunicipio())) {
            throw new CadastroException("Município é obrigatório.");
        }

        if (ValidationUtils.estaVazio(endereco.getUf()) || !endereco.getUf().trim().matches("^[A-Za-z]{2}$")) {
            throw new CadastroException("UF inválida.");
        }

        if (!ValidationUtils.estaVazio(endereco.getCodigoIbge())) {
            String codigoIbge = ValidationUtils.manterSomenteDigitos(endereco.getCodigoIbge());
            if (codigoIbge.length() != 7) {
                throw new CadastroException("Código IBGE inválido.");
            }
            endereco.setCodigoIbge(codigoIbge);
        }

        endereco.setCep(cep);
        endereco.setLogradouro(endereco.getLogradouro().trim());
        endereco.setBairro(endereco.getBairro().trim());
        endereco.setMunicipio(endereco.getMunicipio().trim());
        endereco.setUf(endereco.getUf().trim().toUpperCase());

        if (ValidationUtils.estaVazio(endereco.getNumero())) {
            endereco.setNumero("S/N");
        } else {
            endereco.setNumero(endereco.getNumero().trim());
        }

        if (endereco.getComplemento() != null) {
            endereco.setComplemento(endereco.getComplemento().trim());
        }

        if (endereco.getPontoReferencia() != null) {
            endereco.setPontoReferencia(endereco.getPontoReferencia().trim());
        }
    }
}
