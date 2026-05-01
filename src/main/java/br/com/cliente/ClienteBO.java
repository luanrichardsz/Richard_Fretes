package br.com.cliente;

import br.com.exception.CadastroException;
import br.com.frete.FreteDAO;
import br.com.util.ValidationUtils;

public class ClienteBO {

    private final ClienteDAO clienteDAO;
    private final FreteDAO freteDAO;

    public ClienteBO() {
        this(new ClienteDAO(), new FreteDAO());
    }

    public ClienteBO(ClienteDAO clienteDAO) {
        this(clienteDAO, new FreteDAO());
    }

    public ClienteBO(ClienteDAO clienteDAO, FreteDAO freteDAO) {
        this.clienteDAO = clienteDAO;
        this.freteDAO = freteDAO;
    }

    public void salvar(Cliente cliente) throws CadastroException {
        validarCliente(cliente, false);
        clienteDAO.salvar(cliente);
    }

    public void atualizar(Cliente cliente) throws CadastroException {
        validarCliente(cliente, true);
        clienteDAO.atualizar(cliente);
    }

    public void deletar(Integer clienteId) throws CadastroException {
        if (clienteId == null || clienteId <= 0) {
            throw new CadastroException("Cliente inválido.");
        }

        if (freteDAO.existeFreteParaCliente(clienteId)) {
            throw new CadastroException("Não é permitido excluir um cliente que possui fretes.");
        }

        clienteDAO.deletar(clienteId);
    }

    private void validarCliente(Cliente cliente, boolean emEdicao) throws CadastroException {
        if (cliente == null) {
            throw new CadastroException("Cliente inválido.");
        }

        if (ValidationUtils.estaVazio(cliente.getRazaoSocial())) {
            throw new CadastroException("Razão social é obrigatória.");
        }

        if (ValidationUtils.estaVazio(cliente.getDocumento())) {
            throw new CadastroException("CNPJ é obrigatório.");
        }

        String documentoLimpo = ValidationUtils.manterSomenteDigitos(cliente.getDocumento());
        if (!ValidationUtils.cnpjValido(documentoLimpo)) {
            throw new CadastroException("CNPJ inválido.");
        }

        if (clienteDAO.existeDocumentoParaOutroCliente(documentoLimpo, emEdicao ? cliente.getId() : null)) {
            throw new CadastroException("Já existe um cliente cadastrado com este CNPJ.");
        }

        if (cliente.getInscricaoEstadual() != null && !cliente.getInscricaoEstadual().trim().isEmpty()) {
            String ieLimpa = ValidationUtils.manterSomenteDigitos(cliente.getInscricaoEstadual());
            if (ieLimpa.length() > 14) {
                throw new CadastroException("Inscrição estadual inválida.");
            }
            cliente.setInscricaoEstadual(ieLimpa);
        }

        if (ValidationUtils.estaVazio(cliente.getEmail())) {
            throw new CadastroException("Email é obrigatório.");
        }

        if (!ValidationUtils.emailValido(cliente.getEmail())) {
            throw new CadastroException("Email inválido.");
        }

        if (ValidationUtils.estaVazio(cliente.getTelefone())) {
            throw new CadastroException("Telefone é obrigatório.");
        }

        String telefoneLimpo = ValidationUtils.manterSomenteDigitos(cliente.getTelefone());
        if (!ValidationUtils.telefoneValido(telefoneLimpo)) {
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
}
