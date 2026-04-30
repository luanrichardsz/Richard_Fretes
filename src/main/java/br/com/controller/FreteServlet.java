package br.com.controller;

import br.com.bo.FreteBO;
import br.com.dao.ClienteDAO;
import br.com.dao.EnderecoDAO;
import br.com.dao.FreteDAO;
import br.com.dao.MotoristaDAO;
import br.com.dao.VeiculoDAO;
import br.com.exception.FreteException;
import br.com.model.Cliente;
import br.com.model.Endereco;
import br.com.model.Frete;
import br.com.model.Frete.StatusFrete;
import br.com.model.Motorista;
import br.com.model.Usuario;
import br.com.model.Veiculo;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/fretes")
public class FreteServlet extends HttpServlet {

    private FreteDAO freteDAO = new FreteDAO();
    private FreteBO freteBO = new FreteBO(freteDAO);
    private ClienteDAO clienteDAO = new ClienteDAO();
    private EnderecoDAO enderecoDAO = new EnderecoDAO();
    private MotoristaDAO motoristaDAO = new MotoristaDAO();
    private VeiculoDAO veiculoDAO = new VeiculoDAO();

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
                Frete frete = freteDAO.buscarPorId(Integer.parseInt(idParam));
                req.setAttribute("frete", frete);
            }
            carregarFormulario(req, resp, usuarioLogado, (Frete) req.getAttribute("frete"));
            return;
        }

        if("deletar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                freteDAO.deletar(Integer.parseInt(idParam));
            }
            resp.sendRedirect("fretes");
            return;
        }

        List<Frete> fretes;
        
        if (usuarioLogado.isAdmin()) {
            fretes = freteDAO.listarTodos();
        } else {
            if (usuarioLogado.getClienteId() != null) {
                fretes = freteDAO.listarPorCliente(usuarioLogado.getClienteId());
            } else {
                fretes = new ArrayList<>();
            }
        }

        req.setAttribute("fretes", fretes);

        req.getRequestDispatcher("/WEB-INF/jsp/frete/frete.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Usuario usuarioLogado = (Usuario) req.getSession().getAttribute("usuarioAutenticado");

        if (usuarioLogado == null) {
            resp.sendRedirect("login");
            return;
        }

        Frete frete = new Frete();

        // Verificar se é uma atualização (edição) ou novo frete
        String idParam = req.getParameter("id");
        boolean isEdicao = idParam != null && !idParam.trim().isEmpty() && !"null".equalsIgnoreCase(idParam.trim());

        if (isEdicao) {
            frete.setId(Integer.parseInt(idParam.trim()));
        }

        frete.setNumeroFrete(req.getParameter("numeroFrete"));
        frete.setRemetenteId(Integer.parseInt(req.getParameter("remetenteId")));
        frete.setDestinatarioId(Integer.parseInt(req.getParameter("destinatarioId")));
        frete.setEnderecoOrigemId(Integer.parseInt(req.getParameter("enderecoOrigemId")));
        frete.setEnderecoDestinoId(Integer.parseInt(req.getParameter("enderecoDestinoId")));
        frete.setMotoristaId(Integer.parseInt(req.getParameter("motoristaId")));
        frete.setVeiculoId(Integer.parseInt(req.getParameter("veiculoId")));
        frete.setChaveNfe(req.getParameter("chaveNfe"));
        frete.setOrigemIbge(req.getParameter("origemIbge"));
        frete.setDestinoIbge(req.getParameter("destinoIbge"));
        frete.setNaturezaCarga(req.getParameter("naturezaCarga"));
        frete.setPesoBruto(new BigDecimal(req.getParameter("pesoBruto")));
        frete.setVolumes(Integer.parseInt(req.getParameter("volumes")));
        frete.setValorFreteBruto(new BigDecimal(req.getParameter("valorFreteBruto")));
        frete.setValorPedagio(parseBigDecimalOuZero(req.getParameter("valorPedagio")));
        frete.setAliquotaIcms(parseBigDecimalOuZero(req.getParameter("aliquotaIcms")));
        frete.setValorIcms(parseBigDecimalOuZero(req.getParameter("valorIcms")));
        frete.setValorTotal(new BigDecimal(req.getParameter("valorTotal")));
        frete.setStatus(StatusFrete.valueOf(req.getParameter("status")));
        frete.setPrevisaoEntrega(LocalDate.parse(req.getParameter("previsaoEntrega")));
        frete.setDistanciaKm(new BigDecimal(req.getParameter("distanciaKm")));

        try {
            if (!isEdicao) {
                frete.setDataEmissao(LocalDateTime.now());
                freteBO.salvar(frete);
            } else {
                freteBO.atualizar(frete);
            }

            resp.sendRedirect("fretes");
        } catch (FreteException e) {
            req.setAttribute("erro", e.getMessage());
            carregarFormulario(req, resp, usuarioLogado, frete);
        }
    }

    public void delete(Integer id) {
        freteDAO.deletar(id);
    }

    private BigDecimal parseBigDecimalOuZero(String valor) {
        return valor == null || valor.trim().isEmpty() ? BigDecimal.ZERO : new BigDecimal(valor);
    }

    private void carregarFormulario(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado, Frete frete)
            throws ServletException, IOException {
        req.setAttribute("frete", frete);
        req.setAttribute("clientes", clienteDAO.listarTodos());

        if (usuarioLogado.isAdmin()) {
            req.setAttribute("enderecos", enderecoDAO.listarTodos());
            req.setAttribute("motoristas", motoristaDAO.listarTodos());
            req.setAttribute("veiculos", veiculoDAO.listarTodos());
        } else if (usuarioLogado.getClienteId() != null) {
            req.setAttribute("enderecos", enderecoDAO.listarPorCliente(usuarioLogado.getClienteId()));
            req.setAttribute("motoristas", motoristaDAO.listarPorCliente(usuarioLogado.getClienteId()));
            req.setAttribute("veiculos", veiculoDAO.listarPorCliente(usuarioLogado.getClienteId()));
        } else {
            req.setAttribute("enderecos", new ArrayList<Endereco>());
            req.setAttribute("motoristas", new ArrayList<Motorista>());
            req.setAttribute("veiculos", new ArrayList<Veiculo>());
        }

        req.getRequestDispatcher("/WEB-INF/jsp/frete/cadastroFrete.jsp").forward(req, resp);
    }
}
