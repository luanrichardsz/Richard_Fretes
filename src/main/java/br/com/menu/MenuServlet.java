package br.com.menu;

import br.com.cliente.ClienteDAO;
import br.com.frete.FreteDAO;
import br.com.motorista.MotoristaDAO;
import br.com.usuario.Usuario;
import br.com.veiculo.VeiculoDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {
    private final FreteDAO freteDAO = new FreteDAO();
    private final MotoristaDAO motoristaDAO = new MotoristaDAO();
    private final VeiculoDAO veiculoDAO = new VeiculoDAO();
    private final ClienteDAO clienteDAO = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        HttpSession session = req.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuarioAutenticado");
        if (usuario == null) {
            resp.sendRedirect("login");
            return;
        }

        if (usuario.isAdmin()) {
            req.setAttribute("fretes", freteDAO.listarTodos());
            req.setAttribute("motoristas", motoristaDAO.listarTodos());
            req.setAttribute("veiculos", veiculoDAO.listarTodos());
            req.setAttribute("clientes", clienteDAO.listarTodos());
        } else if (usuario.getClienteId() != null) {
            req.setAttribute("fretes", freteDAO.listarPorCliente(usuario.getClienteId()));
            req.setAttribute("motoristas", motoristaDAO.listarPorCliente(usuario.getClienteId()));
            req.setAttribute("veiculos", veiculoDAO.listarPorCliente(usuario.getClienteId()));
            req.setAttribute("clientes", new ArrayList<>());
        } else {
            req.setAttribute("fretes", new ArrayList<>());
            req.setAttribute("motoristas", new ArrayList<>());
            req.setAttribute("veiculos", new ArrayList<>());
            req.setAttribute("clientes", new ArrayList<>());
        }

        req.getRequestDispatcher("/WEB-INF/jsp/menu/menu.jsp").forward(req, resp);
    }
}
