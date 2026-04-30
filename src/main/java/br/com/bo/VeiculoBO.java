package br.com.bo;

import br.com.dao.VeiculoDAO;
import br.com.exception.CadastroException;
import br.com.model.Veiculo;
import br.com.util.ValidationUtils;

import java.time.LocalDate;

public class VeiculoBO {

    private final VeiculoDAO veiculoDAO;

    public VeiculoBO() {
        this(new VeiculoDAO());
    }

    public VeiculoBO(VeiculoDAO veiculoDAO) {
        this.veiculoDAO = veiculoDAO;
    }

    public void salvar(Veiculo veiculo) throws CadastroException {
        validarVeiculo(veiculo, false);
        veiculoDAO.salvar(veiculo);
    }

    public void atualizar(Veiculo veiculo) throws CadastroException {
        validarVeiculo(veiculo, true);
        veiculoDAO.atualizar(veiculo);
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

        veiculo.setPlaca(placa);
        veiculo.setRenavam(renavam);
        veiculo.setTipo(veiculo.getTipo().trim());

        if (veiculo.getTipoOutros() != null) {
            veiculo.setTipoOutros(veiculo.getTipoOutros().trim());
        }
    }
}
