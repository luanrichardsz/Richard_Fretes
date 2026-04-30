package br.com.motorista;

import br.com.motorista.MotoristaBO;
import br.com.motorista.MotoristaDAO;
import br.com.cliente.ClienteDAO;
import br.com.exception.CadastroException;
import br.com.motorista.Motorista;
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
                Motorista motorista = motoristaDAO.buscarPorId(Integer.parseInt(idParam));
                req.setAttribute("motorista", motorista);
            }
            carregarFormulario(req, resp, usuarioLogado, (Motorista) req.getAttribute("motorista"));
            return;
        }

        if("deletar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                motoristaDAO.deletar(Integer.parseInt(idParam));
            }
            resp.sendRedirect("motoristas");
            return;
        }

        List<Motorista> motoristas;
        
        if (usuarioLogado.isAdmin()) {
            motoristas = motoristaDAO.listarTodos();
        } else {
            if (usuarioLogado.getClienteId() != null) {
                motoristas = motoristaDAO.listarPorCliente(usuarioLogado.getClienteId());
            } else {
                motoristas = new ArrayList<>();
            }
        }

        req.setAttribute("motoristas", motoristas);

        req.getRequestDispatcher("/WEB-INF/jsp/motorista/motorista.jsp")
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
        
        Motorista motorista = new Motorista();

        // Verificar se é uma atualização (edição) ou novo motorista
        String idParam = req.getParameter("id");
        boolean isEdicao = idParam != null && !idParam.trim().isEmpty() && !"null".equalsIgnoreCase(idParam.trim());

        if (isEdicao) {
            motorista.setId(Integer.parseInt(idParam.trim()));
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
        
        // LÓGICA DE CLIENTE ID
        if(usuarioLogado.isAdmin()) {
            String cliIdParam = req.getParameter("clienteId");
            if(cliIdParam != null && !cliIdParam.isEmpty()) {
                motorista.setClienteId(Integer.parseInt(cliIdParam));
            }
        } else {
            // Se for responsável, pega obrigatoriamente da sessão
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

    private void carregarFormulario(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado, Motorista motorista)
            throws ServletException, IOException {
        req.setAttribute("motorista", motorista);

        if (usuarioLogado.isAdmin()) {
            List<Cliente> clientes = new ClienteDAO().listarTodos();
            req.setAttribute("clientes", clientes);
        }

        req.getRequestDispatcher("/WEB-INF/jsp/motorista/cadastroMotorista.jsp").forward(req, resp);
    }
}
