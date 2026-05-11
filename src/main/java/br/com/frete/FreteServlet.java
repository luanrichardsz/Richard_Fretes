package br.com.frete;

import br.com.cliente.ClienteDAO;
import br.com.endereco.EnderecoDAO;
import br.com.motorista.MotoristaDAO;
import br.com.veiculo.VeiculoDAO;
import br.com.exception.FreteException;
import br.com.cliente.Cliente;
import br.com.endereco.Endereco;
import br.com.frete.Frete.StatusFrete;
import br.com.motorista.Motorista;
import br.com.ocorrenciafrete.OcorrenciaFrete;
import br.com.ocorrenciafrete.OcorrenciaFreteDAO;
import br.com.usuario.Usuario;
import br.com.veiculo.Veiculo;
import br.com.util.ValidationUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/fretes")
public class FreteServlet extends HttpServlet {

    private FreteDAO freteDAO = new FreteDAO();
    private ClienteDAO clienteDAO = new ClienteDAO();
    private EnderecoDAO enderecoDAO = new EnderecoDAO();
    private MotoristaDAO motoristaDAO = new MotoristaDAO();
    private VeiculoDAO veiculoDAO = new VeiculoDAO();
    private OcorrenciaFreteDAO ocorrenciaDAO = new OcorrenciaFreteDAO();
    private FreteBO freteBO = new FreteBO(freteDAO, enderecoDAO, motoristaDAO, veiculoDAO);

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

        if ("detalhes".equals(acao)) {
            processarDetalhes(req, resp, usuarioLogado);
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

        String acaoFrete = req.getParameter("acaoFrete");
        if (!ValidationUtils.estaVazio(acaoFrete)) {
            processarAcaoFrete(req, resp, usuarioLogado, acaoFrete);
            return;
        }

        Frete frete = new Frete();

        // Verificar se é uma atualização (edição) ou novo frete
        String idParam = req.getParameter("id");
        boolean isEdicao = idParam != null && !idParam.trim().isEmpty() && !"null".equalsIgnoreCase(idParam.trim());

        try {
            if (isEdicao) {
                frete.setId(Integer.parseInt(idParam.trim()));
            }

            if (isEdicao) {
                Frete freteExistente = freteDAO.buscarPorId(frete.getId());
                if (freteExistente != null) {
                    frete.setNumeroFrete(freteExistente.getNumeroFrete());
                    frete.setStatus(freteExistente.getStatus());
                }
            } else {
                frete.setNumeroFrete(req.getParameter("numeroFrete"));
                frete.setStatus(StatusFrete.EMITIDO);
            }

            if (usuarioLogado.isAdmin()) {
                frete.setRemetenteId(Integer.parseInt(req.getParameter("remetenteId")));
            } else {
                frete.setRemetenteId(usuarioLogado.getClienteId());
            }
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
            frete.setValorTotal(parseBigDecimalOuZero(req.getParameter("valorTotal")));
            frete.setPrevisaoEntrega(parsePrevisaoEntrega(req.getParameter("previsaoEntrega")));
            frete.setDistanciaKm(new BigDecimal(req.getParameter("distanciaKm")));

            if (!isEdicao) {
                frete.setDataEmissao(LocalDateTime.now());
                freteBO.salvar(frete);
            } else {
                freteBO.atualizar(frete);
            }

            resp.sendRedirect("fretes");
        } catch (FreteException e) {
            if (isEdicao && ValidationUtils.estaVazio(frete.getNumeroFrete())) {
                Frete freteExistente = freteDAO.buscarPorId(frete.getId());
                if (freteExistente != null) {
                    frete.setNumeroFrete(freteExistente.getNumeroFrete());
                }
            }
            req.setAttribute("erro", e.getMessage());
            carregarFormulario(req, resp, usuarioLogado, frete);
        } catch (DateTimeParseException e) {
            req.setAttribute("erro", "Informe uma data válida para a previsão de entrega no formato AAAA-MM-DD.");
            carregarFormulario(req, resp, usuarioLogado, frete);
        } catch (RuntimeException e) {
            req.setAttribute("erro", "Revise os dados do frete. Verifique clientes, endereços, valores e previsão de entrega.");
            carregarFormulario(req, resp, usuarioLogado, frete);
        }
    }

    public void delete(Integer id) {
        try {
            freteBO.deletar(id);
        } catch (FreteException e) {
            throw new IllegalStateException(e.getMessage(), e);
        }
    }

    private void processarNovo(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        Frete novoFrete = new Frete();
        novoFrete.setNumeroFrete(freteBO.gerarProximoNumeroFrete());
        carregarFormulario(req, resp, usuarioLogado, novoFrete);
    }

    private void processarEdicao(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        try {
            Integer freteId = obterIdFrete(req);
            Frete frete = buscarFreteOuLancarErro(freteId);
            freteBO.validarEdicaoPermitida(freteId);
            carregarFormulario(req, resp, usuarioLogado, frete);
        } catch (NumberFormatException e) {
            redirecionarParaListagemComErro(req, resp, "Id do frete inválido.");
        } catch (FreteException e) {
            redirecionarParaListagemComErro(req, resp, e.getMessage());
        }
    }

    private void processarDetalhes(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        try {
            Integer freteId = obterIdFrete(req);
            Frete frete = buscarFreteOuLancarErro(freteId);
            if (!usuarioPodeAcessarFrete(usuarioLogado, frete)) {
                resp.sendRedirect("fretes");
                return;
            }
            carregarDetalhesFrete(req, resp, frete);
        } catch (NumberFormatException | FreteException e) {
            resp.sendRedirect("fretes");
        }
    }

    private void processarExclusao(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Integer freteId = obterIdFrete(req);
            Usuario usuarioLogado = (Usuario) req.getSession().getAttribute("usuarioAutenticado");
            Frete frete = buscarFreteOuLancarErro(freteId);

            if (!usuarioPodeAcessarFrete(usuarioLogado, frete)) {
                resp.sendRedirect("fretes");
                return;
            }

            freteBO.deletar(freteId);
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("erro", "Id do frete inválido.");
        } catch (FreteException e) {
            req.getSession().setAttribute("erro", e.getMessage());
        }
        resp.sendRedirect("fretes");
    }

    private void processarListagem(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado)
            throws ServletException, IOException {
        Object erroSessao = req.getSession().getAttribute("erro");
        if (erroSessao != null) {
            req.setAttribute("erro", erroSessao);
            req.getSession().removeAttribute("erro");
        }

        carregarListagem(req, usuarioLogado);
        req.getRequestDispatcher("/WEB-INF/jsp/frete/frete.jsp").forward(req, resp);
    }

    private void redirecionarParaListagemComErro(HttpServletRequest req, HttpServletResponse resp, String mensagem)
            throws IOException {
        req.getSession().setAttribute("erro", mensagem);
        resp.sendRedirect("fretes");
    }

    private Integer obterIdFrete(HttpServletRequest req) {
        String idParam = req.getParameter("id");
        if (ValidationUtils.estaVazio(idParam)) {
            throw new NumberFormatException("Id do frete ausente.");
        }
        return Integer.parseInt(idParam.trim());
    }

    private Frete buscarFreteOuLancarErro(Integer freteId) throws FreteException {
        Frete frete = freteDAO.buscarPorId(freteId);
        if (frete == null) {
            throw new FreteException("Frete não encontrado.");
        }
        return frete;
    }

    private BigDecimal parseBigDecimalOuZero(String valor) {
        return valor == null || valor.trim().isEmpty() ? BigDecimal.ZERO : new BigDecimal(valor);
    }

    private LocalDate parsePrevisaoEntrega(String valor) {
        if (ValidationUtils.estaVazio(valor) || !valor.trim().matches("^\\d{4}-\\d{2}-\\d{2}$")) {
            throw new DateTimeParseException("Formato de data inválido.", valor, 0);
        }

        return LocalDate.parse(valor.trim());
    }

    private void carregarFormulario(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado, Frete frete)
            throws ServletException, IOException {
        if (!usuarioLogado.isAdmin() && usuarioLogado.getClienteId() != null) {
            if (frete == null) {
                frete = new Frete();
            }
            frete.setRemetenteId(usuarioLogado.getClienteId());
            req.setAttribute("remetenteCliente", clienteDAO.buscarPorId(usuarioLogado.getClienteId()));
        }

        req.setAttribute("frete", frete);
        req.setAttribute("hoje", LocalDate.now());
        req.setAttribute("clientes", clienteDAO.listarTodos());

        if (usuarioLogado.isAdmin()) {
            req.setAttribute("enderecosOrigem", enderecoDAO.listarTodos());
            req.setAttribute("enderecosDestino", enderecoDAO.listarTodos());
            req.setAttribute("motoristas", motoristaDAO.listarTodos());
            req.setAttribute("veiculos", veiculoDAO.listarTodos());
        } else if (usuarioLogado.getClienteId() != null) {
            req.setAttribute("enderecosOrigem", enderecoDAO.listarPorCliente(usuarioLogado.getClienteId()));
            req.setAttribute("enderecosDestino", enderecoDAO.listarTodos());
            req.setAttribute("motoristas", motoristaDAO.listarPorCliente(usuarioLogado.getClienteId()));
            req.setAttribute("veiculos", veiculoDAO.listarPorCliente(usuarioLogado.getClienteId()));
        } else {
            req.setAttribute("enderecosOrigem", new ArrayList<Endereco>());
            req.setAttribute("enderecosDestino", new ArrayList<Endereco>());
            req.setAttribute("motoristas", new ArrayList<Motorista>());
            req.setAttribute("veiculos", new ArrayList<Veiculo>());
        }

        req.getRequestDispatcher("/WEB-INF/jsp/frete/cadastroFrete.jsp").forward(req, resp);
    }

    private void carregarListagem(HttpServletRequest req, Usuario usuarioLogado) {
        List<Frete> fretes;

        if (usuarioLogado.isAdmin()) {
            fretes = freteDAO.listarTodos();
        } else if (usuarioLogado.getClienteId() != null) {
            fretes = freteDAO.listarPorCliente(usuarioLogado.getClienteId());
        } else {
            fretes = new ArrayList<>();
        }

        req.setAttribute("fretes", fretes);
        req.setAttribute("clientesPorId", montarMapaClientes());
    }

    private Map<Integer, String> montarMapaClientes() {
        Map<Integer, String> clientesPorId = new HashMap<>();

        for (Cliente cliente : clienteDAO.listarTodos()) {
            if (cliente == null || cliente.getId() == null) {
                continue;
            }

            String nomeExibicao = !ValidationUtils.estaVazio(cliente.getNomeFantasia())
                    ? cliente.getNomeFantasia()
                    : cliente.getRazaoSocial();

            clientesPorId.put(cliente.getId(), nomeExibicao);
        }

        return clientesPorId;
    }

    private void carregarDetalhesFrete(HttpServletRequest req, HttpServletResponse resp, Frete frete)
            throws ServletException, IOException {
        Cliente remetente = clienteDAO.buscarPorId(frete.getRemetenteId());
        Cliente destinatario = clienteDAO.buscarPorId(frete.getDestinatarioId());
        Endereco origem = enderecoDAO.buscarPorId(frete.getEnderecoOrigemId());
        Endereco destino = enderecoDAO.buscarPorId(frete.getEnderecoDestinoId());
        Motorista motorista = motoristaDAO.buscarPorId(frete.getMotoristaId());
        Veiculo veiculo = veiculoDAO.buscarPorId(frete.getVeiculoId());
        List<OcorrenciaFrete> ocorrencias = ocorrenciaDAO.listarPorFrete(frete.getId());

        req.setAttribute("frete", frete);
        req.setAttribute("remetente", remetente);
        req.setAttribute("destinatario", destinatario);
        req.setAttribute("enderecoOrigem", origem);
        req.setAttribute("enderecoDestino", destino);
        req.setAttribute("motorista", motorista);
        req.setAttribute("veiculo", veiculo);
        req.setAttribute("ocorrencias", ocorrencias);
        req.setAttribute("ultimaOcorrencia", ocorrencias.isEmpty() ? null : ocorrencias.get(0));
        req.getRequestDispatcher("/WEB-INF/jsp/frete/detalheFrete.jsp").forward(req, resp);
    }

    private void processarAcaoFrete(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado, String acaoFrete)
            throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (ValidationUtils.estaVazio(idParam)) {
            resp.sendRedirect("fretes");
            return;
        }

        Frete freteAtual = freteDAO.buscarPorId(Integer.parseInt(idParam));
        if (freteAtual == null || !usuarioPodeAcessarFrete(usuarioLogado, freteAtual)) {
            resp.sendRedirect("fretes");
            return;
        }

        try {
            if ("confirmarSaida".equals(acaoFrete)) {
                atualizarStatusFrete(freteAtual, StatusFrete.SAIDA_CONFIRMADA, null);
            } else if ("iniciarTransito".equals(acaoFrete)) {
                atualizarStatusFrete(freteAtual, StatusFrete.EM_TRANSITO, null);
            } else if ("marcarNaoEntregue".equals(acaoFrete)) {
                String motivoFalha = req.getParameter("motivoFalha");
                if (ValidationUtils.estaVazio(motivoFalha)) {
                    req.setAttribute("erro", "Informe o motivo da não entrega.");
                    carregarDetalhesFrete(req, resp, freteAtual);
                    return;
                }
                atualizarStatusFrete(freteAtual, StatusFrete.NAO_ENTREGUE, motivoFalha.trim());
            } else if ("cancelarFrete".equals(acaoFrete)) {
                atualizarStatusFrete(freteAtual, StatusFrete.CANCELADO, null);
            }

            resp.sendRedirect("fretes?acao=detalhes&id=" + freteAtual.getId());
        } catch (FreteException e) {
            req.setAttribute("erro", e.getMessage());
            carregarDetalhesFrete(req, resp, freteAtual);
        }
    }

    private void atualizarStatusFrete(Frete freteAtual, StatusFrete novoStatus, String motivoFalha) throws FreteException {
        Frete freteAtualizado = copiarFrete(freteAtual);
        freteAtualizado.setStatus(novoStatus);
        freteAtualizado.setMotivoFalha(motivoFalha);
        freteBO.atualizarStatusOperacional(freteAtualizado);
    }

    private Frete copiarFrete(Frete origem) {
        Frete frete = new Frete();
        frete.setId(origem.getId());
        frete.setNumeroFrete(origem.getNumeroFrete());
        frete.setRemetenteId(origem.getRemetenteId());
        frete.setDestinatarioId(origem.getDestinatarioId());
        frete.setEnderecoOrigemId(origem.getEnderecoOrigemId());
        frete.setEnderecoDestinoId(origem.getEnderecoDestinoId());
        frete.setMotoristaId(origem.getMotoristaId());
        frete.setVeiculoId(origem.getVeiculoId());
        frete.setChaveNfe(origem.getChaveNfe());
        frete.setOrigemIbge(origem.getOrigemIbge());
        frete.setDestinoIbge(origem.getDestinoIbge());
        frete.setNaturezaCarga(origem.getNaturezaCarga());
        frete.setPesoBruto(origem.getPesoBruto());
        frete.setVolumes(origem.getVolumes());
        frete.setValorFreteBruto(origem.getValorFreteBruto());
        frete.setValorPedagio(origem.getValorPedagio());
        frete.setAliquotaIcms(origem.getAliquotaIcms());
        frete.setValorIcms(origem.getValorIcms());
        frete.setValorTotal(origem.getValorTotal());
        frete.setStatus(origem.getStatus());
        frete.setDataEmissao(origem.getDataEmissao());
        frete.setPrevisaoEntrega(origem.getPrevisaoEntrega());
        frete.setMotivoFalha(origem.getMotivoFalha());
        frete.setDataSaida(origem.getDataSaida());
        frete.setDataEntrega(origem.getDataEntrega());
        frete.setDistanciaKm(origem.getDistanciaKm());
        return frete;
    }

    private boolean usuarioPodeAcessarFrete(Usuario usuarioLogado, Frete frete) {
        return usuarioLogado != null
                && (usuarioLogado.isAdmin()
                || (usuarioLogado.getClienteId() != null
                && (usuarioLogado.getClienteId().equals(frete.getRemetenteId())
                || usuarioLogado.getClienteId().equals(frete.getDestinatarioId()))));
    }
}
