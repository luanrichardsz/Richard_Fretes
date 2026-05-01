package br.com.ocorrenciafrete;

import br.com.connection.ConnectionFactory;
import br.com.ocorrenciafrete.OcorrenciaFrete;
import br.com.ocorrenciafrete.OcorrenciaFrete.TipoOcorrencia;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OcorrenciaFreteDAO extends ConnectionFactory {

    public void salvar(OcorrenciaFrete ocorrencia) {
        try (Connection conn = getConnection()) {
            salvar(conn, ocorrencia);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void salvar(Connection conn, OcorrenciaFrete ocorrencia) throws SQLException {
        String sql = "INSERT INTO ocorrencia_frete (frete_id, tipo, data_hora, municipio, uf, latitude, longitude, descricao, recebedor_nome, recebedor_documento, foto_evidencia_url) VALUES (?, ?::tipo_ocorrencia_enum, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, ocorrencia.getFreteId());
            stmt.setString(2, ocorrencia.getTipo().name());
            stmt.setTimestamp(3, Timestamp.valueOf(ocorrencia.getDataHora()));
            stmt.setString(4, ocorrencia.getMunicipio());
            stmt.setString(5, ocorrencia.getUf());
            stmt.setBigDecimal(6, ocorrencia.getLatitude());
            stmt.setBigDecimal(7, ocorrencia.getLongitude());
            stmt.setString(8, ocorrencia.getDescricao());
            stmt.setString(9, ocorrencia.getRecebedorNome());
            stmt.setString(10, ocorrencia.getRecebedorDocumento());
            stmt.setString(11, ocorrencia.getFotoEvidenciaUrl());

            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    ocorrencia.setId(generatedKeys.getInt(1));
                }
            }
        }
    }

    public void atualizar(OcorrenciaFrete ocorrencia) {
        try (Connection conn = getConnection()) {
            atualizar(conn, ocorrencia);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void atualizar(Connection conn, OcorrenciaFrete ocorrencia) throws SQLException {
        String sql = "UPDATE ocorrencia_frete SET frete_id = ?, tipo = ?::tipo_ocorrencia_enum, data_hora = ?, municipio = ?, uf = ?, latitude = ?, longitude = ?, descricao = ?, recebedor_nome = ?, recebedor_documento = ?, foto_evidencia_url = ? WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ocorrencia.getFreteId());
            stmt.setString(2, ocorrencia.getTipo().name());
            stmt.setTimestamp(3, Timestamp.valueOf(ocorrencia.getDataHora()));
            stmt.setString(4, ocorrencia.getMunicipio());
            stmt.setString(5, ocorrencia.getUf());
            stmt.setBigDecimal(6, ocorrencia.getLatitude());
            stmt.setBigDecimal(7, ocorrencia.getLongitude());
            stmt.setString(8, ocorrencia.getDescricao());
            stmt.setString(9, ocorrencia.getRecebedorNome());
            stmt.setString(10, ocorrencia.getRecebedorDocumento());
            stmt.setString(11, ocorrencia.getFotoEvidenciaUrl());
            stmt.setInt(12, ocorrencia.getId());

            stmt.executeUpdate();
        }
    }

    public LocalDateTime buscarUltimaDataHoraPorFrete(Integer freteId, Integer ocorrenciaIdIgnorada) {
        String sql = "SELECT MAX(data_hora) AS ultima_data_hora FROM ocorrencia_frete "
                + "WHERE frete_id = ? AND (? IS NULL OR id <> ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, freteId);
            stmt.setObject(2, ocorrenciaIdIgnorada, Types.INTEGER);
            stmt.setObject(3, ocorrenciaIdIgnorada, Types.INTEGER);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && rs.getTimestamp("ultima_data_hora") != null) {
                    return rs.getTimestamp("ultima_data_hora").toLocalDateTime();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public OcorrenciaFrete buscarPorId(Integer id) {
        String sql = "SELECT * FROM ocorrencia_frete WHERE id = ?";
        OcorrenciaFrete ocorrencia = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ocorrencia = mapearResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ocorrencia;
    }

    public List<OcorrenciaFrete> listarPorFrete(Integer freteId) {
        List<OcorrenciaFrete> ocorrencias = new ArrayList<>();
        String sql = "SELECT * FROM ocorrencia_frete WHERE frete_id = ? ORDER BY data_hora DESC";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, freteId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ocorrencias.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ocorrencias;
    }

    public List<OcorrenciaFrete> listarTodas() {
        List<OcorrenciaFrete> ocorrencias = new ArrayList<>();
        String sql = "SELECT * FROM ocorrencia_frete ORDER BY data_hora DESC";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ocorrencias.add(mapearResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ocorrencias;
    }

    public List<OcorrenciaFrete> listarPorTipo(TipoOcorrencia tipo) {
        List<OcorrenciaFrete> ocorrencias = new ArrayList<>();
        String sql = "SELECT * FROM ocorrencia_frete WHERE tipo = ? ORDER BY data_hora DESC";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, tipo.name());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ocorrencias.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ocorrencias;
    }

    public List<OcorrenciaFrete> listarPorFreteETipo(Integer freteId, TipoOcorrencia tipo) {
        List<OcorrenciaFrete> ocorrencias = new ArrayList<>();
        String sql = "SELECT * FROM ocorrencia_frete WHERE frete_id = ? AND tipo = ? ORDER BY data_hora DESC";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, freteId);
            stmt.setString(2, tipo.name());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ocorrencias.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ocorrencias;
    }

    public void deletar(Integer id) {
        String sql = "DELETE FROM ocorrencia_frete WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deletarPorFrete(Integer freteId) {
        String sql = "DELETE FROM ocorrencia_frete WHERE frete_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, freteId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<OcorrenciaFrete> listarPorCliente(Integer clienteId) {
        List<OcorrenciaFrete> ocorrencias = new ArrayList<>();
        String sql = "SELECT of.* FROM ocorrencia_frete of " +
                     "JOIN frete f ON of.frete_id = f.id " +
                     "WHERE f.remetente_id = ? OR f.destinatario_id = ? " +
                     "ORDER BY of.data_hora DESC";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, clienteId);
            stmt.setInt(2, clienteId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ocorrencias.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ocorrencias;
    }

    private OcorrenciaFrete mapearResultSet(ResultSet rs) throws SQLException {
        OcorrenciaFrete ocorrencia = new OcorrenciaFrete();
        ocorrencia.setId(rs.getInt("id"));
        ocorrencia.setFreteId(rs.getInt("frete_id"));
        ocorrencia.setTipo(TipoOcorrencia.valueOf(rs.getString("tipo")));
        ocorrencia.setDataHora(rs.getTimestamp("data_hora").toLocalDateTime());
        ocorrencia.setMunicipio(rs.getString("municipio"));
        ocorrencia.setUf(rs.getString("uf"));
        ocorrencia.setLatitude(rs.getBigDecimal("latitude"));
        ocorrencia.setLongitude(rs.getBigDecimal("longitude"));
        ocorrencia.setDescricao(rs.getString("descricao"));
        ocorrencia.setRecebedorNome(rs.getString("recebedor_nome"));
        ocorrencia.setRecebedorDocumento(rs.getString("recebedor_documento"));
        ocorrencia.setFotoEvidenciaUrl(rs.getString("foto_evidencia_url"));
        return ocorrencia;
    }
}
