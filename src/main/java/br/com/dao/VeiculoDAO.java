package br.com.dao;

import br.com.connection.ConnectionFactory;
import br.com.model.Veiculo;
import br.com.model.Veiculo.StatusVeiculo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VeiculoDAO extends ConnectionFactory {

    public void salvar(Veiculo veiculo) {
        String sql = "INSERT INTO veiculo (placa, renavam, rntrc, ano_fabricacao, ano_modelo, tipo, tipo_outros, quantidade_eixos, combustivel, tara_kg, capacidade_carga_kg, volume_m3, status, adicionado_em, motorista_id, manutencao_pendente, seguro_validade, cliente_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?::status_veiculo_enum, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, veiculo.getPlaca());
            stmt.setString(2, veiculo.getRenavam());
            stmt.setString(3, veiculo.getRntrc());
            stmt.setInt(4, veiculo.getAnoFabricacao());
            stmt.setInt(5, veiculo.getAnoModelo());
            stmt.setString(6, veiculo.getTipo());
            stmt.setString(7, veiculo.getTipoOutros());
            stmt.setInt(8, veiculo.getQuantidadeEixos());
            stmt.setString(9, veiculo.getCombustivel());
            stmt.setInt(10, veiculo.getTaraKg());
            stmt.setInt(11, veiculo.getCapacidadeCargaKg());
            stmt.setInt(12, veiculo.getVolumeM3());
            stmt.setString(13, veiculo.getStatus().name());
            stmt.setTimestamp(14, Timestamp.valueOf(veiculo.getAdicionadoEm()));
            stmt.setObject(15, veiculo.getMotoristaId());
            stmt.setBoolean(16, veiculo.isManutencaoPendente());
            stmt.setDate(17, veiculo.getSeguroValidade() != null ? Date.valueOf(veiculo.getSeguroValidade()) : null);
            stmt.setObject(18, veiculo.getClienteId());

            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    veiculo.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void atualizar(Veiculo veiculo) {
        String sql = "UPDATE veiculo SET placa = ?, renavam = ?, rntrc = ?, ano_fabricacao = ?, ano_modelo = ?, tipo = ?, tipo_outros = ?, quantidade_eixos = ?, combustivel = ?, tara_kg = ?, capacidade_carga_kg = ?, volume_m3 = ?, status = ?::status_veiculo_enum, motorista_id = ?, manutencao_pendente = ?, seguro_validade = ?, cliente_id = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, veiculo.getPlaca());
            stmt.setString(2, veiculo.getRenavam());
            stmt.setString(3, veiculo.getRntrc());
            stmt.setInt(4, veiculo.getAnoFabricacao());
            stmt.setInt(5, veiculo.getAnoModelo());
            stmt.setString(6, veiculo.getTipo());
            stmt.setString(7, veiculo.getTipoOutros());
            stmt.setInt(8, veiculo.getQuantidadeEixos());
            stmt.setString(9, veiculo.getCombustivel());
            stmt.setInt(10, veiculo.getTaraKg());
            stmt.setInt(11, veiculo.getCapacidadeCargaKg());
            stmt.setInt(12, veiculo.getVolumeM3());
            stmt.setString(13, veiculo.getStatus().name());
            stmt.setObject(14, veiculo.getMotoristaId());
            stmt.setBoolean(15, veiculo.isManutencaoPendente());
            stmt.setDate(16, veiculo.getSeguroValidade() != null ? Date.valueOf(veiculo.getSeguroValidade()) : null);
            stmt.setObject(17, veiculo.getClienteId());
            stmt.setInt(18, veiculo.getId());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Veiculo buscarPorId(Integer id) {
        String sql = "SELECT * FROM veiculo WHERE id = ?";
        Veiculo veiculo = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    veiculo = mapearResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return veiculo;
    }

    public List<Veiculo> listarTodos() {
        List<Veiculo> veiculos = new ArrayList<>();
        String sql = "SELECT * FROM veiculo";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                veiculos.add(mapearResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return veiculos;
    }

    public List<Veiculo> listarPorStatus(StatusVeiculo status) {
        List<Veiculo> veiculos = new ArrayList<>();
        String sql = "SELECT * FROM veiculo WHERE status = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status.name());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    veiculos.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return veiculos;
    }

    public Veiculo buscarPorPlaca(String placa) {
        String sql = "SELECT * FROM veiculo WHERE placa = ?";
        Veiculo veiculo = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, placa);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    veiculo = mapearResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return veiculo;
    }

    public void deletar(Integer id) {
        String sql = "DELETE FROM veiculo WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Veiculo mapearResultSet(ResultSet rs) throws SQLException {
        Veiculo veiculo = new Veiculo();
        veiculo.setId(rs.getInt("id"));
        veiculo.setPlaca(rs.getString("placa"));
        veiculo.setRenavam(rs.getString("renavam"));
        veiculo.setRntrc(rs.getString("rntrc"));
        veiculo.setAnoFabricacao(rs.getInt("ano_fabricacao"));
        veiculo.setAnoModelo(rs.getInt("ano_modelo"));
        veiculo.setTipo(rs.getString("tipo"));
        veiculo.setTipoOutros(rs.getString("tipo_outros"));
        veiculo.setQuantidadeEixos(rs.getInt("quantidade_eixos"));
        veiculo.setCombustivel(rs.getString("combustivel"));
        veiculo.setTaraKg(rs.getInt("tara_kg"));
        veiculo.setCapacidadeCargaKg(rs.getInt("capacidade_carga_kg"));
        veiculo.setVolumeM3(rs.getInt("volume_m3"));
        veiculo.setStatus(StatusVeiculo.valueOf(rs.getString("status")));
        veiculo.setAdicionadoEm(rs.getTimestamp("adicionado_em").toLocalDateTime());
        veiculo.setMotoristaId(rs.getObject("motorista_id") != null ? rs.getInt("motorista_id") : null);
        veiculo.setManutencaoPendente(rs.getBoolean("manutencao_pendente"));
        veiculo.setSeguroValidade(rs.getDate("seguro_validade") != null ? rs.getDate("seguro_validade").toLocalDate() : null);
        veiculo.setClienteId(rs.getObject("cliente_id") != null ? rs.getInt("cliente_id") : null);
        return veiculo;
    }

    public List<Veiculo> listarPorCliente(Integer clienteId) {
        List<Veiculo> veiculos = new ArrayList<>();
        String sql = "SELECT * FROM veiculo WHERE cliente_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, clienteId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    veiculos.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return veiculos;
    }
}
