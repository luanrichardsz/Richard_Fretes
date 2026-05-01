package br.com.usuario;

import br.com.usuario.UsuarioBO;
import br.com.usuario.UsuarioDAO;
import br.com.exception.CadastroException;
import br.com.exception.NegocioException;
import br.com.usuario.Usuario;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/minhaConta")
public class ContaServlet extends HttpServlet {
    
    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private UsuarioBO usuarioBO = new UsuarioBO(usuarioDAO);
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioAutenticado");
        if (usuario == null) {
            resp.sendRedirect("login");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioAutenticado");
        
        if (usuario == null) {
            resp.sendRedirect("login");
            return;
        }
        
        String acao = req.getParameter("acao");
        
        if ("atualizarPerfil".equals(acao)) {
            atualizarPerfil(req, resp, usuario);
        } else if ("alterarSenha".equals(acao)) {
            alterarSenha(req, resp, usuario);
        } else {
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
        }
    }

    private void atualizarPerfil(HttpServletRequest req, HttpServletResponse resp, Usuario usuario) 
            throws ServletException, IOException {
        try {
            usuarioBO.atualizarPerfil(usuario, req.getParameter("usuario"), req.getParameter("email"));
            req.setAttribute("sucesso", "Perfil atualizado com sucesso!");
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
        } catch (CadastroException e) {
            req.setAttribute("erro", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
        }
    }

    private void alterarSenha(HttpServletRequest req, HttpServletResponse resp, Usuario usuario) 
            throws ServletException, IOException {
        try {
            usuarioBO.alterarSenha(
                usuario,
                req.getParameter("senhaAtual"),
                req.getParameter("novaSenha"),
                req.getParameter("confirmarSenha")
            );
            req.setAttribute("sucesso", "Senha alterada com sucesso!");
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
        } catch (NegocioException e) {
            req.setAttribute("erro", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
        }
    }
}
