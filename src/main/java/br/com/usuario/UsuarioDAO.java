package br.com.usuario;

import br.com.connection.ConnectionFactory;
import br.com.cliente.Cliente;
import br.com.seguranca.PasswordService;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO extends ConnectionFactory {

    private final PasswordService passwordService = new PasswordService();

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
        Usuario usuario = buscarPorEmail(email);
        if (usuario == null || usuario.getSenha() == null || !usuario.isAtivo()) {
            return null;
        }

        if (passwordService.matches(senha, usuario.getSenha())) {
            if (passwordService.needsRehash(usuario.getSenha())) {
                atualizarSenha(usuario.getId(), passwordService.hash(senha));
            }
            usuario.setSenha(null);
            return usuario;
        }

        return null;
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
        String sql = "SELECT u.*, c.razao_social, c.nome_fantasia, c.documento, c.inscricao_estadual, c.email AS cliente_email, c.telefone AS cliente_telefone, c.ativo AS cliente_ativo, c.criado_em AS cliente_criado_em FROM usuario u LEFT JOIN cliente c ON u.cliente_id = c.id WHERE u.email = ?";
        Usuario usuario = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    usuario = mapearUsuario(rs, true);
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
                    usuario = mapearUsuario(rs, false);
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
                    usuario = mapearUsuario(rs, false);
                    usuario.setClienteId(null);
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
                    usuario = mapearUsuario(rs, false);
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

    private Usuario mapearUsuario(ResultSet rs, boolean incluirSenha) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setId(rs.getInt("id"));
        usuario.setUsuario(rs.getString("usuario"));
        usuario.setEmail(rs.getString("email"));
        usuario.setAdmin(rs.getBoolean("is_administrador"));
        usuario.setClienteId(rs.getObject("cliente_id") != null ? rs.getInt("cliente_id") : null);
        usuario.setAtivo(rs.getBoolean("ativo"));

        if (incluirSenha) {
            usuario.setSenha(rs.getString("senha"));
        }

        if (usuario.getClienteId() != null) {
            Cliente cliente = new Cliente();
            cliente.setId(usuario.getClienteId());
            try {
                cliente.setRazaoSocial(rs.getString("razao_social"));
                cliente.setNomeFantasia(rs.getString("nome_fantasia"));
                cliente.setDocumento(rs.getString("documento"));
                cliente.setInscricaoEstadual(rs.getString("inscricao_estadual"));
                cliente.setEmail(rs.getString("cliente_email"));
                cliente.setTelefone(rs.getString("cliente_telefone"));
                Timestamp criadoEm = rs.getTimestamp("cliente_criado_em");
                if (criadoEm != null) {
                    cliente.setCriadoEm(criadoEm.toLocalDateTime());
                }
                cliente.setAtivo(rs.getBoolean("cliente_ativo"));
            } catch (SQLException ignored) {
                // Algumas consultas nao trazem a razao social.
            }
            usuario.setCliente(cliente);
        }

        return usuario;
    }
}
