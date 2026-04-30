package br.com.dao;

import br.com.connection.ConnectionFactory;
import br.com.model.Frete;
import br.com.model.Frete.StatusFrete;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FreteDAO extends ConnectionFactory {

    public void salvar(Frete frete) {
        String sql = "INSERT INTO frete (numero_frete, remetente_id, destinatario_id, endereco_origem_id, endereco_destino_id, motorista_id, veiculo_id, chave_nfe, origem_ibge, destino_ibge, natureza_carga, peso_bruto, volumes, valor_frete_bruto, valor_pedagio, aliquota_icms, valor_icms, valor_total, status, data_emissao, previsao_entrega, motivo_falha, data_saida, data_entrega, distancia_km) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?::status_frete_enum, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, frete.getNumeroFrete());
            stmt.setInt(2, frete.getRemetenteId());
            stmt.setInt(3, frete.getDestinatarioId());
            stmt.setInt(4, frete.getEnderecoOrigemId());
            stmt.setInt(5, frete.getEnderecoDestinoId());
            stmt.setInt(6, frete.getMotoristaId());
            stmt.setInt(7, frete.getVeiculoId());
            stmt.setString(8, frete.getChaveNfe());
            stmt.setString(9, frete.getOrigemIbge());
            stmt.setString(10, frete.getDestinoIbge());
            stmt.setString(11, frete.getNaturezaCarga());
            stmt.setBigDecimal(12, frete.getPesoBruto());
            stmt.setInt(13, frete.getVolumes());
            stmt.setBigDecimal(14, frete.getValorFreteBruto());
            stmt.setBigDecimal(15, frete.getValorPedagio());
            stmt.setBigDecimal(16, frete.getAliquotaIcms());
            stmt.setBigDecimal(17, frete.getValorIcms());
            stmt.setBigDecimal(18, frete.getValorTotal());
            stmt.setString(19, frete.getStatus().name());
            stmt.setTimestamp(20, Timestamp.valueOf(frete.getDataEmissao()));
            stmt.setDate(21, Date.valueOf(frete.getPrevisaoEntrega()));
            stmt.setString(22, frete.getMotivoFalha());
            stmt.setTimestamp(23, frete.getDataSaida() != null ? Timestamp.valueOf(frete.getDataSaida()) : null);
            stmt.setTimestamp(24, frete.getDataEntrega() != null ? Timestamp.valueOf(frete.getDataEntrega()) : null);
            stmt.setBigDecimal(25, frete.getDistanciaKm());

            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    frete.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void atualizar(Frete frete) {
        String sql = "UPDATE frete SET numero_frete = ?, remetente_id = ?, destinatario_id = ?, endereco_origem_id = ?, endereco_destino_id = ?, motorista_id = ?, veiculo_id = ?, chave_nfe = ?, origem_ibge = ?, destino_ibge = ?, natureza_carga = ?, peso_bruto = ?, volumes = ?, valor_frete_bruto = ?, valor_pedagio = ?, aliquota_icms = ?, valor_icms = ?, valor_total = ?, status = ?::status_frete_enum, previsao_entrega = ?, motivo_falha = ?, data_saida = ?, data_entrega = ?, distancia_km = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, frete.getNumeroFrete());
            stmt.setInt(2, frete.getRemetenteId());
            stmt.setInt(3, frete.getDestinatarioId());
            stmt.setInt(4, frete.getEnderecoOrigemId());
            stmt.setInt(5, frete.getEnderecoDestinoId());
            stmt.setInt(6, frete.getMotoristaId());
            stmt.setInt(7, frete.getVeiculoId());
            stmt.setString(8, frete.getChaveNfe());
            stmt.setString(9, frete.getOrigemIbge());
            stmt.setString(10, frete.getDestinoIbge());
            stmt.setString(11, frete.getNaturezaCarga());
            stmt.setBigDecimal(12, frete.getPesoBruto());
            stmt.setInt(13, frete.getVolumes());
            stmt.setBigDecimal(14, frete.getValorFreteBruto());
            stmt.setBigDecimal(15, frete.getValorPedagio());
            stmt.setBigDecimal(16, frete.getAliquotaIcms());
            stmt.setBigDecimal(17, frete.getValorIcms());
            stmt.setBigDecimal(18, frete.getValorTotal());
            stmt.setString(19, frete.getStatus().name());
            stmt.setDate(20, Date.valueOf(frete.getPrevisaoEntrega()));
            stmt.setString(21, frete.getMotivoFalha());
            stmt.setTimestamp(22, frete.getDataSaida() != null ? Timestamp.valueOf(frete.getDataSaida()) : null);
            stmt.setTimestamp(23, frete.getDataEntrega() != null ? Timestamp.valueOf(frete.getDataEntrega()) : null);
            stmt.setBigDecimal(24, frete.getDistanciaKm());
            stmt.setInt(25, frete.getId());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Frete buscarPorId(Integer id) {
        String sql = "SELECT * FROM frete WHERE id = ?";
        Frete frete = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    frete = mapearResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return frete;
    }

    public Frete buscarPorNumero(String numeroFrete) {
        String sql = "SELECT * FROM frete WHERE numero_frete = ?";
        Frete frete = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, numeroFrete);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    frete = mapearResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return frete;
    }

    public boolean existeNumeroParaOutroFrete(String numeroFrete, Integer freteIdIgnorado) {
        String sql = "SELECT COUNT(*) FROM frete WHERE numero_frete = ? AND (? IS NULL OR id <> ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, numeroFrete);
            stmt.setObject(2, freteIdIgnorado, Types.INTEGER);
            stmt.setObject(3, freteIdIgnorado, Types.INTEGER);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Frete> listarTodos() {
        List<Frete> fretes = new ArrayList<>();
        String sql = "SELECT * FROM frete";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                fretes.add(mapearResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return fretes;
    }

    public List<Frete> listarPorStatus(StatusFrete status) {
        List<Frete> fretes = new ArrayList<>();
        String sql = "SELECT * FROM frete WHERE status = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status.name());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    fretes.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return fretes;
    }

    public List<Frete> listarPorMotorista(Integer motoristaId) {
        List<Frete> fretes = new ArrayList<>();
        String sql = "SELECT * FROM frete WHERE motorista_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, motoristaId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    fretes.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return fretes;
    }

    public List<Frete> listarPorVeiculo(Integer veiculoId) {
        List<Frete> fretes = new ArrayList<>();
        String sql = "SELECT * FROM frete WHERE veiculo_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, veiculoId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    fretes.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return fretes;
    }

    public List<Frete> listarPorCliente(Integer clienteId) {
        List<Frete> fretes = new ArrayList<>();
        String sql = "SELECT * FROM frete WHERE remetente_id = ? OR destinatario_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, clienteId);
            stmt.setInt(2, clienteId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    fretes.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return fretes;
    }

    public void deletar(Integer id) {
        String sql = "DELETE FROM frete WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Frete mapearResultSet(ResultSet rs) throws SQLException {
        Frete frete = new Frete();
        frete.setId(rs.getInt("id"));
        frete.setNumeroFrete(rs.getString("numero_frete"));
        frete.setRemetenteId(rs.getInt("remetente_id"));
        frete.setDestinatarioId(rs.getInt("destinatario_id"));
        frete.setEnderecoOrigemId(rs.getInt("endereco_origem_id"));
        frete.setEnderecoDestinoId(rs.getInt("endereco_destino_id"));
        frete.setMotoristaId(rs.getInt("motorista_id"));
        frete.setVeiculoId(rs.getInt("veiculo_id"));
        frete.setChaveNfe(rs.getString("chave_nfe"));
        frete.setOrigemIbge(rs.getString("origem_ibge"));
        frete.setDestinoIbge(rs.getString("destino_ibge"));
        frete.setNaturezaCarga(rs.getString("natureza_carga"));
        frete.setPesoBruto(rs.getBigDecimal("peso_bruto"));
        frete.setVolumes(rs.getInt("volumes"));
        frete.setValorFreteBruto(rs.getBigDecimal("valor_frete_bruto"));
        frete.setValorPedagio(rs.getBigDecimal("valor_pedagio"));
        frete.setAliquotaIcms(rs.getBigDecimal("aliquota_icms"));
        frete.setValorIcms(rs.getBigDecimal("valor_icms"));
        frete.setValorTotal(rs.getBigDecimal("valor_total"));
        frete.setStatus(StatusFrete.valueOf(rs.getString("status")));
        frete.setDataEmissao(rs.getTimestamp("data_emissao").toLocalDateTime());
        frete.setPrevisaoEntrega(rs.getDate("previsao_entrega").toLocalDate());
        frete.setMotivoFalha(rs.getString("motivo_falha"));
        frete.setDataSaida(rs.getTimestamp("data_saida") != null ? rs.getTimestamp("data_saida").toLocalDateTime() : null);
        frete.setDataEntrega(rs.getTimestamp("data_entrega") != null ? rs.getTimestamp("data_entrega").toLocalDateTime() : null);
        frete.setDistanciaKm(rs.getBigDecimal("distancia_km"));
        return frete;
    }
}
