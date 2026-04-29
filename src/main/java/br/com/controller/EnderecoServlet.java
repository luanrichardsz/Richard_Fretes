package br.com.controller;

import br.com.dao.EnderecoDAO;
import br.com.model.Endereco;
import br.com.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/enderecos")
public class EnderecoServlet extends HttpServlet {

    private EnderecoDAO enderecoDAO = new EnderecoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Usuario usuarioLogado = (Usuario) req.getSession().getAttribute("usuarioAutenticado");
        
        if(usuarioLogado == null) {
            resp.sendRedirect("login");
            return;
        }

        String acao = req.getParameter("acao");

        if ("novo".equals(acao)) {
            req.getRequestDispatcher("/WEB-INF/jsp/endereco/cadastroEndereco.jsp").forward(req, resp);
            return;
        }

        if ("editar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                Endereco endereco = enderecoDAO.buscarPorId(Integer.parseInt(idParam));
                req.setAttribute("endereco", endereco);
            }
            req.getRequestDispatcher("/WEB-INF/jsp/endereco/cadastroEndereco.jsp").forward(req, resp);
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
        boolean isEdicao = idParam != null && !idParam.isEmpty();

        if (isEdicao) {
            endereco.setId(Integer.parseInt(idParam));
        }

        if (usuarioLogado.isAdmin()) {
            endereco.setClienteId(Integer.parseInt(req.getParameter("clienteId")));
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

        if (!isEdicao) {
            enderecoDAO.salvar(endereco);
        } else {
            enderecoDAO.atualizar(endereco);
        }

        resp.sendRedirect("enderecos");
    }

    public void delete(Integer id) {
        enderecoDAO.deletar(id);
    }
}
