package br.com.bo;

import br.com.dao.ClienteDAO;
import br.com.exception.CadastroException;
import br.com.model.Cliente;

public class ClienteBO {

    private final ClienteDAO clienteDAO;

    public ClienteBO() {
        this(new ClienteDAO());
    }

    public ClienteBO(ClienteDAO clienteDAO) {
        this.clienteDAO = clienteDAO;
    }

    public void salvar(Cliente cliente) throws CadastroException {
        validarCliente(cliente, false);
        clienteDAO.salvar(cliente);
    }

    public void atualizar(Cliente cliente) throws CadastroException {
        validarCliente(cliente, true);
        clienteDAO.atualizar(cliente);
    }

    private void validarCliente(Cliente cliente, boolean emEdicao) throws CadastroException {
        if (cliente == null) {
            throw new CadastroException("Cliente inválido.");
        }

        if (estaVazio(cliente.getRazaoSocial())) {
            throw new CadastroException("Razão social é obrigatória.");
        }

        if (estaVazio(cliente.getDocumento())) {
            throw new CadastroException("CNPJ é obrigatório.");
        }

        String documentoLimpo = manterSomenteDigitos(cliente.getDocumento());
        if (!cnpjValido(documentoLimpo)) {
            throw new CadastroException("CNPJ inválido.");
        }

        if (clienteDAO.existeDocumentoParaOutroCliente(documentoLimpo, emEdicao ? cliente.getId() : null)) {
            throw new CadastroException("Já existe um cliente cadastrado com este CNPJ.");
        }

        if (cliente.getInscricaoEstadual() != null && !cliente.getInscricaoEstadual().trim().isEmpty()) {
            String ieLimpa = manterSomenteDigitos(cliente.getInscricaoEstadual());
            if (ieLimpa.length() > 14) {
                throw new CadastroException("Inscrição estadual inválida.");
            }
            cliente.setInscricaoEstadual(ieLimpa);
        }

        if (estaVazio(cliente.getEmail())) {
            throw new CadastroException("Email é obrigatório.");
        }

        if (!emailValido(cliente.getEmail())) {
            throw new CadastroException("Email inválido.");
        }

        if (estaVazio(cliente.getTelefone())) {
            throw new CadastroException("Telefone é obrigatório.");
        }

        String telefoneLimpo = manterSomenteDigitos(cliente.getTelefone());
        if (telefoneLimpo.length() < 10 || telefoneLimpo.length() > 11) {
            throw new CadastroException("Telefone inválido.");
        }

        cliente.setDocumento(documentoLimpo);
        cliente.setTelefone(telefoneLimpo);
        cliente.setEmail(cliente.getEmail().trim());
        cliente.setRazaoSocial(cliente.getRazaoSocial().trim());

        if (cliente.getNomeFantasia() != null) {
            cliente.setNomeFantasia(cliente.getNomeFantasia().trim());
        }
    }

    private boolean estaVazio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }

    private String manterSomenteDigitos(String valor) {
        return valor == null ? "" : valor.replaceAll("\\D", "");
    }

    private boolean emailValido(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    private boolean cnpjValido(String cnpj) {
        if (cnpj == null || cnpj.length() != 14 || cnpj.matches("(\\d)\\1{13}")) {
            return false;
        }

        int digito1 = calcularDigitoCnpj(cnpj, new int[]{5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2});
        int digito2 = calcularDigitoCnpj(cnpj, new int[]{6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2});

        return digito1 == Character.getNumericValue(cnpj.charAt(12))
            && digito2 == Character.getNumericValue(cnpj.charAt(13));
    }

    private int calcularDigitoCnpj(String cnpj, int[] pesos) {
        int soma = 0;

        for (int i = 0; i < pesos.length; i++) {
            soma += Character.getNumericValue(cnpj.charAt(i)) * pesos[i];
        }

        int resto = soma % 11;
        return resto < 2 ? 0 : 11 - resto;
    }
}
