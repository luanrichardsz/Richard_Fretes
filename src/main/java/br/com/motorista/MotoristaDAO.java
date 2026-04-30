package br.com.motorista;

import br.com.connection.ConnectionFactory;
import br.com.motorista.Motorista;
import br.com.motorista.Motorista.CategoriaCnh;
import br.com.motorista.Motorista.StatusMotorista;
import br.com.motorista.Motorista.TipoPix;
import br.com.motorista.Motorista.TipoVinculo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MotoristaDAO extends ConnectionFactory {

    public void salvar(Motorista motorista) {
        String sql = "INSERT INTO motorista (nome_completo, rg, cpf, data_nascimento, telefone, nome_emergencia, telefone_emergencia, parentesco_emergencia, numero_cnh, categoria_cnh, validade_cnh, validade_toxicologico, tipo_vinculo, chave_pix, tipo_pix, status, adicionado_em, cliente_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?::categoria_cnh_enum, ?, ?, ?::tipo_vinculo_enum, ?, ?::tipo_pix_enum, ?::status_motorista_enum, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, motorista.getNomeCompleto());
            stmt.setString(2, motorista.getRg());
            stmt.setString(3, motorista.getCpf());
            stmt.setDate(4, Date.valueOf(motorista.getDataNascimento()));
            stmt.setString(5, motorista.getTelefone());
            stmt.setString(6, motorista.getNomeEmergencia());
            stmt.setString(7, motorista.getTelefoneEmergencia());
            stmt.setString(8, motorista.getParentescoEmergencia());
            stmt.setString(9, motorista.getNumeroCnh());
            stmt.setString(10, motorista.getCategoriaCnh().name());
            stmt.setDate(11, Date.valueOf(motorista.getValidadeCnh()));
            stmt.setDate(12, motorista.getValidadeToxicologico() != null ? Date.valueOf(motorista.getValidadeToxicologico()) : null);
            stmt.setString(13, motorista.getTipoVinculo().name());
            stmt.setString(14, motorista.getChavePix());
            stmt.setString(15, motorista.getTipoPix().name());
            stmt.setString(16, motorista.getStatus().name());
            stmt.setTimestamp(17, Timestamp.valueOf(motorista.getAdicionadoEm()));
            stmt.setInt(18, motorista.getClienteId());

            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    motorista.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void atualizar(Motorista motorista) {
        String sql = "UPDATE motorista SET nome_completo = ?, rg = ?, cpf = ?, data_nascimento = ?, telefone = ?, nome_emergencia = ?, telefone_emergencia = ?, parentesco_emergencia = ?, numero_cnh = ?, categoria_cnh = ?::categoria_cnh_enum, validade_cnh = ?, validade_toxicologico = ?, tipo_vinculo = ?::tipo_vinculo_enum, chave_pix = ?, tipo_pix = ?::tipo_pix_enum, status = ?::status_motorista_enum, cliente_id = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, motorista.getNomeCompleto());
            stmt.setString(2, motorista.getRg());
            stmt.setString(3, motorista.getCpf());
            stmt.setDate(4, Date.valueOf(motorista.getDataNascimento()));
            stmt.setString(5, motorista.getTelefone());
            stmt.setString(6, motorista.getNomeEmergencia());
            stmt.setString(7, motorista.getTelefoneEmergencia());
            stmt.setString(8, motorista.getParentescoEmergencia());
            stmt.setString(9, motorista.getNumeroCnh());
            stmt.setString(10, motorista.getCategoriaCnh().name());
            stmt.setDate(11, Date.valueOf(motorista.getValidadeCnh()));
            stmt.setDate(12, motorista.getValidadeToxicologico() != null ? Date.valueOf(motorista.getValidadeToxicologico()) : null);
            stmt.setString(13, motorista.getTipoVinculo().name());
            stmt.setString(14, motorista.getChavePix());
            stmt.setString(15, motorista.getTipoPix().name());
            stmt.setString(16, motorista.getStatus().name());
            stmt.setInt(17, motorista.getClienteId());
            stmt.setInt(18, motorista.getId());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Motorista buscarPorId(Integer id) {
        String sql = "SELECT * FROM motorista WHERE id = ?";
        Motorista motorista = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    motorista = mapearResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return motorista;
    }

    public List<Motorista> listarTodos() {
        List<Motorista> motoristas = new ArrayList<>();
        String sql = "SELECT * FROM motorista";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                motoristas.add(mapearResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return motoristas;
    }

    public List<Motorista> listarPorStatus(StatusMotorista status) {
        List<Motorista> motoristas = new ArrayList<>();
        String sql = "SELECT * FROM motorista WHERE status = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status.name());

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    motoristas.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return motoristas;
    }

    public boolean existeCpfParaOutroMotorista(String cpf, Integer motoristaIdIgnorado) {
        String sql = "SELECT COUNT(*) FROM motorista WHERE cpf = ? AND (? IS NULL OR id <> ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cpf);
            stmt.setObject(2, motoristaIdIgnorado, Types.INTEGER);
            stmt.setObject(3, motoristaIdIgnorado, Types.INTEGER);

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

    public boolean existeCnhParaOutroMotorista(String numeroCnh, Integer motoristaIdIgnorado) {
        String sql = "SELECT COUNT(*) FROM motorista WHERE numero_cnh = ? AND (? IS NULL OR id <> ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, numeroCnh);
            stmt.setObject(2, motoristaIdIgnorado, Types.INTEGER);
            stmt.setObject(3, motoristaIdIgnorado, Types.INTEGER);

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

    public void deletar(Integer id) {
        String sql = "DELETE FROM motorista WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Motorista mapearResultSet(ResultSet rs) throws SQLException {
        Motorista motorista = new Motorista();
        motorista.setId(rs.getInt("id"));
        motorista.setNomeCompleto(rs.getString("nome_completo"));
        motorista.setRg(rs.getString("rg"));
        motorista.setCpf(rs.getString("cpf"));
        motorista.setDataNascimento(rs.getDate("data_nascimento").toLocalDate());
        motorista.setTelefone(rs.getString("telefone"));
        motorista.setNomeEmergencia(rs.getString("nome_emergencia"));
        motorista.setTelefoneEmergencia(rs.getString("telefone_emergencia"));
        motorista.setParentescoEmergencia(rs.getString("parentesco_emergencia"));
        motorista.setNumeroCnh(rs.getString("numero_cnh"));
        motorista.setCategoriaCnh(CategoriaCnh.valueOf(rs.getString("categoria_cnh")));
        motorista.setValidadeCnh(rs.getDate("validade_cnh").toLocalDate());
        motorista.setValidadeToxicologico(rs.getDate("validade_toxicologico") != null ? rs.getDate("validade_toxicologico").toLocalDate() : null);
        motorista.setTipoVinculo(TipoVinculo.valueOf(rs.getString("tipo_vinculo")));
        motorista.setChavePix(rs.getString("chave_pix"));
        motorista.setTipoPix(TipoPix.valueOf(rs.getString("tipo_pix")));
        motorista.setStatus(StatusMotorista.valueOf(rs.getString("status")));
        motorista.setAdicionadoEm(rs.getTimestamp("adicionado_em").toLocalDateTime());
        motorista.setClienteId(rs.getObject("cliente_id") != null ? rs.getInt("cliente_id") : null);
        return motorista;
    }

    public List<Motorista> listarPorCliente(Integer clienteId) {
        List<Motorista> motoristas = new ArrayList<>();
        String sql = "SELECT * FROM motorista WHERE cliente_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, clienteId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    motoristas.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return motoristas;
    }
}
