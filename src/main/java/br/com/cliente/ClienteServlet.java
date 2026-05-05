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
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String acao = req.getParameter("acao");

        if ("novo".equals(acao)) {
            processarNovo(req, resp);
            return;
        }

        if ("editar".equals(acao)) {
            processarEdicao(req, resp);
            return;
        }

        if ("deletar".equals(acao)) {
            processarExclusao(req, resp);
            return;
        }

        processarListagem(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        Cliente cliente = new Cliente();

        String idParam = req.getParameter("id");
        boolean isEdicao = idParam != null && !idParam.trim().isEmpty() && !"null".equalsIgnoreCase(idParam.trim());

        if (isEdicao) {
            cliente.setId(obterIdCliente(req));
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

    private void processarNovo(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        carregarFormulario(req, resp, null, false);
    }

    private void processarEdicao(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Integer clienteId = obterIdCliente(req);
            Cliente cliente = buscarClienteOuLancarErro(clienteId);
            carregarFormulario(req, resp, cliente, true);
        } catch (NumberFormatException e) {
            redirecionarParaListagemComErro(req, resp, "Id do cliente inválido.");
        } catch (CadastroException e) {
            redirecionarParaListagemComErro(req, resp, e.getMessage());
        }
    }

    private void processarExclusao(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Integer clienteId = obterIdCliente(req);
            clienteBO.deletar(clienteId);
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("erro", "Id do cliente inválido.");
        } catch (CadastroException e) {
            req.getSession().setAttribute("erro", e.getMessage());
        }
        resp.sendRedirect("clientes");
    }

    private void processarListagem(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Object erroSessao = req.getSession().getAttribute("erro");
        if (erroSessao != null) {
            req.setAttribute("erro", erroSessao);
            req.getSession().removeAttribute("erro");
        }

        List<Cliente> clientes = clienteDAO.listarTodos();
        req.setAttribute("clientes", clientes);
        req.getRequestDispatcher("/WEB-INF/jsp/cliente/cliente.jsp").forward(req, resp);
    }

    private void redirecionarParaListagemComErro(HttpServletRequest req, HttpServletResponse resp, String mensagem)
            throws IOException {
        req.getSession().setAttribute("erro", mensagem);
        resp.sendRedirect("clientes");
    }

    private Integer obterIdCliente(HttpServletRequest req) {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            throw new NumberFormatException("Id do cliente ausente.");
        }
        return Integer.parseInt(idParam.trim());
    }

    private Cliente buscarClienteOuLancarErro(Integer clienteId) throws CadastroException {
        Cliente cliente = clienteDAO.buscarPorId(clienteId);
        if (cliente == null) {
            throw new CadastroException("Cliente não encontrado.");
        }
        return cliente;
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
