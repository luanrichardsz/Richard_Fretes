package br.com.controller;

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
        

        if (email == null || email.trim().isEmpty() || 
            senha == null || senha.trim().isEmpty()) {
            req.setAttribute("erro", "Email e senha são obrigatórios.");
            req.getRequestDispatcher("/WEB-INF/jsp/login/login.jsp").forward(req, resp);
            return;
        }

        if (usuarioDAO.existeEmail(email)) {
            req.setAttribute("erro", "Este e-mail já está registrado no sistema.");
            req.getRequestDispatcher("/WEB-INF/jsp/login/login.jsp").forward(req, resp);
            return;
        }

        Usuario novoUsuario = new Usuario();
        novoUsuario.setUsuario(nomeUsuario);
        novoUsuario.setEmail(email);
        novoUsuario.setSenha(senha);
        novoUsuario.setAdmin(false);
        novoUsuario.setAtivo(true);

        try {
            usuarioDAO.salvar(novoUsuario);
            req.setAttribute("sucesso", "Cadastro realizado com sucesso! Faça login para continuar.");
            req.getRequestDispatcher("/WEB-INF/jsp/login/login.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("erro", "Erro ao cadastrar usuário. Tente novamente.");
            req.getRequestDispatcher("/WEB-INF/jsp/login/login.jsp").forward(req, resp);
        }
    }

    private void fazerLogin(HttpServletRequest req, HttpServletResponse resp, 
                            String email, String senha) 
            throws ServletException, IOException {
        
        Usuario usuario = usuarioDAO.autenticar(email, senha);

        if (usuario != null) {
            HttpSession session = req.getSession();
            session.setAttribute("usuarioAutenticado", usuario);
            req.getRequestDispatcher("/WEB-INF/jsp/menu/menu.jsp").forward(req, resp);
        } else {
            req.setAttribute("erro", "Credenciais inválidas para Richard Fretes.");
            req.getRequestDispatcher("/WEB-INF/jsp/login/login.jsp").forward(req, resp);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/login/login.jsp").forward(req, resp);
    }
}
