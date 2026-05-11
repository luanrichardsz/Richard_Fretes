package br.com.manutencao;

import br.com.exception.CadastroException;
import br.com.manutencao.ManutencaoVeiculo.StatusManutencao;
import br.com.manutencao.ManutencaoVeiculo.TipoManutencao;
import br.com.usuario.Usuario;
import br.com.util.ValidationUtils;
import br.com.veiculo.Veiculo;
import br.com.veiculo.VeiculoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@WebServlet("/manutencoes")
public class ManutencaoVeiculoServlet extends HttpServlet {

    private final ManutencaoVeiculoDAO manutencaoDAO = new ManutencaoVeiculoDAO();
    private final ManutencaoVeiculoBO manutencaoBO = new ManutencaoVeiculoBO();
    private final VeiculoDAO veiculoDAO = new VeiculoDAO();

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
            processarExclusao(req, resp, usuarioLogado);
            return;
        }

        processarListagem(req, resp, usuarioLogado);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        Usuario usuarioLogado = (Usuario) req.getSession().getAttribute("usuarioAutenticado");
        if (usuarioLogado == null) {
            resp.sendRedirect("login");
            return;
        }

        ManutencaoVeiculo manutencao = new ManutencaoVeiculo();
        String idParam = req.getParameter("id");
        boolean isEdicao = !ValidationUtils.estaVazio(idParam) && !"null".equalsIgnoreCase(idParam.trim());

        try {
            if (isEdicao) {
                manutencao.setId(Integer.parseInt(idParam.trim()));
            }

            manutencao.setVeiculoId(Integer.parseInt(req.getParameter("veiculoId")));
            validarAcessoAoVeiculo(usuarioLogado, manutencao.getVeiculoId());

            manutencao.setTipo(TipoManutencao.valueOf(req.getParameter("tipo")));
            manutencao.setStatus(StatusManutencao.valueOf(req.getParameter("status")));
            manutencao.setDescricao(req.getParameter("descricao"));
            manutencao.setDataPrevista(LocalDate.parse(req.getParameter("dataPrevista")));

            String dataRealizacao = req.getParameter("dataRealizacao");
            if (!ValidationUtils.estaVazio(dataRealizacao)) {
                manutencao.setDataRealizacao(LocalDate.parse(dataRealizacao));
            }

            String custo = req.getParameter("custo");
            manutencao.setCusto(ValidationUtils.estaVazio(custo) ? BigDecimal.ZERO : new BigDecimal(custo.trim().replace(",", ".")));
            manutencao.setFornecedorOficina(req.getParameter("fornecedorOficina"));
            manutencao.setObservacao(req.getParameter("observacao"));

            if (!isEdicao) {
                manutencao.setAdicionadoEm(LocalDateTime.now());
                manutencaoBO.salvar(manutencao);
            } else {
                manutencaoBO.atualizar(manutencao);
            }

            resp.sendRedirect("manutencoes?veiculoId=" + manutencao.getVeiculoId());
        } catch (CadastroException e) {
            req.setAttribute("erro", e.getMessage());
            carregarFormulario(req, resp, usuarioLogado, manutencao, manutencao.getVeiculoId() != null);
        } catch (RuntimeException e) {
            req.setAttribute("erro", "Revise os dados da manutenção. Verifique datas, custo e veículo selecionado.");
            carregarFormulario(req, resp, usuarioLogado, manutencao, manutencao.getVeiculoId() != null);
        }
    }

    private void processarNovo(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        ManutencaoVeiculo manutencao = new ManutencaoVeiculo();

        String veiculoIdParam = req.getParameter("veiculoId");
        try {
            if (!ValidationUtils.estaVazio(veiculoIdParam)) {
                Integer veiculoId = Integer.parseInt(veiculoIdParam.trim());
                validarAcessoAoVeiculo(usuarioLogado, veiculoId);
                manutencao.setVeiculoId(veiculoId);
            }
        } catch (CadastroException e) {
            req.getSession().setAttribute("erro", e.getMessage());
            resp.sendRedirect("manutencoes");
            return;
        }

        carregarFormulario(req, resp, usuarioLogado, manutencao, manutencao.getVeiculoId() != null);
    }

    private void processarEdicao(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        try {
            Integer manutencaoId = obterIdManutencao(req);
            ManutencaoVeiculo manutencao = buscarManutencaoOuLancarErro(manutencaoId);
            validarAcessoAoVeiculo(usuarioLogado, manutencao.getVeiculoId());
            carregarFormulario(req, resp, usuarioLogado, manutencao, true);
        } catch (CadastroException e) {
            req.getSession().setAttribute("erro", e.getMessage());
            resp.sendRedirect("manutencoes");
        }
    }

    private void processarExclusao(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado) throws IOException {
        try {
            Integer manutencaoId = obterIdManutencao(req);
            ManutencaoVeiculo manutencao = buscarManutencaoOuLancarErro(manutencaoId);
            validarAcessoAoVeiculo(usuarioLogado, manutencao.getVeiculoId());
            manutencaoBO.deletar(manutencaoId);
            resp.sendRedirect("manutencoes?veiculoId=" + manutencao.getVeiculoId());
            return;
        } catch (CadastroException e) {
            req.getSession().setAttribute("erro", e.getMessage());
        }

        resp.sendRedirect("manutencoes");
    }

    private void processarListagem(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        Object erroSessao = req.getSession().getAttribute("erro");
        if (erroSessao != null) {
            req.setAttribute("erro", erroSessao);
            req.getSession().removeAttribute("erro");
        }

        String veiculoIdParam = req.getParameter("veiculoId");
        List<ManutencaoVeiculo> manutencoes;
        Veiculo veiculoSelecionado = null;

        try {
            if (!ValidationUtils.estaVazio(veiculoIdParam)) {
                Integer veiculoId = Integer.parseInt(veiculoIdParam.trim());
                validarAcessoAoVeiculo(usuarioLogado, veiculoId);
                manutencoes = manutencaoDAO.listarPorVeiculo(veiculoId);
                veiculoSelecionado = veiculoDAO.buscarPorId(veiculoId);
            } else if (usuarioLogado.isAdmin()) {
                manutencoes = manutencaoDAO.listarTodas();
            } else if (usuarioLogado.getClienteId() != null) {
                manutencoes = manutencaoDAO.listarPorCliente(usuarioLogado.getClienteId());
            } else {
                manutencoes = new ArrayList<>();
            }
        } catch (CadastroException e) {
            req.getSession().setAttribute("erro", e.getMessage());
            resp.sendRedirect("manutencoes");
            return;
        }

        req.setAttribute("manutencoes", manutencoes);
        req.setAttribute("veiculoSelecionado", veiculoSelecionado);
        req.getRequestDispatcher("/WEB-INF/jsp/manutencao/manutencaoVeiculo.jsp").forward(req, resp);
    }

    private void carregarFormulario(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado, ManutencaoVeiculo manutencao, boolean veiculoTravado)
            throws ServletException, IOException {
        List<Veiculo> veiculosFormulario = carregarVeiculosParaFormulario(usuarioLogado, manutencao, veiculoTravado);

        req.setAttribute("manutencao", manutencao);
        req.setAttribute("tipoManutencaoOptions", TipoManutencao.values());
        req.setAttribute("statusManutencaoOptions", StatusManutencao.values());
        req.setAttribute("veiculos", veiculosFormulario);
        req.setAttribute("veiculoTravado", veiculoTravado);
        req.setAttribute("semVeiculosComManutencao", !veiculoTravado && veiculosFormulario.isEmpty());

        if (manutencao != null && manutencao.getVeiculoId() != null) {
            req.setAttribute("veiculoSelecionado", veiculoDAO.buscarPorId(manutencao.getVeiculoId()));
            req.setAttribute("resumoVeiculo", manutencaoBO.resumirVeiculo(manutencao.getVeiculoId()));
        }

        req.getRequestDispatcher("/WEB-INF/jsp/manutencao/cadastroManutencaoVeiculo.jsp").forward(req, resp);
    }

    private List<Veiculo> carregarVeiculosParaFormulario(Usuario usuarioLogado, ManutencaoVeiculo manutencao, boolean veiculoTravado) {
        if (veiculoTravado && manutencao != null && manutencao.getVeiculoId() != null) {
            Veiculo veiculo = veiculoDAO.buscarPorId(manutencao.getVeiculoId());
            return veiculo != null ? Collections.singletonList(veiculo) : new ArrayList<>();
        }

        if (usuarioLogado.isAdmin()) {
            return manutencaoDAO.listarVeiculosComManutencao();
        }

        if (usuarioLogado.getClienteId() != null) {
            return manutencaoDAO.listarVeiculosComManutencaoPorCliente(usuarioLogado.getClienteId());
        }

        return new ArrayList<>();
    }

    private void validarAcessoAoVeiculo(Usuario usuarioLogado, Integer veiculoId) throws CadastroException {
        Veiculo veiculo = veiculoDAO.buscarPorId(veiculoId);
        if (veiculo == null) {
            throw new CadastroException("Veículo não encontrado.");
        }

        if (!usuarioLogado.isAdmin()
                && (usuarioLogado.getClienteId() == null || !usuarioLogado.getClienteId().equals(veiculo.getClienteId()))) {
            throw new CadastroException("Você não possui permissão para acessar a manutenção deste veículo.");
        }
    }

    private Integer obterIdManutencao(HttpServletRequest req) throws CadastroException {
        String idParam = req.getParameter("id");
        if (ValidationUtils.estaVazio(idParam)) {
            throw new CadastroException("Id da manutenção ausente.");
        }
        return Integer.parseInt(idParam.trim());
    }

    private ManutencaoVeiculo buscarManutencaoOuLancarErro(Integer manutencaoId) throws CadastroException {
        ManutencaoVeiculo manutencao = manutencaoDAO.buscarPorId(manutencaoId);
        if (manutencao == null) {
            throw new CadastroException("Manutenção não encontrada.");
        }
        return manutencao;
    }
}
