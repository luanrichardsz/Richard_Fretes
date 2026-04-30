package br.com.cliente;

import br.com.cliente.ClienteBO;
import br.com.cliente.ClienteDAO;
import br.com.usuario.UsuarioDAO;
import br.com.exception.CadastroException;
import br.com.cliente.Cliente;
import br.com.usuario.Usuario;

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
    private ClienteBO clienteBO = new ClienteBO(clienteDAO);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String acao = req.getParameter("acao");

        if ("novo".equals(acao)) {
            carregarFormulario(req, resp, null, false);
            return;
        }

        if ("editar".equals(acao)) {
            String idParam = req.getParameter("id");
            Cliente cliente = null;
            if (idParam != null && !idParam.isEmpty()) {
                cliente = clienteDAO.buscarPorId(Integer.parseInt(idParam));
            }
            carregarFormulario(req, resp, cliente, true);
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
        boolean isEdicao = idParam != null && !idParam.trim().isEmpty() && !"null".equalsIgnoreCase(idParam.trim());

        if (isEdicao) {
            cliente.setId(Integer.parseInt(idParam.trim()));
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

        try {
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

                clienteBO.atualizar(cliente);

                if (usuarioId != null) {
                    usuarioDAO.atualizarClienteDoUsuario(usuarioId, cliente.getId());
                }
            } else {
                cliente.setCriadoEm(LocalDateTime.now());
                clienteBO.salvar(cliente);

                if (usuarioId != null) {
                    usuarioDAO.atualizarClienteDoUsuario(usuarioId, cliente.getId());
                }
            }

            resp.sendRedirect("clientes");
        } catch (CadastroException e) {
            req.setAttribute("erro", e.getMessage());
            carregarFormulario(req, resp, cliente, isEdicao);
        }
    }

    public void delete(Integer id) {
        clienteDAO.deletar(id);
    }

    private void carregarFormulario(HttpServletRequest req, HttpServletResponse resp, Cliente cliente, boolean isEdicao)
            throws ServletException, IOException {
        req.setAttribute("cliente", cliente);

        List<Usuario> usuarios = isEdicao
            ? usuarioDAO.listarUsuariosNaoAdmin()
            : usuarioDAO.listarUsuariosSemCliente();

        req.setAttribute("usuarios", usuarios);
        req.getRequestDispatcher("/WEB-INF/jsp/cliente/cadastroCliente.jsp").forward(req, resp);
    }
}
