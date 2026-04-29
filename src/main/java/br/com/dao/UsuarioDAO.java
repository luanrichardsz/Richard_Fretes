package br.com.dao;

import br.com.connection.ConnectionFactory;
import br.com.model.Usuario;
import br.com.model.Cliente;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO extends ConnectionFactory {

    public void salvar(Usuario usuario) {
        String sql = "INSERT INTO usuario (usuario, email, senha, is_administrador, cliente_id, ativo) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, usuario.getUsuario());
            stmt.setString(2, usuario.getEmail());
            stmt.setString(3, usuario.getSenha());
            stmt.setBoolean(4, usuario.isAdmin());
            stmt.setObject(5, usuario.getClienteId(), Types.INTEGER);
            stmt.setBoolean(6, usuario.isAtivo());

            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    usuario.setId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public Usuario autenticar(String email, String senha) {
        String sql = "SELECT u.*, c.razao_social FROM usuario u LEFT JOIN cliente c ON u.cliente_id = c.id WHERE u.email = ? AND u.senha = ? AND u.ativo = true";
        Usuario usuario = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, senha);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setUsuario(rs.getString("usuario"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setAdmin(rs.getBoolean("is_administrador"));
                    usuario.setClienteId(rs.getObject("cliente_id") != null ? rs.getInt("cliente_id") : null);
                    usuario.setAtivo(rs.getBoolean("ativo"));

                    if (usuario.getClienteId() != null) {
                        Cliente cliente = new Cliente();
                        cliente.setId(usuario.getClienteId());
                        cliente.setRazaoSocial(rs.getString("razao_social"));
                        usuario.setCliente(cliente);
                    }
                    return usuario;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return usuario;
    }

    public Boolean existeEmail(String email) {
        String sql = "SELECT COUNT(*) FROM usuario WHERE email = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

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

    public Usuario buscarPorEmail(String email) {
        String sql = "SELECT id, usuario, email, is_administrador, cliente_id, ativo FROM usuario WHERE email = ?";
        Usuario usuario = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setUsuario(rs.getString("usuario"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setAdmin(rs.getBoolean("is_administrador"));
                    usuario.setClienteId(rs.getObject("cliente_id") != null ? rs.getInt("cliente_id") : null);
                    usuario.setAtivo(rs.getBoolean("ativo"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return usuario;
    }

    public void atualizarSenha(Integer id, String novaSenhaHash) {
        String sql = "UPDATE usuario SET senha = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, novaSenhaHash);
            stmt.setInt(2, id);

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void atualizarPermissao(Integer id, boolean isAdmin) {
        String sql = "UPDATE usuario SET is_administrador = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setBoolean(1, isAdmin);
            stmt.setInt(2, id);

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void atualizarPerfil(Integer id, String usuario, String email) {
        String sql = "UPDATE usuario SET usuario = ?, email = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, usuario);
            stmt.setString(2, email);
            stmt.setInt(3, id);

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Usuario> listarTodos() {
        String sql = "SELECT id, usuario, email, is_administrador, cliente_id, ativo FROM usuario WHERE ativo = true ORDER BY usuario";
        List<Usuario> usuarios = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setUsuario(rs.getString("usuario"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setAdmin(rs.getBoolean("is_administrador"));
                    usuario.setClienteId(rs.getObject("cliente_id") != null ? rs.getInt("cliente_id") : null);
                    usuario.setAtivo(rs.getBoolean("ativo"));
                    usuarios.add(usuario);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return usuarios;
    }

    public List<Usuario> listarUsuariosSemCliente() {
        String sql = "SELECT id, usuario, email, is_administrador, cliente_id, ativo FROM usuario WHERE cliente_id IS NULL AND ativo = true AND is_administrador = false ORDER BY usuario";
        List<Usuario> usuarios = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setUsuario(rs.getString("usuario"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setAdmin(rs.getBoolean("is_administrador"));
                    usuario.setClienteId(null);
                    usuario.setAtivo(rs.getBoolean("ativo"));
                    usuarios.add(usuario);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return usuarios;
    }

    public List<Usuario> listarUsuariosNaoAdmin() {
        String sql = "SELECT id, usuario, email, is_administrador, cliente_id, ativo FROM usuario WHERE ativo = true AND is_administrador = false ORDER BY usuario";
        List<Usuario> usuarios = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setId(rs.getInt("id"));
                    usuario.setUsuario(rs.getString("usuario"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setAdmin(rs.getBoolean("is_administrador"));
                    usuario.setClienteId(rs.getObject("cliente_id") != null ? rs.getInt("cliente_id") : null);
                    usuario.setAtivo(rs.getBoolean("ativo"));
                    usuarios.add(usuario);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return usuarios;
    }

    public void atualizarClienteDoUsuario(Integer usuarioId, Integer clienteId) {
        String sql = "UPDATE usuario SET cliente_id = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, clienteId, Types.INTEGER);
            stmt.setInt(2, usuarioId);

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
