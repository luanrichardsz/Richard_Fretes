package br.com.dao;

import br.com.connection.ConnectionFactory;
import br.com.model.Cliente;
import br.com.model.Cliente.TipoEntrega;
import br.com.model.Cliente.TipoPessoa;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO extends ConnectionFactory {

    public void salvar(Cliente cliente) {
        String sql = "INSERT INTO cliente (razao_social, nome_fantasia, documento, inscricao_estadual, tipo_pessoa, tipo_entrega, email, telefone, ativo, criado_em) VALUES (?, ?, ?, ?, ?::tipo_pessoa_enum, ?::tipo_entrega_enum, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, cliente.getRazaoSocial());
            stmt.setString(2, cliente.getNomeFantasia());
            stmt.setString(3, cliente.getDocumento());
            stmt.setString(4, cliente.getInscricaoEstadual());
            stmt.setString(5, cliente.getTipoPessoa() != null ? cliente.getTipoPessoa().name() : null);
            stmt.setString(6, cliente.getTipoEntrega() != null ? cliente.getTipoEntrega().name() : null);
            stmt.setString(7, cliente.getEmail());
            stmt.setString(8, cliente.getTelefone());
            stmt.setBoolean(9, cliente.isAtivo());
            stmt.setTimestamp(10, Timestamp.valueOf(cliente.getCriadoEm()));

            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    cliente.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void atualizar(Cliente cliente) {
        String sql = "UPDATE cliente SET razao_social = ?, nome_fantasia = ?, documento = ?, inscricao_estadual = ?, tipo_pessoa = ?::tipo_pessoa_enum, tipo_entrega = ?::tipo_entrega_enum, email = ?, telefone = ?, ativo = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cliente.getRazaoSocial());
            stmt.setString(2, cliente.getNomeFantasia());
            stmt.setString(3, cliente.getDocumento());
            stmt.setString(4, cliente.getInscricaoEstadual());
            stmt.setString(5, cliente.getTipoPessoa() != null ? cliente.getTipoPessoa().name() : null);
            stmt.setString(6, cliente.getTipoEntrega() != null ? cliente.getTipoEntrega().name() : null);
            stmt.setString(7, cliente.getEmail());
            stmt.setString(8, cliente.getTelefone());
            stmt.setBoolean(9, cliente.isAtivo());
            stmt.setInt(10, cliente.getId());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Cliente buscarPorId(Integer id) {
        String sql = "SELECT * FROM cliente WHERE id = ?";
        Cliente cliente = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    cliente = new Cliente();
                    cliente.setId(rs.getInt("id"));
                    cliente.setRazaoSocial(rs.getString("razao_social"));
                    cliente.setNomeFantasia(rs.getString("nome_fantasia"));
                    cliente.setDocumento(rs.getString("documento"));
                    cliente.setInscricaoEstadual(rs.getString("inscricao_estadual"));
                    cliente.setTipoPessoa(TipoPessoa.valueOf(rs.getString("tipo_pessoa")));
                    cliente.setTipo(TipoEntrega.valueOf(rs.getString("tipo_entrega")));
                    cliente.setEmail(rs.getString("email"));
                    cliente.setTelefone(rs.getString("telefone"));
                    cliente.setAtivo(rs.getBoolean("ativo"));
                    cliente.setCriadoEm(rs.getTimestamp("criado_em").toLocalDateTime());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cliente;
    }

    public List<Cliente> listarTodos() {
        List<Cliente> clientes = new ArrayList<>();
        String sql = "SELECT * FROM cliente";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setId(rs.getInt("id"));
                cliente.setRazaoSocial(rs.getString("razao_social"));
                cliente.setNomeFantasia(rs.getString("nome_fantasia"));
                cliente.setDocumento(rs.getString("documento"));
                cliente.setInscricaoEstadual(rs.getString("inscricao_estadual"));
                cliente.setTipoPessoa(TipoPessoa.valueOf(rs.getString("tipo_pessoa")));
                cliente.setTipo(TipoEntrega.valueOf(rs.getString("tipo_entrega")));
                cliente.setEmail(rs.getString("email"));
                cliente.setTelefone(rs.getString("telefone"));
                cliente.setAtivo(rs.getBoolean("ativo"));
                cliente.setCriadoEm(rs.getTimestamp("criado_em").toLocalDateTime());

                clientes.add(cliente);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return clientes;
    }

    public Cliente autenticar(String email, String senha) {
        String sql = "SELECT * FROM cliente WHERE email = ? AND senha = ?";
        Cliente cliente = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, senha);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    cliente = new Cliente();
                    cliente.setId(rs.getInt("id"));
                    cliente.setRazaoSocial(rs.getString("razao_social"));
                    cliente.setNomeFantasia(rs.getString("nome_fantasia"));
                    cliente.setDocumento(rs.getString("documento"));
                    cliente.setInscricaoEstadual(rs.getString("inscricao_estadual"));
                    cliente.setTipoPessoa(TipoPessoa.valueOf(rs.getString("tipo_pessoa")));
                    cliente.setTipo(TipoEntrega.valueOf(rs.getString("tipo_entrega")));
                    cliente.setEmail(rs.getString("email"));
                    cliente.setTelefone(rs.getString("telefone"));
                    cliente.setAtivo(rs.getBoolean("ativo"));
                    cliente.setCriadoEm(rs.getTimestamp("criado_em").toLocalDateTime());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cliente;
    }

    public void deletar(Integer id) {
        String sql = "DELETE FROM cliente WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
