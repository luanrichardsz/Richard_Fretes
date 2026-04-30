package br.com.bo;

import br.com.dao.UsuarioDAO;
import br.com.exception.CadastroException;
import br.com.exception.NegocioException;
import br.com.model.Usuario;
import br.com.util.ValidationUtils;

public class UsuarioBO {

    private final UsuarioDAO usuarioDAO;

    public UsuarioBO() {
        this(new UsuarioDAO());
    }

    public UsuarioBO(UsuarioDAO usuarioDAO) {
        this.usuarioDAO = usuarioDAO;
    }

    public void cadastrar(Usuario usuario) throws CadastroException {
        if (usuario == null) {
            throw new CadastroException("Usuário inválido.");
        }

        if (ValidationUtils.estaVazio(usuario.getUsuario())) {
            throw new CadastroException("Nome de usuário é obrigatório.");
        }

        if (ValidationUtils.estaVazio(usuario.getEmail())) {
            throw new CadastroException("Email é obrigatório.");
        }

        if (!ValidationUtils.emailValido(usuario.getEmail().trim())) {
            throw new CadastroException("Email inválido.");
        }

        if (ValidationUtils.estaVazio(usuario.getSenha())) {
            throw new CadastroException("Senha é obrigatória.");
        }

        if (usuario.getSenha().trim().length() < 6) {
            throw new CadastroException("A senha deve ter no mínimo 6 caracteres.");
        }

        if (usuarioDAO.existeEmail(usuario.getEmail().trim())) {
            throw new CadastroException("Este e-mail já está registrado no sistema.");
        }

        usuario.setUsuario(usuario.getUsuario().trim());
        usuario.setEmail(usuario.getEmail().trim());
        usuario.setSenha(usuario.getSenha().trim());
        usuarioDAO.salvar(usuario);
    }

    public Usuario autenticar(String email, String senha) throws NegocioException {
        if (ValidationUtils.estaVazio(email) || ValidationUtils.estaVazio(senha)) {
            throw new NegocioException("Email e senha são obrigatórios.");
        }

        Usuario usuario = usuarioDAO.autenticar(email.trim(), senha);
        if (usuario == null) {
            throw new NegocioException("Credenciais inválidas para Richard Fretes.");
        }

        return usuario;
    }

    public void atualizarPerfil(Usuario usuarioAtual, String novoUsuario, String novoEmail) throws CadastroException {
        if (usuarioAtual == null) {
            throw new CadastroException("Usuário inválido.");
        }

        if (ValidationUtils.estaVazio(novoUsuario) || ValidationUtils.estaVazio(novoEmail)) {
            throw new CadastroException("Nome de usuário e e-mail são obrigatórios.");
        }

        if (!ValidationUtils.emailValido(novoEmail.trim())) {
            throw new CadastroException("Email inválido.");
        }

        if (!novoEmail.trim().equalsIgnoreCase(usuarioAtual.getEmail()) && usuarioDAO.existeEmail(novoEmail.trim())) {
            throw new CadastroException("Este e-mail já está registrado no sistema.");
        }

        usuarioDAO.atualizarPerfil(usuarioAtual.getId(), novoUsuario.trim(), novoEmail.trim());
        usuarioAtual.setUsuario(novoUsuario.trim());
        usuarioAtual.setEmail(novoEmail.trim());
    }

    public void alterarSenha(Usuario usuarioAtual, String senhaAtual, String novaSenha, String confirmarSenha) throws NegocioException {
        if (usuarioAtual == null) {
            throw new NegocioException("Usuário inválido.");
        }

        if (ValidationUtils.estaVazio(senhaAtual) || ValidationUtils.estaVazio(novaSenha) || ValidationUtils.estaVazio(confirmarSenha)) {
            throw new NegocioException("Todos os campos de senha são obrigatórios.");
        }

        if (novaSenha.trim().length() < 6) {
            throw new NegocioException("A nova senha deve ter no mínimo 6 caracteres.");
        }

        if (!novaSenha.equals(confirmarSenha)) {
            throw new NegocioException("As novas senhas não conferem.");
        }

        Usuario autenticado = usuarioDAO.autenticar(usuarioAtual.getEmail(), senhaAtual);
        if (autenticado == null) {
            throw new NegocioException("Senha atual está incorreta.");
        }

        usuarioDAO.atualizarSenha(usuarioAtual.getId(), novaSenha);
    }
}
