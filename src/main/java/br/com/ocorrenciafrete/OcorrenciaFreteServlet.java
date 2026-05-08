package br.com.ocorrenciafrete;

import br.com.exception.FreteException;
import br.com.endereco.Endereco;
import br.com.endereco.EnderecoDAO;
import br.com.frete.Frete;
import br.com.frete.FreteDAO;
import br.com.ocorrenciafrete.OcorrenciaFrete.TipoOcorrencia;
import br.com.usuario.Usuario;
import br.com.util.ValidationUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ocorrencias")
public class OcorrenciaFreteServlet extends HttpServlet {

    private OcorrenciaFreteDAO ocorrenciaDAO = new OcorrenciaFreteDAO();
    private FreteDAO freteDAO = new FreteDAO();
    private EnderecoDAO enderecoDAO = new EnderecoDAO();
    private OcorrenciaFreteBO ocorrenciaBO = new OcorrenciaFreteBO(ocorrenciaDAO);

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

        OcorrenciaFrete ocorrencia = new OcorrenciaFrete();

        String idParam = req.getParameter("id");
        boolean isEdicao = idParam != null && !idParam.trim().isEmpty() && !"null".equalsIgnoreCase(idParam.trim());

        try {
            if (isEdicao) {
                ocorrencia.setId(Integer.parseInt(idParam.trim()));
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
                ocorrenciaBO.salvar(ocorrencia);
            } else {
                ocorrenciaBO.atualizar(ocorrencia);
            }

            String retornoFreteId = req.getParameter("retornoFreteId");
            if (!ValidationUtils.estaVazio(retornoFreteId)) {
                resp.sendRedirect("fretes?acao=detalhes&id=" + retornoFreteId);
                return;
            }

            resp.sendRedirect("ocorrencias");
        } catch (FreteException e) {
            req.setAttribute("erro", e.getMessage());
            req.setAttribute("ocorrencia", ocorrencia);
            carregarFormulario(req, null, ocorrencia);
            req.setAttribute("tipoOcorrenciaOptions", TipoOcorrencia.values());
            req.getRequestDispatcher("/WEB-INF/jsp/ocorrencia/cadastroOcorrenciaFrete.jsp").forward(req, resp);
        } catch (RuntimeException e) {
            req.setAttribute("erro", "Revise os dados da ocorrência e tente novamente.");
            req.setAttribute("ocorrencia", ocorrencia);
            carregarFormulario(req, null, ocorrencia);
            req.setAttribute("tipoOcorrenciaOptions", TipoOcorrencia.values());
            req.getRequestDispatcher("/WEB-INF/jsp/ocorrencia/cadastroOcorrenciaFrete.jsp").forward(req, resp);
        }
    }

    public void delete(Integer id) {
        ocorrenciaDAO.deletar(id);
    }

    private void processarNovo(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        carregarFormulario(req, usuarioLogado, criarOcorrenciaInicial(req));
        req.setAttribute("tipoOcorrenciaOptions", TipoOcorrencia.values());
        req.getRequestDispatcher("/WEB-INF/jsp/ocorrencia/cadastroOcorrenciaFrete.jsp").forward(req, resp);
    }

    private void processarEdicao(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        try {
            Integer ocorrenciaId = obterIdOcorrencia(req);
            OcorrenciaFrete ocorrencia = buscarOcorrenciaOuLancarErro(ocorrenciaId);
            carregarFormulario(req, usuarioLogado, ocorrencia);
            req.setAttribute("tipoOcorrenciaOptions", TipoOcorrencia.values());
            req.getRequestDispatcher("/WEB-INF/jsp/ocorrencia/cadastroOcorrenciaFrete.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            redirecionarParaListagemComErro(req, resp, "Id da ocorrência inválido.");
        } catch (FreteException e) {
            redirecionarParaListagemComErro(req, resp, e.getMessage());
        }
    }

    private void processarExclusao(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Integer ocorrenciaId = obterIdOcorrencia(req);
            ocorrenciaDAO.deletar(ocorrenciaId);
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("erro", "Id da ocorrência inválido.");
        }
        resp.sendRedirect("ocorrencias");
    }

    private void processarListagem(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        Object erroSessao = req.getSession().getAttribute("erro");
        if (erroSessao != null) {
            req.setAttribute("erro", erroSessao);
            req.getSession().removeAttribute("erro");
        }

        List<OcorrenciaFrete> ocorrencias;

        if (usuarioLogado.isAdmin()) {
            ocorrencias = ocorrenciaDAO.listarTodas();
        } else if (usuarioLogado.getClienteId() != null) {
            ocorrencias = ocorrenciaDAO.listarPorCliente(usuarioLogado.getClienteId());
        } else {
            ocorrencias = new ArrayList<>();
        }

        req.setAttribute("ocorrencias", ocorrencias);
        req.getRequestDispatcher("/WEB-INF/jsp/ocorrencia/ocorrenciaFrete.jsp").forward(req, resp);
    }

    private void redirecionarParaListagemComErro(HttpServletRequest req, HttpServletResponse resp, String mensagem)
            throws IOException {
        req.getSession().setAttribute("erro", mensagem);
        resp.sendRedirect("ocorrencias");
    }

    private Integer obterIdOcorrencia(HttpServletRequest req) {
        String idParam = req.getParameter("id");
        if (ValidationUtils.estaVazio(idParam)) {
            throw new NumberFormatException("Id da ocorrência ausente.");
        }
        return Integer.parseInt(idParam.trim());
    }

    private OcorrenciaFrete buscarOcorrenciaOuLancarErro(Integer ocorrenciaId) throws FreteException {
        OcorrenciaFrete ocorrencia = ocorrenciaDAO.buscarPorId(ocorrenciaId);
        if (ocorrencia == null) {
            throw new FreteException("Ocorrência não encontrada.");
        }
        return ocorrencia;
    }

    private void carregarFormulario(HttpServletRequest req, Usuario usuarioLogado, OcorrenciaFrete ocorrencia) {
        req.setAttribute("ocorrencia", ocorrencia);

        String retornoFreteId = req.getParameter("retornoFreteId");
        if (!ValidationUtils.estaVazio(retornoFreteId)) {
            req.setAttribute("retornoFreteId", retornoFreteId);
        }

        if (ocorrencia != null && ocorrencia.getFreteId() != null) {
            Frete frete = freteDAO.buscarPorId(ocorrencia.getFreteId());
            if (frete != null) {
                req.setAttribute("freteRelacionado", frete);
            }
        }
    }

    private OcorrenciaFrete criarOcorrenciaInicial(HttpServletRequest req) {
        OcorrenciaFrete ocorrencia = new OcorrenciaFrete();

        String freteIdParam = req.getParameter("freteId");
        if (!ValidationUtils.estaVazio(freteIdParam)) {
            Frete frete = freteDAO.buscarPorId(Integer.parseInt(freteIdParam));
            if (frete != null) {
                ocorrencia.setFreteId(frete.getId());

                Endereco destino = enderecoDAO.buscarPorId(frete.getEnderecoDestinoId());
                if (destino != null) {
                    ocorrencia.setMunicipio(destino.getMunicipio());
                    ocorrencia.setUf(destino.getUf());
                }
            }
        }

        String tipoParam = req.getParameter("tipo");
        if (!ValidationUtils.estaVazio(tipoParam)) {
            ocorrencia.setTipo(TipoOcorrencia.valueOf(tipoParam));
        }

        return ocorrencia;
    }
}
