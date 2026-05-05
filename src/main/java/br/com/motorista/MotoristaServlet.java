package br.com.motorista;

import br.com.cliente.ClienteDAO;
import br.com.exception.CadastroException;
import br.com.motorista.Motorista.*;
import br.com.usuario.Usuario;
import br.com.cliente.Cliente;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/motoristas")
public class MotoristaServlet extends HttpServlet {

    private MotoristaDAO motoristaDAO = new MotoristaDAO();
    private MotoristaBO motoristaBO = new MotoristaBO(motoristaDAO);

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

        if (usuarioLogado == null) {
            resp.sendRedirect("login");
            return;
        }

        Motorista motorista = new Motorista();
        String idParam = req.getParameter("id");
        boolean isEdicao = idParam != null && !idParam.trim().isEmpty() && !"null".equalsIgnoreCase(idParam.trim());

        if (isEdicao) {
            motorista.setId(obterIdMotorista(req));
        }

        motorista.setNomeCompleto(req.getParameter("nomeCompleto"));
        motorista.setRg(req.getParameter("rg"));
        motorista.setCpf(req.getParameter("cpf"));
        motorista.setDataNascimento(LocalDate.parse(req.getParameter("dataNascimento")));
        motorista.setTelefone(req.getParameter("telefone"));
        motorista.setNomeEmergencia(req.getParameter("nomeEmergencia"));
        motorista.setTelefoneEmergencia(req.getParameter("telefoneEmergencia"));
        motorista.setParentescoEmergencia(req.getParameter("parentescoEmergencia"));
        motorista.setNumeroCnh(req.getParameter("numeroCnh"));
        motorista.setCategoriaCnh(CategoriaCnh.valueOf(req.getParameter("categoriaCnh")));
        motorista.setValidadeCnh(LocalDate.parse(req.getParameter("validadeCnh")));

        String validadeToxParam = req.getParameter("validadeToxicologico");
        if (validadeToxParam != null && !validadeToxParam.isEmpty()) {
            motorista.setValidadeToxicologico(LocalDate.parse(validadeToxParam));
        }

        motorista.setTipoVinculo(TipoVinculo.valueOf(req.getParameter("tipoVinculo")));
        motorista.setChavePix(req.getParameter("chavePix"));
        motorista.setTipoPix(TipoPix.valueOf(req.getParameter("tipoPix")));
        motorista.setStatus(StatusMotorista.valueOf(req.getParameter("status")));

        if (usuarioLogado.isAdmin()) {
            String cliIdParam = req.getParameter("clienteId");
            if (cliIdParam != null && !cliIdParam.isEmpty()) {
                motorista.setClienteId(Integer.parseInt(cliIdParam));
            }
        } else {
            motorista.setClienteId(usuarioLogado.getClienteId());
        }

        try {
            if (!isEdicao) {
                motorista.setAdicionadoEm(LocalDateTime.now());
                motoristaBO.salvar(motorista);
            } else {
                motoristaBO.atualizar(motorista);
            }

            resp.sendRedirect("motoristas");
        } catch (CadastroException e) {
            req.setAttribute("erro", e.getMessage());
            carregarFormulario(req, resp, usuarioLogado, motorista);
        }
    }

    public void delete(Integer id) {
        motoristaDAO.deletar(id);
    }

    private void processarEdicao(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        try {
            Integer motoristaId = obterIdMotorista(req);
            Motorista motorista = buscarMotoristaOuLancarErro(motoristaId);
            motoristaBO.validarEdicaoPermitida(motoristaId);
            carregarFormulario(req, resp, usuarioLogado, motorista);
        } catch (NumberFormatException e) {
            redirecionarParaListagemComErro(req, resp, "Id do motorista inválido.");
        } catch (CadastroException e) {
            redirecionarParaListagemComErro(req, resp, e.getMessage());
        }
    }

    private void processarNovo(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        carregarFormulario(req, resp, usuarioLogado, null);
    }

    private void processarExclusao(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Integer motoristaId = obterIdMotorista(req);
            motoristaDAO.deletar(motoristaId);
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("erro", "Id do motorista inválido.");
        }
        resp.sendRedirect("motoristas");
    }

    private void processarListagem(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        Object erroSessao = req.getSession().getAttribute("erro");
        if (erroSessao != null) {
            req.setAttribute("erro", erroSessao);
            req.getSession().removeAttribute("erro");
        }

        carregarListagem(req, usuarioLogado);
        req.getRequestDispatcher("/WEB-INF/jsp/motorista/motorista.jsp").forward(req, resp);
    }

    private void redirecionarParaListagemComErro(HttpServletRequest req, HttpServletResponse resp, String mensagem)
            throws IOException {
        req.getSession().setAttribute("erro", mensagem);
        resp.sendRedirect("motoristas");
    }

    private Integer obterIdMotorista(HttpServletRequest req) {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            throw new NumberFormatException("Id do motorista ausente.");
        }
        return Integer.parseInt(idParam.trim());
    }

    private Motorista buscarMotoristaOuLancarErro(Integer motoristaId) throws CadastroException {
        Motorista motorista = motoristaDAO.buscarPorId(motoristaId);
        if (motorista == null) {
            throw new CadastroException("Motorista não encontrado.");
        }
        return motorista;
    }

    private void carregarFormulario(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado, Motorista motorista)
            throws ServletException, IOException {
        req.setAttribute("motorista", motorista);
        req.setAttribute("hoje", LocalDate.now());
        req.setAttribute("categoriaCnhOptions", CategoriaCnh.values());
        req.setAttribute("tipoVinculoOptions", TipoVinculo.values());
        req.setAttribute("tipoPixOptions", TipoPix.values());
        req.setAttribute("statusMotoristaOptions", StatusMotorista.values());

        if (usuarioLogado.isAdmin()) {
            List<Cliente> clientes = new ClienteDAO().listarTodos();
            req.setAttribute("clientes", clientes);
        }

        req.getRequestDispatcher("/WEB-INF/jsp/motorista/cadastroMotorista.jsp").forward(req, resp);
    }

    private void carregarListagem(HttpServletRequest req, Usuario usuarioLogado) {
        List<Motorista> motoristas;

        if (usuarioLogado.isAdmin()) {
            motoristas = motoristaDAO.listarTodos();
        } else if (usuarioLogado.getClienteId() != null) {
            motoristas = motoristaDAO.listarPorCliente(usuarioLogado.getClienteId());
        } else {
            motoristas = new ArrayList<>();
        }

        req.setAttribute("motoristas", motoristas);
    }
}
