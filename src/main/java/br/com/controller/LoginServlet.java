package br.com.controller;

import br.com.dao.ClienteDAO;
import br.com.model.Cliente;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import java.io.IOException;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private ClienteDAO clienteDAO = new ClienteDAO(); // Usando o seu DAO de cliente

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String senha = req.getParameter("senha");

        // Autentica o Cliente
        Cliente cliente = clienteDAO.autenticar(email, senha);

        if (cliente != null) {
            HttpSession session = req.getSession();
            // Guardamos o objeto Cliente inteiro na sessão
            session.setAttribute("usuarioAutenticado", cliente);
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
