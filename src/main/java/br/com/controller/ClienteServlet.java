package br.com.controller;

import br.com.dao.ClienteDAO;
import br.com.dao.UsuarioDAO;
import br.com.model.Cliente;
import br.com.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import java.io.IOException;
import java.util.List;
import java.time.LocalDateTime;

@WebServlet("/clientes")
public class ClienteServlet extends HttpServlet {

    private ClienteDAO clienteDAO = new ClienteDAO();
    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String acao = req.getParameter("acao");

        if ("novo".equals(acao)) {
            List<Usuario> usuarios = usuarioDAO.listarUsuariosSemCliente();
            req.setAttribute("usuarios", usuarios);
            req.getRequestDispatcher("/WEB-INF/jsp/cliente/cadastroCliente.jsp").forward(req, resp);
            return;
        }

        if ("editar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                Cliente cliente = clienteDAO.buscarPorId(Integer.parseInt(idParam));
                req.setAttribute("cliente", cliente);
            }
            List<Usuario> usuarios = usuarioDAO.listarUsuariosNaoAdmin();
            req.setAttribute("usuarios", usuarios);
            req.getRequestDispatcher("/WEB-INF/jsp/cliente/cadastroCliente.jsp").forward(req, resp);
            return;
        }

        if("deletar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                clienteDAO.deletar(Integer.parseInt(idParam));
            }
            resp.sendRedirect("clientes");
            return;
        }

        List<Cliente> clientes = clienteDAO.listarTodos();

        req.setAttribute("clientes", clientes);

        req.getRequestDispatcher("/WEB-INF/jsp/cliente/cliente.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Cliente cliente = new Cliente();

        String idParam = req.getParameter("id");
        boolean isEdicao = idParam != null && !idParam.isEmpty();

        if (isEdicao) {
            cliente.setId(Integer.parseInt(idParam));
        }

        cliente.setRazaoSocial(req.getParameter("razaoSocial"));
        cliente.setNomeFantasia(req.getParameter("nomeFantasia"));
        cliente.setDocumento(req.getParameter("documento"));
        cliente.setInscricaoEstadual(req.getParameter("inscricaoEstadual"));
        cliente.setEmail(req.getParameter("email"));
        cliente.setTelefone(req.getParameter("telefone"));
        cliente.setAtivo(true);

        String usuarioIdParam = req.getParameter("usuarioId");
        Integer usuarioId = null;
        
        if (usuarioIdParam != null && !usuarioIdParam.isEmpty() && !usuarioIdParam.equals("0")) {
            usuarioId = Integer.parseInt(usuarioIdParam);
        }

        if (isEdicao) {
            Cliente clienteAntigo = clienteDAO.buscarPorId(cliente.getId());
            if (clienteAntigo != null) {
                List<Usuario> usuariosAntigos = usuarioDAO.listarTodos();
                for (Usuario u : usuariosAntigos) {
                    if (u.getClienteId() != null && u.getClienteId().equals(cliente.getId())) {
                        usuarioDAO.atualizarClienteDoUsuario(u.getId(), null);
                        break;
                    }
                }
            }
            
            clienteDAO.atualizar(cliente);
            
            if (usuarioId != null) {
                usuarioDAO.atualizarClienteDoUsuario(usuarioId, cliente.getId());
            }
        } else {
            cliente.setCriadoEm(LocalDateTime.now());
            clienteDAO.salvar(cliente);
            
            if (usuarioId != null) {
                usuarioDAO.atualizarClienteDoUsuario(usuarioId, cliente.getId());
            }
        }

        resp.sendRedirect("clientes");
    }

    public void delete(Integer id) {
        clienteDAO.deletar(id);
    }
}