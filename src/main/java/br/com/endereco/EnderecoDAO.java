package br.com.endereco;

import br.com.connection.ConnectionFactory;
import br.com.endereco.Endereco;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EnderecoDAO extends ConnectionFactory {

    public void salvar(Endereco endereco) {
        String sql = "INSERT INTO endereco (cliente_id, cep, logradouro, numero, complemento, bairro, municipio, codigo_ibge, uf, ponto_referencia) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, endereco.getClienteId());
            stmt.setString(2, endereco.getCep());
            stmt.setString(3, endereco.getLogradouro());
            stmt.setString(4, endereco.getNumero());
            stmt.setString(5, endereco.getComplemento());
            stmt.setString(6, endereco.getBairro());
            stmt.setString(7, endereco.getMunicipio());
            stmt.setString(8, endereco.getCodigoIbge());
            stmt.setString(9, endereco.getUf());
            stmt.setString(10, endereco.getPontoReferencia());

            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    endereco.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void atualizar(Endereco endereco) {
        String sql = "UPDATE endereco SET cliente_id = ?, cep = ?, logradouro = ?, numero = ?, complemento = ?, bairro = ?, municipio = ?, codigo_ibge = ?, uf = ?, ponto_referencia = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, endereco.getClienteId());
            stmt.setString(2, endereco.getCep());
            stmt.setString(3, endereco.getLogradouro());
            stmt.setString(4, endereco.getNumero());
            stmt.setString(5, endereco.getComplemento());
            stmt.setString(6, endereco.getBairro());
            stmt.setString(7, endereco.getMunicipio());
            stmt.setString(8, endereco.getCodigoIbge());
            stmt.setString(9, endereco.getUf());
            stmt.setString(10, endereco.getPontoReferencia());
            stmt.setInt(11, endereco.getId());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Endereco buscarPorId(Integer id) {
        String sql = "SELECT * FROM endereco WHERE id = ?";
        Endereco endereco = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    endereco = mapearResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return endereco;
    }

    public List<Endereco> listarPorCliente(Integer clienteId) {
        List<Endereco> enderecos = new ArrayList<>();
        String sql = "SELECT * FROM endereco WHERE cliente_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, clienteId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    enderecos.add(mapearResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return enderecos;
    }

    public List<Endereco> listarTodos() {
        List<Endereco> enderecos = new ArrayList<>();
        String sql = "SELECT * FROM endereco";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                enderecos.add(mapearResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return enderecos;
    }

    public void deletar(Integer id) {
        String sql = "DELETE FROM endereco WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Endereco mapearResultSet(ResultSet rs) throws SQLException {
        Endereco endereco = new Endereco();
        endereco.setId(rs.getInt("id"));
        endereco.setClienteId(rs.getInt("cliente_id"));
        endereco.setCep(rs.getString("cep"));
        endereco.setLogradouro(rs.getString("logradouro"));
        endereco.setNumero(rs.getString("numero"));
        endereco.setComplemento(rs.getString("complemento"));
        endereco.setBairro(rs.getString("bairro"));
        endereco.setMunicipio(rs.getString("municipio"));
        endereco.setCodigoIbge(rs.getString("codigo_ibge"));
        endereco.setUf(rs.getString("uf"));
        endereco.setPontoReferencia(rs.getString("ponto_referencia"));
        return endereco;
    }
}
