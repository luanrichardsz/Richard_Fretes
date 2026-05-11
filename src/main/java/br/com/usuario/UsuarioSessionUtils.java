package br.com.usuario;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public final class UsuarioSessionUtils {

    private static final UsuarioDAO USUARIO_DAO = new UsuarioDAO();

    private UsuarioSessionUtils() {
    }

    public static Usuario obterUsuarioLogado(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuarioAutenticado");
        if (usuario == null) {
            return null;
        }

        if (!usuario.isAdmin() && usuario.getClienteId() == null && usuario.getEmail() != null) {
            Usuario usuarioAtualizado = USUARIO_DAO.buscarPorEmail(usuario.getEmail().trim());
            if (usuarioAtualizado != null) {
                usuarioAtualizado.setSenha(null);
                session.setAttribute("usuarioAutenticado", usuarioAtualizado);
                return usuarioAtualizado;
            }
        }

        return usuario;
    }
}
