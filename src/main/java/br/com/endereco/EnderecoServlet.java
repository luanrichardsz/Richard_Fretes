package br.com.endereco;

import br.com.endereco.EnderecoBO;
import br.com.cliente.ClienteDAO;
import br.com.endereco.EnderecoDAO;
import br.com.exception.CadastroException;
import br.com.cliente.Cliente;
import br.com.endereco.Endereco;
import br.com.usuario.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/enderecos")
public class EnderecoServlet extends HttpServlet {

    private EnderecoDAO enderecoDAO = new EnderecoDAO();
    private EnderecoBO enderecoBO = new EnderecoBO(enderecoDAO);

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        Usuario usuarioLogado = (Usuario) req.getSession().getAttribute("usuarioAutenticado");

        if (usuarioLogado == null) {
            resp.sendRedirect("login");
            return;
        }

        String acao = req.getParameter("acao");

        if ("novo".equals(acao)) {
            processarNovo(req, resp, usuarioLogado);
            return;
        }

        if ("editar".equals(acao)) {
            processarEdicao(req, resp, usuarioLogado);
            return;
        }

        if ("deletar".equals(acao)) {
            processarExclusao(req, resp);
            return;
        }

        processarListagem(req, resp, usuarioLogado);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        Usuario usuarioLogado = (Usuario) req.getSession().getAttribute("usuarioAutenticado");
        
        if(usuarioLogado == null) {
            resp.sendRedirect("login");
            return;
        }

        Endereco endereco = new Endereco();

        // Verificar se é uma atualização (edição) ou novo endereço
        String idParam = req.getParameter("id");
        boolean isEdicao = idParam != null && !idParam.trim().isEmpty() && !"null".equalsIgnoreCase(idParam.trim());

        if (isEdicao) {
            endereco.setId(obterIdEndereco(req));
        }

        if (usuarioLogado.isAdmin()) {
            String clienteIdParam = req.getParameter("clienteId");
            if (clienteIdParam != null && !clienteIdParam.isEmpty()) {
                endereco.setClienteId(Integer.parseInt(clienteIdParam));
            }
        } else {
            endereco.setClienteId(usuarioLogado.getClienteId());
        }

        endereco.setCep(req.getParameter("cep"));
        endereco.setLogradouro(req.getParameter("logradouro"));
        endereco.setNumero(req.getParameter("numero"));
        endereco.setComplemento(req.getParameter("complemento"));
        endereco.setBairro(req.getParameter("bairro"));
        endereco.setMunicipio(req.getParameter("municipio"));
        endereco.setCodigoIbge(req.getParameter("codigoIbge"));
        endereco.setUf(req.getParameter("uf"));
        endereco.setPontoReferencia(req.getParameter("pontoReferencia"));

        try {
            if (!isEdicao) {
                enderecoBO.salvar(endereco);
            } else {
                enderecoBO.atualizar(endereco);
            }

            resp.sendRedirect("enderecos");
        } catch (CadastroException e) {
            req.setAttribute("erro", e.getMessage());
            carregarFormulario(req, resp, usuarioLogado, endereco);
        }
    }

    public void delete(Integer id) {
        enderecoDAO.deletar(id);
    }

    private void processarNovo(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        carregarFormulario(req, resp, usuarioLogado, null);
    }

    private void processarEdicao(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        try {
            Integer enderecoId = obterIdEndereco(req);
            Endereco endereco = buscarEnderecoOuLancarErro(enderecoId);
            carregarFormulario(req, resp, usuarioLogado, endereco);
        } catch (NumberFormatException e) {
            redirecionarParaListagemComErro(req, resp, "Id do endereço inválido.");
        } catch (CadastroException e) {
            redirecionarParaListagemComErro(req, resp, e.getMessage());
        }
    }

    private void processarExclusao(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Integer enderecoId = obterIdEndereco(req);
            enderecoDAO.deletar(enderecoId);
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("erro", "Id do endereço inválido.");
        }
        resp.sendRedirect("enderecos");
    }

    private void processarListagem(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        Object erroSessao = req.getSession().getAttribute("erro");
        if (erroSessao != null) {
            req.setAttribute("erro", erroSessao);
            req.getSession().removeAttribute("erro");
        }

        List<Endereco> enderecos;

        if (usuarioLogado.isAdmin()) {
            enderecos = enderecoDAO.listarTodos();
            List<Cliente> clientes = new ClienteDAO().listarTodos();
            Map<Integer, String> clientesPorId = new HashMap<>();
            for (Cliente cliente : clientes) {
                clientesPorId.put(cliente.getId(), cliente.getRazaoSocial());
            }
            for (Endereco endereco : enderecos) {
                endereco.setClienteRazaoSocial(clientesPorId.get(endereco.getClienteId()));
            }
        } else if (usuarioLogado.getClienteId() != null) {
            enderecos = enderecoDAO.listarPorCliente(usuarioLogado.getClienteId());
        } else {
            enderecos = new ArrayList<>();
        }

        req.setAttribute("enderecos", enderecos);
        req.getRequestDispatcher("/WEB-INF/jsp/endereco/endereco.jsp").forward(req, resp);
    }

    private void redirecionarParaListagemComErro(HttpServletRequest req, HttpServletResponse resp, String mensagem)
            throws IOException {
        req.getSession().setAttribute("erro", mensagem);
        resp.sendRedirect("enderecos");
    }

    private Integer obterIdEndereco(HttpServletRequest req) {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            throw new NumberFormatException("Id do endereço ausente.");
        }
        return Integer.parseInt(idParam.trim());
    }

    private Endereco buscarEnderecoOuLancarErro(Integer enderecoId) throws CadastroException {
        Endereco endereco = enderecoDAO.buscarPorId(enderecoId);
        if (endereco == null) {
            throw new CadastroException("Endereço não encontrado.");
        }
        return endereco;
    }

    private void carregarFormulario(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado, Endereco endereco)
            throws ServletException, IOException {
        req.setAttribute("endereco", endereco);

        if (usuarioLogado.isAdmin()) {
            List<Cliente> clientes = new ClienteDAO().listarTodos();
            req.setAttribute("clientes", clientes);
        }

        req.getRequestDispatcher("/WEB-INF/jsp/endereco/cadastroEndereco.jsp").forward(req, resp);
    }
}
