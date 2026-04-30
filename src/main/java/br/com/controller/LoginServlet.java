package br.com.controller;

import br.com.bo.UsuarioBO;
import br.com.exception.CadastroException;
import br.com.exception.NegocioException;
import br.com.dao.UsuarioDAO;
import br.com.model.Usuario;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import java.io.IOException;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    private UsuarioBO usuarioBO = new UsuarioBO(usuarioDAO);

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String nomeUsuario = req.getParameter("usuario");
        String email = req.getParameter("email");
        String senha = req.getParameter("senha");

        if (nomeUsuario != null && !nomeUsuario.trim().isEmpty()) {
            cadastrarUsuario(req, resp, nomeUsuario, email, senha);
        } else {
            fazerLogin(req, resp, email, senha);
        }
    }

    private void cadastrarUsuario(HttpServletRequest req, HttpServletResponse resp, String nomeUsuario, String email, String senha) throws ServletException, IOException {
        Usuario novoUsuario = new Usuario();
        novoUsuario.setUsuario(nomeUsuario);
        novoUsuario.setEmail(email);
        novoUsuario.setSenha(senha);
        novoUsuario.setAdmin(false);
        novoUsuario.setAtivo(true);

        try {
            usuarioBO.cadastrar(novoUsuario);
            req.setAttribute("sucesso", "Cadastro realizado com sucesso! Faça login para continuar.");
            req.getRequestDispatcher("/WEB-INF/jsp/login/login.jsp").forward(req, resp);
        } catch (CadastroException e) {
            req.setAttribute("erro", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/login/login.jsp").forward(req, resp);
        }
    }

    private void fazerLogin(HttpServletRequest req, HttpServletResponse resp, 
                            String email, String senha) 
            throws ServletException, IOException {
        
        try {
            Usuario usuario = usuarioBO.autenticar(email, senha);
            HttpSession session = req.getSession();
            session.setAttribute("usuarioAutenticado", usuario);
            req.getRequestDispatcher("/WEB-INF/jsp/menu/menu.jsp").forward(req, resp);
        } catch (NegocioException e) {
            req.setAttribute("erro", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/login/login.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/login/login.jsp").forward(req, resp);
    }
}
