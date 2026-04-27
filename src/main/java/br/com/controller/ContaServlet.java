package br.com.controller;

import br.com.dao.UsuarioDAO;
import br.com.model.Usuario;
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
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
        
        String novoUsuario = req.getParameter("usuario");
        String novoEmail = req.getParameter("email");
        
        if (novoUsuario == null || novoUsuario.trim().isEmpty() ||
            novoEmail == null || novoEmail.trim().isEmpty()) {
            req.setAttribute("erro", "Nome de usuário e e-mail são obrigatórios.");
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
            return;
        }
        
        if (!novoEmail.equals(usuario.getEmail()) && usuarioDAO.existeEmail(novoEmail)) {
            req.setAttribute("erro", "Este e-mail já está registrado no sistema.");
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
            return;
        }
        
        try {
            usuarioDAO.atualizarPerfil(usuario.getId(), novoUsuario, novoEmail);
            
            usuario.setUsuario(novoUsuario);
            usuario.setEmail(novoEmail);
            
            req.setAttribute("sucesso", "Perfil atualizado com sucesso!");
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao atualizar perfil. Tente novamente.");
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
        }
    }

    private void alterarSenha(HttpServletRequest req, HttpServletResponse resp, Usuario usuario) 
            throws ServletException, IOException {
        
        String senhaAtual = req.getParameter("senhaAtual");
        String novaSenha = req.getParameter("novaSenha");
        String confirmarSenha = req.getParameter("confirmarSenha");
        
        if (senhaAtual == null || senhaAtual.trim().isEmpty() ||
            novaSenha == null || novaSenha.trim().isEmpty() ||
            confirmarSenha == null || confirmarSenha.trim().isEmpty()) {
            req.setAttribute("erro", "Todos os campos de senha são obrigatórios.");
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
            return;
        }
        
        if (novaSenha.length() < 6) {
            req.setAttribute("erro", "A nova senha deve ter no mínimo 6 caracteres.");
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
            return;
        }
        
        if (!novaSenha.equals(confirmarSenha)) {
            req.setAttribute("erro", "As novas senhas não conferem.");
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
            return;
        }
        
        Usuario usuarioAutenticado = usuarioDAO.autenticar(usuario.getEmail(), senhaAtual);
        if (usuarioAutenticado == null) {
            req.setAttribute("erro", "Senha atual está incorreta.");
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
            return;
        }
        
        try {
            usuarioDAO.atualizarSenha(usuario.getId(), novaSenha);
            req.setAttribute("sucesso", "Senha alterada com sucesso!");
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao alterar senha. Tente novamente.");
            req.getRequestDispatcher("/WEB-INF/jsp/usuario/minhaConta.jsp").forward(req, resp);
        }
    }
}
