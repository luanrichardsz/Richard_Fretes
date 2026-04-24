package br.com.controller;

import br.com.dao.ClienteDAO;
import br.com.model.Cliente;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import java.io.IOException;
import java.util.List;
import java.time.LocalDateTime;
import br.com.model.Cliente.*;

@WebServlet("/clientes")
public class ClienteServlet extends HttpServlet {

    private ClienteDAO clienteDAO = new ClienteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String acao = req.getParameter("acao");

        if ("novo".equals(acao)) {
            req.getRequestDispatcher("jsp/cliente/cadastroCliente.jsp").forward(req, resp);
            return;
        }

        if ("editar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                Cliente cliente = clienteDAO.buscarPorId(Integer.parseInt(idParam));
                req.setAttribute("cliente", cliente);
            }
            req.getRequestDispatcher("jsp/cliente/cadastroCliente.jsp").forward(req, resp);
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

        req.getRequestDispatcher("jsp/cliente/cliente.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Cliente cliente = new Cliente();

        // Verificar se é uma atualização (edição) ou novo cliente
        String idParam = req.getParameter("id");
        boolean isEdicao = idParam != null && !idParam.isEmpty();

        if (isEdicao) {
            cliente.setId(Integer.parseInt(idParam));
        }

        cliente.setTipoPessoa(
            TipoPessoa.valueOf(req.getParameter("tipoPessoa"))
        );

        cliente.setTipo(
            TipoEntrega.valueOf(req.getParameter("tipoEntrega"))
        );

        cliente.setRazaoSocial(req.getParameter("razaoSocial"));
        cliente.setNomeFantasia(req.getParameter("nomeFantasia"));
        cliente.setDocumento(req.getParameter("documento"));
        cliente.setInscricaoEstadual(req.getParameter("inscricaoEstadual"));
        cliente.setEmail(req.getParameter("email"));
        cliente.setTelefone(req.getParameter("telefone"));

        cliente.setAtivo(
            Boolean.parseBoolean(req.getParameter("ativo"))
        );

        if (!isEdicao) {
            // 🔥 MUITO IMPORTANTE (seu DAO exige isso para novo cliente)
            cliente.setCriadoEm(LocalDateTime.now());
            clienteDAO.salvar(cliente);
        } else {
            clienteDAO.atualizar(cliente);
        }

        resp.sendRedirect("clientes");
    }

    public void delete(Integer id) {
        clienteDAO.deletar(id);
    }
}