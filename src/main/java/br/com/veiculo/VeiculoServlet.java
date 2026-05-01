package br.com.veiculo;

import br.com.veiculo.VeiculoBO;
import br.com.cliente.ClienteDAO;
import br.com.motorista.MotoristaDAO;
import br.com.veiculo.VeiculoDAO;
import br.com.exception.CadastroException;
import br.com.cliente.Cliente;
import br.com.motorista.Motorista;
import br.com.veiculo.Veiculo;
import br.com.veiculo.Veiculo.StatusVeiculo;
import br.com.usuario.Usuario;

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

@WebServlet("/veiculos")
public class VeiculoServlet extends HttpServlet {

    private VeiculoDAO veiculoDAO = new VeiculoDAO();
    private VeiculoBO veiculoBO = new VeiculoBO(veiculoDAO);
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
            carregarFormulario(req, resp, usuarioLogado, null);
            return;
        }

        if ("editar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                Veiculo veiculo = veiculoDAO.buscarPorId(Integer.parseInt(idParam));
                req.setAttribute("veiculo", veiculo);
            }
            carregarFormulario(req, resp, usuarioLogado, (Veiculo) req.getAttribute("veiculo"));
            return;
        }

        if("deletar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                veiculoDAO.deletar(Integer.parseInt(idParam));
            }
            resp.sendRedirect("veiculos");
            return;
        }

        List<Veiculo> veiculos;
        
        if (usuarioLogado.isAdmin()) {
            veiculos = veiculoDAO.listarTodos();
        } else {
            if (usuarioLogado.getClienteId() != null) {
                veiculos = veiculoDAO.listarPorCliente(usuarioLogado.getClienteId());
            } else {
                veiculos = new ArrayList<>();
            }
        }

        req.setAttribute("veiculos", veiculos);

        req.getRequestDispatcher("/WEB-INF/jsp/veiculo/veiculo.jsp")
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

        Veiculo veiculo = new Veiculo();

        // Verificar se é uma atualização (edição) ou novo veículo
        String idParam = req.getParameter("id");
        boolean isEdicao = idParam != null && !idParam.trim().isEmpty() && !"null".equalsIgnoreCase(idParam.trim());

        if (isEdicao) {
            veiculo.setId(Integer.parseInt(idParam.trim()));
        }

        veiculo.setPlaca(req.getParameter("placa"));
        veiculo.setRenavam(req.getParameter("renavam"));
        veiculo.setRntrc(req.getParameter("rntrc"));
        veiculo.setAnoFabricacao(Integer.parseInt(req.getParameter("anoFabricacao")));
        veiculo.setAnoModelo(Integer.parseInt(req.getParameter("anoModelo")));
        veiculo.setTipo(req.getParameter("tipo"));
        veiculo.setTipoOutros(req.getParameter("tipoOutros"));
        veiculo.setQuantidadeEixos(Integer.parseInt(req.getParameter("quantidadeEixos")));
        veiculo.setCombustivel(req.getParameter("combustivel"));
        veiculo.setTaraKg(Integer.parseInt(req.getParameter("taraKg")));
        veiculo.setCapacidadeCargaKg(Integer.parseInt(req.getParameter("capacidadeCargaKg")));
        String volumeM3Param = req.getParameter("volumeM3");
        if (volumeM3Param != null && !volumeM3Param.isEmpty()) {
            veiculo.setVolumeM3(Integer.parseInt(volumeM3Param));
        } else {
            veiculo.setVolumeM3(0);
        }
        veiculo.setStatus(StatusVeiculo.valueOf(req.getParameter("status")));
        
        String motoristaParam = req.getParameter("motoristaId");
        if (motoristaParam != null && !motoristaParam.isEmpty()) {
            veiculo.setMotoristaId(Integer.parseInt(motoristaParam));
        }
        
        veiculo.setManutencaoPendente(
            Boolean.parseBoolean(req.getParameter("manutencaoPendente"))
        );
        
        String seguroParam = req.getParameter("seguroValidade");
        if (seguroParam != null && !seguroParam.isEmpty()) {
            veiculo.setSeguroValidade(LocalDate.parse(seguroParam));
        }

        if (usuarioLogado.isAdmin()) {
            String clienteIdParam = req.getParameter("clienteId");
            if (clienteIdParam != null && !clienteIdParam.isEmpty()) {
                veiculo.setClienteId(Integer.parseInt(clienteIdParam));
            }
        } else {
            veiculo.setClienteId(usuarioLogado.getClienteId());
        }

        try {
            if (!isEdicao) {
                veiculo.setAdicionadoEm(LocalDateTime.now());
                veiculoBO.salvar(veiculo);
            } else {
                veiculoBO.atualizar(veiculo);
            }

            resp.sendRedirect("veiculos");
        } catch (CadastroException e) {
            req.setAttribute("erro", e.getMessage());
            carregarFormulario(req, resp, usuarioLogado, veiculo);
        }
    }

    public void delete(Integer id) {
        veiculoDAO.deletar(id);
    }

    private void carregarFormulario(HttpServletRequest req, HttpServletResponse resp, Usuario usuarioLogado, Veiculo veiculo)
            throws ServletException, IOException {
        req.setAttribute("veiculo", veiculo);
        req.setAttribute("statusVeiculoOptions", StatusVeiculo.values());

        if (usuarioLogado.isAdmin()) {
            List<Cliente> clientes = new ClienteDAO().listarTodos();
            req.setAttribute("clientes", clientes);
            List<Motorista> motoristas = motoristaDAO.listarTodos();
            req.setAttribute("motoristas", motoristas);
        } else if (usuarioLogado.getClienteId() != null) {
            List<Motorista> motoristas = motoristaDAO.listarPorCliente(usuarioLogado.getClienteId());
            req.setAttribute("motoristas", motoristas);
        }

        req.getRequestDispatcher("/WEB-INF/jsp/veiculo/cadastroVeiculo.jsp").forward(req, resp);
    }
}
