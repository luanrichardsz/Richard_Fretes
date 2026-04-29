package br.com.controller;

import br.com.dao.FreteDAO;
import br.com.model.Frete;
import br.com.model.Frete.StatusFrete;
import br.com.model.Usuario;

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

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Usuario usuarioLogado = (Usuario) req.getSession().getAttribute("usuarioAutenticado");
        
        if(usuarioLogado == null) {
            resp.sendRedirect("login");
            return;
        }

        String acao = req.getParameter("acao");

        if ("novo".equals(acao)) {
            req.getRequestDispatcher("/WEB-INF/jsp/frete/cadastroFrete.jsp").forward(req, resp);
            return;
        }

        if ("editar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                Frete frete = freteDAO.buscarPorId(Integer.parseInt(idParam));
                req.setAttribute("frete", frete);
            }
            req.getRequestDispatcher("/WEB-INF/jsp/frete/cadastroFrete.jsp").forward(req, resp);
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

        Frete frete = new Frete();

        // Verificar se é uma atualização (edição) ou novo frete
        String idParam = req.getParameter("id");
        boolean isEdicao = idParam != null && !idParam.isEmpty();

        if (isEdicao) {
            frete.setId(Integer.parseInt(idParam));
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
        frete.setValorPedagio(new BigDecimal(req.getParameter("valorPedagio")));
        frete.setAliquotaIcms(new BigDecimal(req.getParameter("aliquotaIcms")));
        frete.setValorIcms(new BigDecimal(req.getParameter("valorIcms")));
        frete.setValorTotal(new BigDecimal(req.getParameter("valorTotal")));
        frete.setStatus(StatusFrete.valueOf(req.getParameter("status")));
        frete.setPrevisaoEntrega(LocalDate.parse(req.getParameter("previsaoEntrega")));
        frete.setDistanciaKm(new BigDecimal(req.getParameter("distanciaKm")));

        if (!isEdicao) {
            frete.setDataEmissao(LocalDateTime.now());
            freteDAO.salvar(frete);
        } else {
            freteDAO.atualizar(frete);
        }

        resp.sendRedirect("fretes");
    }

    public void delete(Integer id) {
        freteDAO.deletar(id);
    }
}
