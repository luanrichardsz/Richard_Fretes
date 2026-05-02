package br.com.veiculo;

import br.com.veiculo.VeiculoDAO;
import br.com.exception.CadastroException;
import br.com.veiculo.Veiculo;
import br.com.frete.FreteDAO;
import br.com.util.ValidationUtils;

import java.time.LocalDate;

public class VeiculoBO {

    private final VeiculoDAO veiculoDAO;
    private final FreteDAO freteDAO;

    public VeiculoBO() {
        this(new VeiculoDAO(), new FreteDAO());
    }

    public VeiculoBO(VeiculoDAO veiculoDAO) {
        this(veiculoDAO, new FreteDAO());
    }

    public VeiculoBO(VeiculoDAO veiculoDAO, FreteDAO freteDAO) {
        this.veiculoDAO = veiculoDAO;
        this.freteDAO = freteDAO;
    }

    public void salvar(Veiculo veiculo) throws CadastroException {
        validarVeiculo(veiculo, false);
        veiculoDAO.salvar(veiculo);
    }

    public void atualizar(Veiculo veiculo) throws CadastroException {
        validarEdicaoPermitida(veiculo.getId());
        validarVeiculo(veiculo, true);
        veiculoDAO.atualizar(veiculo);
    }

    public void validarEdicaoPermitida(Integer veiculoId) throws CadastroException {
        if (veiculoId == null || veiculoId <= 0) {
            throw new CadastroException("Veículo inválido.");
        }

        Veiculo veiculo = veiculoDAO.buscarPorId(veiculoId);
        if (veiculo == null) {
            throw new CadastroException("Veículo não encontrado.");
        }

        if (veiculo.getStatus() == Veiculo.StatusVeiculo.EM_VIAGEM
                || freteDAO.existeFreteEmTransitoParaVeiculo(veiculoId, null)) {
            throw new CadastroException("Não é permitido editar um veículo que está em viagem.");
        }
    }

    public void deletar(Integer veiculoId) throws CadastroException {
        if (veiculoId == null || veiculoId <= 0) {
            throw new CadastroException("Veículo inválido.");
        }

        Veiculo veiculo = veiculoDAO.buscarPorId(veiculoId);
        if (veiculo == null) {
            throw new CadastroException("Veículo não encontrado.");
        }

        if (veiculo.getStatus() == Veiculo.StatusVeiculo.EM_VIAGEM
                || freteDAO.existeFreteEmTransitoParaVeiculo(veiculoId, null)) {
            throw new CadastroException("Não é permitido excluir um veículo que está em viagem.");
        }

        veiculoDAO.deletar(veiculoId);
    }

    private void validarVeiculo(Veiculo veiculo, boolean emEdicao) throws CadastroException {
        if (veiculo == null) {
            throw new CadastroException("Veículo inválido.");
        }

        String placa = veiculo.getPlaca() == null ? "" : veiculo.getPlaca().trim().toUpperCase();
        if (!placa.matches("^[A-Z]{3}[0-9][A-Z0-9][0-9]{2}$")) {
            throw new CadastroException("Placa inválida.");
        }

        if (veiculoDAO.existePlacaParaOutroVeiculo(placa, emEdicao ? veiculo.getId() : null)) {
            throw new CadastroException("Já existe um veículo cadastrado com esta placa.");
        }

        String renavam = ValidationUtils.manterSomenteDigitos(veiculo.getRenavam());
        if (renavam.length() != 11) {
            throw new CadastroException("RENAVAM inválido.");
        }

        if (veiculoDAO.existeRenavamParaOutroVeiculo(renavam, emEdicao ? veiculo.getId() : null)) {
            throw new CadastroException("Já existe um veículo cadastrado com este RENAVAM.");
        }

        if (!ValidationUtils.estaVazio(veiculo.getRntrc())) {
            String rntrc = ValidationUtils.manterSomenteDigitos(veiculo.getRntrc());
            if (rntrc.length() > 20) {
                throw new CadastroException("RNTRC inválido.");
            }
            veiculo.setRntrc(rntrc);
        }

        int anoAtual = LocalDate.now().getYear() + 1;
        if (veiculo.getAnoFabricacao() < 1950 || veiculo.getAnoFabricacao() > anoAtual) {
            throw new CadastroException("Ano de fabricação inválido.");
        }

        if (veiculo.getAnoModelo() < 1950 || veiculo.getAnoModelo() > anoAtual) {
            throw new CadastroException("Ano do modelo inválido.");
        }

        if (veiculo.getAnoModelo() + 1 < veiculo.getAnoFabricacao()) {
            throw new CadastroException("Ano do modelo não pode ser muito anterior ao de fabricação.");
        }

        if (ValidationUtils.estaVazio(veiculo.getTipo())) {
            throw new CadastroException("Tipo do veículo é obrigatório.");
        }

        if (veiculo.getQuantidadeEixos() <= 0) {
            throw new CadastroException("Quantidade de eixos inválida.");
        }

        if (veiculo.getTaraKg() <= 0) {
            throw new CadastroException("Tara inválida.");
        }

        if (veiculo.getCapacidadeCargaKg() <= 0) {
            throw new CadastroException("Capacidade de carga inválida.");
        }

        if (veiculo.getVolumeM3() < 0) {
            throw new CadastroException("Volume inválido.");
        }

        if (veiculo.getClienteId() == null) {
            throw new CadastroException("Cliente responsável pelo veículo é obrigatório.");
        }

        if (emEdicao
                && veiculo.getStatus() == Veiculo.StatusVeiculo.DISPONIVEL
                && freteDAO.existeFreteEmTransitoParaVeiculo(veiculo.getId(), null)) {
            throw new CadastroException(
                "Não é permitido alterar manualmente o status do veículo para Disponível enquanto houver frete em trânsito."
            );
        }

        veiculo.setPlaca(placa);
        veiculo.setRenavam(renavam);
        veiculo.setTipo(veiculo.getTipo().trim());

        if (veiculo.getTipoOutros() != null) {
            veiculo.setTipoOutros(veiculo.getTipoOutros().trim());
        }
    }
}
