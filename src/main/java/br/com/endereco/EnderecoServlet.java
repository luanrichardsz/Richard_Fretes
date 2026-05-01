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

        Usuario usuarioLogado = (Usuario) req.getSession().getAttribute("usuarioAutenticado");
        
        if(usuarioLogado == null) {
            resp.sendRedirect("login");
            return;
        }

        String acao = req.getParameter("acao");

        if ("novo".equals(acao)) {
            carregarFormulario(req, resp, usuarioLogado, null);
            return;
        }

        if ("editar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                Endereco endereco = enderecoDAO.buscarPorId(Integer.parseInt(idParam));
                req.setAttribute("endereco", endereco);
            }
            carregarFormulario(req, resp, usuarioLogado, (Endereco) req.getAttribute("endereco"));
            return;
        }

        if("deletar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                enderecoDAO.deletar(Integer.parseInt(idParam));
            }
            resp.sendRedirect("enderecos");
            return;
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
        } else {
            if (usuarioLogado.getClienteId() != null) {
                enderecos = enderecoDAO.listarPorCliente(usuarioLogado.getClienteId());
            } else {
                enderecos = new ArrayList<>();
            }
        }

        req.setAttribute("enderecos", enderecos);

        req.getRequestDispatcher("/WEB-INF/jsp/endereco/endereco.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

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
            endereco.setId(Integer.parseInt(idParam.trim()));
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
