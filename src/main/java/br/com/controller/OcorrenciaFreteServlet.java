package br.com.controller;

import br.com.dao.OcorrenciaFreteDAO;
import br.com.model.OcorrenciaFrete;
import br.com.model.OcorrenciaFrete.TipoOcorrencia;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/ocorrencias")
public class OcorrenciaFreteServlet extends HttpServlet {

    private OcorrenciaFreteDAO ocorrenciaDAO = new OcorrenciaFreteDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String acao = req.getParameter("acao");

        if ("novo".equals(acao)) {
            req.getRequestDispatcher("/WEB-INF/jsp/ocorrencia/cadastroOcorrenciaFrete.jsp").forward(req, resp);
            return;
        }

        if ("editar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                OcorrenciaFrete ocorrencia = ocorrenciaDAO.buscarPorId(Integer.parseInt(idParam));
                req.setAttribute("ocorrencia", ocorrencia);
            }
            req.getRequestDispatcher("/WEB-INF/jsp/ocorrencia/cadastroOcorrenciaFrete.jsp").forward(req, resp);
            return;
        }

        if("deletar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                ocorrenciaDAO.deletar(Integer.parseInt(idParam));
            }
            resp.sendRedirect("ocorrencias");
            return;
        }

        List<OcorrenciaFrete> ocorrencias = ocorrenciaDAO.listarTodas();

        req.setAttribute("ocorrencias", ocorrencias);

        req.getRequestDispatcher("/WEB-INF/jsp/ocorrencia/ocorrenciaFrete.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        OcorrenciaFrete ocorrencia = new OcorrenciaFrete();

        // Verificar se é uma atualização (edição) ou nova ocorrência
        String idParam = req.getParameter("id");
        boolean isEdicao = idParam != null && !idParam.isEmpty();

        if (isEdicao) {
            ocorrencia.setId(Integer.parseInt(idParam));
        }

        ocorrencia.setFreteId(Integer.parseInt(req.getParameter("freteId")));
        ocorrencia.setTipo(TipoOcorrencia.valueOf(req.getParameter("tipo")));
        ocorrencia.setMunicipio(req.getParameter("municipio"));
        ocorrencia.setUf(req.getParameter("uf"));
        
        String latParam = req.getParameter("latitude");
        if (latParam != null && !latParam.isEmpty()) {
            ocorrencia.setLatitude(new BigDecimal(latParam));
        }
        
        String longParam = req.getParameter("longitude");
        if (longParam != null && !longParam.isEmpty()) {
            ocorrencia.setLongitude(new BigDecimal(longParam));
        }
        
        ocorrencia.setDescricao(req.getParameter("descricao"));
        ocorrencia.setRecebedorNome(req.getParameter("recebedorNome"));
        ocorrencia.setRecebedorDocumento(req.getParameter("recebedorDocumento"));
        ocorrencia.setFotoEvidenciaUrl(req.getParameter("fotoEvidenciaUrl"));

        if (!isEdicao) {
            ocorrencia.setDataHora(LocalDateTime.now());
            ocorrenciaDAO.salvar(ocorrencia);
        } else {
            ocorrenciaDAO.atualizar(ocorrencia);
        }

        resp.sendRedirect("ocorrencias");
    }

    public void delete(Integer id) {
        ocorrenciaDAO.deletar(id);
    }
}
