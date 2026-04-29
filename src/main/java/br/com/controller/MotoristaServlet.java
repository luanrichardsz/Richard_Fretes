package br.com.controller;

import br.com.dao.MotoristaDAO;
import br.com.dao.ClienteDAO;
import br.com.model.Motorista;
import br.com.model.Motorista.*;
import br.com.model.Usuario;
import br.com.model.Cliente;

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

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Usuario usuarioLogado = (Usuario) req.getSession().getAttribute("usuarioAutenticado");
        
        if(usuarioLogado == null) {
            resp.sendRedirect("login");
            return;
        }

        String acao = req.getParameter("acao");

        if ("novo".equals(acao)) {
            if (usuarioLogado.isAdmin()) {
                List<Cliente> clientes = new ClienteDAO().listarTodos();
                req.setAttribute("clientes", clientes);
            }
            req.getRequestDispatcher("/WEB-INF/jsp/motorista/cadastroMotorista.jsp").forward(req, resp);
            return;
        }

        if ("editar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                Motorista motorista = motoristaDAO.buscarPorId(Integer.parseInt(idParam));
                req.setAttribute("motorista", motorista);
            }
            if (usuarioLogado.isAdmin()) {
                List<Cliente> clientes = new ClienteDAO().listarTodos();
                req.setAttribute("clientes", clientes);
            }
            req.getRequestDispatcher("/WEB-INF/jsp/motorista/cadastroMotorista.jsp").forward(req, resp);
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
        boolean isEdicao = idParam != null && !idParam.isEmpty();

        if (isEdicao) {
            motorista.setId(Integer.parseInt(idParam));
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
            if(cliIdParam != null) {
                motorista.setClienteId(Integer.parseInt(cliIdParam));
            }
        } else {
            // Se for responsável, pega obrigatoriamente da sessão
            motorista.setClienteId(usuarioLogado.getClienteId());
        }

        if (!isEdicao) {
            motorista.setAdicionadoEm(LocalDateTime.now());
            motoristaDAO.salvar(motorista);
        } else {
            motoristaDAO.atualizar(motorista);
        }

        resp.sendRedirect("motoristas");
    }

    public void delete(Integer id) {
        motoristaDAO.deletar(id);
    }
}
