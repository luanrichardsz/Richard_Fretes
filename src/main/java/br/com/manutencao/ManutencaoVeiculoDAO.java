package br.com.manutencao;

import br.com.cliente.Cliente;
import br.com.connection.ConnectionFactory;
import br.com.manutencao.ManutencaoVeiculo.StatusManutencao;
import br.com.manutencao.ManutencaoVeiculo.TipoManutencao;
import br.com.veiculo.Veiculo;
import br.com.veiculo.Veiculo.StatusVeiculo;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ManutencaoVeiculoDAO extends ConnectionFactory {

    private static final String SQL_BASE_LISTAGEM =
            "SELECT mv.*, " +
            "v.placa AS veiculo_placa, v.tipo AS veiculo_tipo, v.status AS veiculo_status, " +
            "c.id AS cliente_rel_id, c.razao_social AS cliente_razao_social " +
            "FROM manutencao_veiculo mv " +
            "JOIN veiculo v ON v.id = mv.veiculo_id " +
            "LEFT JOIN cliente c ON c.id = v.cliente_id ";

    public void salvar(Connection conn, ManutencaoVeiculo manutencao) throws SQLException {
        String sql = "INSERT INTO manutencao_veiculo "
                + "(veiculo_id, tipo, status, descricao, data_prevista, data_realizacao, custo, fornecedor_oficina, observacao, adicionado_em) "
                + "VALUES (?, ?::tipo_manutencao_enum, ?::status_manutencao_enum, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            preencherParametros(stmt, manutencao);
            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    manutencao.setId(generatedKeys.getInt(1));
                }
            }
        }
    }

    public void atualizar(Connection conn, ManutencaoVeiculo manutencao) throws SQLException {
        String sql = "UPDATE manutencao_veiculo SET veiculo_id = ?, tipo = ?::tipo_manutencao_enum, "
                + "status = ?::status_manutencao_enum, descricao = ?, data_prevista = ?, data_realizacao = ?, "
                + "custo = ?, fornecedor_oficina = ?, observacao = ? WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, manutencao.getVeiculoId());
            stmt.setString(2, manutencao.getTipo().name());
            stmt.setString(3, manutencao.getStatus().name());
            stmt.setString(4, manutencao.getDescricao());
            stmt.setDate(5, Date.valueOf(manutencao.getDataPrevista()));
            stmt.setObject(6, manutencao.getDataRealizacao() != null ? Date.valueOf(manutencao.getDataRealizacao()) : null, Types.DATE);
            stmt.setBigDecimal(7, manutencao.getCusto());
            stmt.setString(8, manutencao.getFornecedorOficina());
            stmt.setString(9, manutencao.getObservacao());
            stmt.setInt(10, manutencao.getId());
            stmt.executeUpdate();
        }
    }

    public void deletar(Integer id) {
        String sql = "DELETE FROM manutencao_veiculo WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ManutencaoVeiculo buscarPorId(Integer id) {
        String sql = SQL_BASE_LISTAGEM + "WHERE mv.id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapearResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<ManutencaoVeiculo> listarTodas() {
        return listarPorSql(SQL_BASE_LISTAGEM + "ORDER BY mv.data_prevista ASC, mv.adicionado_em DESC", null);
    }

    public List<ManutencaoVeiculo> listarPorCliente(Integer clienteId) {
        return listarPorSql(SQL_BASE_LISTAGEM + "WHERE v.cliente_id = ? ORDER BY mv.data_prevista ASC, mv.adicionado_em DESC", clienteId);
    }

    public List<ManutencaoVeiculo> listarPorVeiculo(Integer veiculoId) {
        return listarPorSql(SQL_BASE_LISTAGEM + "WHERE mv.veiculo_id = ? ORDER BY mv.data_prevista DESC, mv.adicionado_em DESC", veiculoId);
    }

    public List<ManutencaoVeiculo> listarPorVeiculo(Connection conn, Integer veiculoId) throws SQLException {
        return listarPorSql(conn, SQL_BASE_LISTAGEM + "WHERE mv.veiculo_id = ? ORDER BY mv.data_prevista DESC, mv.adicionado_em DESC", veiculoId);
    }

    public List<Veiculo> listarVeiculosComManutencao() {
        String sql = "SELECT DISTINCT v.id, v.placa, v.tipo, v.tipo_outros, v.status, v.cliente_id, "
                + "c.id AS cliente_rel_id, c.razao_social AS cliente_razao_social "
                + "FROM veiculo v "
                + "JOIN manutencao_veiculo mv ON mv.veiculo_id = v.id "
                + "LEFT JOIN cliente c ON c.id = v.cliente_id "
                + "ORDER BY v.placa ASC";
        return listarVeiculosPorSql(sql, null);
    }

    public List<Veiculo> listarVeiculosComManutencaoPorCliente(Integer clienteId) {
        String sql = "SELECT DISTINCT v.id, v.placa, v.tipo, v.tipo_outros, v.status, v.cliente_id, "
                + "c.id AS cliente_rel_id, c.razao_social AS cliente_razao_social "
                + "FROM veiculo v "
                + "JOIN manutencao_veiculo mv ON mv.veiculo_id = v.id "
                + "LEFT JOIN cliente c ON c.id = v.cliente_id "
                + "WHERE v.cliente_id = ? "
                + "ORDER BY v.placa ASC";
        return listarVeiculosPorSql(sql, clienteId);
    }

    public boolean existeManutencaoEmAndamento(Integer veiculoId, Integer manutencaoIgnorada) {
        String sql = "SELECT COUNT(*) FROM manutencao_veiculo WHERE veiculo_id = ? AND status = 'EM_ANDAMENTO' "
                + "AND (? IS NULL OR id <> ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, veiculoId);
            stmt.setObject(2, manutencaoIgnorada, Types.INTEGER);
            stmt.setObject(3, manutencaoIgnorada, Types.INTEGER);

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

    public ResumoManutencaoVeiculo resumirPorVeiculo(Integer veiculoId) {
        try (Connection conn = getConnection()) {
            return resumirPorVeiculo(conn, veiculoId);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return new ResumoManutencaoVeiculo(false, false, false, false, null, null, null, null);
    }

    public ResumoManutencaoVeiculo resumirPorVeiculo(Connection conn, Integer veiculoId) throws SQLException {
        boolean emAndamento = false;
        boolean pendente = false;
        boolean vencida = false;
        boolean proxima = false;
        LocalDate proximaData = null;
        String proximaDescricao = null;
        LocalDate ultimaData = null;
        String ultimaDescricao = null;
        LocalDate hoje = LocalDate.now();
        LocalDate limiteProximo = hoje.plusDays(7);

        for (ManutencaoVeiculo manutencao : listarPorVeiculo(conn, veiculoId)) {
            if (manutencao.getStatus() == StatusManutencao.EM_ANDAMENTO) {
                emAndamento = true;
                pendente = true;
            }

            if (manutencao.getStatus() == StatusManutencao.AGENDADA) {
                pendente = true;

                if (manutencao.getDataPrevista() != null) {
                    if (manutencao.getDataPrevista().isBefore(hoje)) {
                        vencida = true;
                    } else if (!manutencao.getDataPrevista().isAfter(limiteProximo)) {
                        proxima = true;
                    }

                    if (proximaData == null || manutencao.getDataPrevista().isBefore(proximaData)) {
                        proximaData = manutencao.getDataPrevista();
                        proximaDescricao = manutencao.getDescricao();
                    }
                }
            }

            if (manutencao.getStatus() == StatusManutencao.CONCLUIDA && manutencao.getDataRealizacao() != null) {
                if (ultimaData == null || manutencao.getDataRealizacao().isAfter(ultimaData)) {
                    ultimaData = manutencao.getDataRealizacao();
                    ultimaDescricao = manutencao.getDescricao();
                }
            }
        }

        return new ResumoManutencaoVeiculo(emAndamento, pendente, vencida, proxima, proximaData, proximaDescricao, ultimaData, ultimaDescricao);
    }

    public void sincronizarEstadoVeiculo(Connection conn, Integer veiculoId) throws SQLException {
        ResumoManutencaoVeiculo resumo = resumirPorVeiculo(conn, veiculoId);
        String sql = "UPDATE veiculo SET manutencao_pendente = ?, status = CASE "
                + "WHEN ? = true THEN 'EM_MANUTENCAO'::status_veiculo_enum "
                + "WHEN status = 'EM_MANUTENCAO'::status_veiculo_enum THEN 'DISPONIVEL'::status_veiculo_enum "
                + "ELSE status END WHERE id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, resumo.isManutencaoPendente());
            stmt.setBoolean(2, resumo.isManutencaoEmAndamento());
            stmt.setInt(3, veiculoId);
            stmt.executeUpdate();
        }
    }

    private List<ManutencaoVeiculo> listarPorSql(String sql, Integer parametro) {
        List<ManutencaoVeiculo> manutencoes = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (parametro != null) {
                stmt.setInt(1, parametro);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    manutencoes.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return manutencoes;
    }

    private List<ManutencaoVeiculo> listarPorSql(Connection conn, String sql, Integer parametro) throws SQLException {
        List<ManutencaoVeiculo> manutencoes = new ArrayList<>();

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (parametro != null) {
                stmt.setInt(1, parametro);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    manutencoes.add(mapearResultSet(rs));
                }
            }
        }

        return manutencoes;
    }

    private List<Veiculo> listarVeiculosPorSql(String sql, Integer parametro) {
        List<Veiculo> veiculos = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            if (parametro != null) {
                stmt.setInt(1, parametro);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    veiculos.add(mapearVeiculoResumido(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return veiculos;
    }

    private void preencherParametros(PreparedStatement stmt, ManutencaoVeiculo manutencao) throws SQLException {
        stmt.setInt(1, manutencao.getVeiculoId());
        stmt.setString(2, manutencao.getTipo().name());
        stmt.setString(3, manutencao.getStatus().name());
        stmt.setString(4, manutencao.getDescricao());
        stmt.setDate(5, Date.valueOf(manutencao.getDataPrevista()));
        stmt.setObject(6, manutencao.getDataRealizacao() != null ? Date.valueOf(manutencao.getDataRealizacao()) : null, Types.DATE);
        stmt.setBigDecimal(7, manutencao.getCusto());
        stmt.setString(8, manutencao.getFornecedorOficina());
        stmt.setString(9, manutencao.getObservacao());
        stmt.setTimestamp(10, Timestamp.valueOf(manutencao.getAdicionadoEm()));
    }

    private ManutencaoVeiculo mapearResultSet(ResultSet rs) throws SQLException {
        ManutencaoVeiculo manutencao = new ManutencaoVeiculo();
        manutencao.setId(rs.getInt("id"));
        manutencao.setVeiculoId(rs.getInt("veiculo_id"));
        manutencao.setTipo(TipoManutencao.valueOf(rs.getString("tipo")));
        manutencao.setStatus(StatusManutencao.valueOf(rs.getString("status")));
        manutencao.setDescricao(rs.getString("descricao"));
        manutencao.setDataPrevista(rs.getDate("data_prevista").toLocalDate());
        manutencao.setDataRealizacao(rs.getDate("data_realizacao") != null ? rs.getDate("data_realizacao").toLocalDate() : null);
        manutencao.setCusto(rs.getBigDecimal("custo") != null ? rs.getBigDecimal("custo") : BigDecimal.ZERO);
        manutencao.setFornecedorOficina(rs.getString("fornecedor_oficina"));
        manutencao.setObservacao(rs.getString("observacao"));
        manutencao.setAdicionadoEm(rs.getTimestamp("adicionado_em").toLocalDateTime());

        Veiculo veiculo = new Veiculo();
        veiculo.setId(manutencao.getVeiculoId());
        veiculo.setPlaca(rs.getString("veiculo_placa"));
        veiculo.setTipo(rs.getString("veiculo_tipo"));
        veiculo.setStatus(StatusVeiculo.valueOf(rs.getString("veiculo_status")));

        if (rs.getObject("cliente_rel_id") != null) {
            Cliente cliente = new Cliente();
            cliente.setId(rs.getInt("cliente_rel_id"));
            cliente.setRazaoSocial(rs.getString("cliente_razao_social"));
            veiculo.setCliente(cliente);
        }

        manutencao.setVeiculo(veiculo);
        return manutencao;
    }

    private Veiculo mapearVeiculoResumido(ResultSet rs) throws SQLException {
        Veiculo veiculo = new Veiculo();
        veiculo.setId(rs.getInt("id"));
        veiculo.setPlaca(rs.getString("placa"));
        veiculo.setTipo(rs.getString("tipo"));
        veiculo.setTipoOutros(rs.getString("tipo_outros"));
        veiculo.setClienteId((Integer) rs.getObject("cliente_id"));
        veiculo.setStatus(StatusVeiculo.valueOf(rs.getString("status")));

        Integer clienteId = (Integer) rs.getObject("cliente_rel_id");
        if (clienteId != null) {
            Cliente cliente = new Cliente();
            cliente.setId(clienteId);
            cliente.setRazaoSocial(rs.getString("cliente_razao_social"));
            veiculo.setCliente(cliente);
        }

        return veiculo;
    }
}
