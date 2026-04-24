package br.com.controller;

import br.com.dao.VeiculoDAO;
import br.com.model.Veiculo;
import br.com.model.Veiculo.StatusVeiculo;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/veiculos")
public class VeiculoServlet extends HttpServlet {

    private VeiculoDAO veiculoDAO = new VeiculoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String acao = req.getParameter("acao");

        if ("novo".equals(acao)) {
            req.getRequestDispatcher("/WEB-INF/jsp/veiculo/cadastroVeiculo.jsp").forward(req, resp);
            return;
        }

        if ("editar".equals(acao)) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                Veiculo veiculo = veiculoDAO.buscarPorId(Integer.parseInt(idParam));
                req.setAttribute("veiculo", veiculo);
            }
            req.getRequestDispatcher("/WEB-INF/jsp/veiculo/cadastroVeiculo.jsp").forward(req, resp);
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

        List<Veiculo> veiculos = veiculoDAO.listarTodos();

        req.setAttribute("veiculos", veiculos);

        req.getRequestDispatcher("/WEB-INF/jsp/veiculo/veiculo.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Veiculo veiculo = new Veiculo();

        // Verificar se é uma atualização (edição) ou novo veículo
        String idParam = req.getParameter("id");
        boolean isEdicao = idParam != null && !idParam.isEmpty();

        if (isEdicao) {
            veiculo.setId(Integer.parseInt(idParam));
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
        veiculo.setVolumeM3(Integer.parseInt(req.getParameter("volumeM3")));
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

        if (!isEdicao) {
            veiculo.setAdicionadoEm(LocalDateTime.now());
            veiculoDAO.salvar(veiculo);
        } else {
            veiculoDAO.atualizar(veiculo);
        }

        resp.sendRedirect("veiculos");
    }

    public void delete(Integer id) {
        veiculoDAO.deletar(id);
    }
}
