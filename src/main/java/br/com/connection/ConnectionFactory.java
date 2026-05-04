package br.com.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Logger;
import java.util.logging.Level;

public abstract class ConnectionFactory {

    private static final Logger logger = Logger.getLogger(ConnectionFactory.class.getName());
    private static final String DB_URL_ENV = "RICHARD_FRETES_DB_URL";
    private static final String DB_USER_ENV = "RICHARD_FRETES_DB_USER";
    private static final String DB_PASSWORD_ENV = "RICHARD_FRETES_DB_PASSWORD";

    protected Connection getConnection() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(
                getRequiredConfig(DB_URL_ENV),
                getRequiredConfig(DB_USER_ENV),
                getRequiredConfig(DB_PASSWORD_ENV)
            );
            logger.info("Conexao com o banco de dados estabelecida com sucesso!");
            return conn;
        } catch (ClassNotFoundException e) {
            logger.log(Level.SEVERE, "Driver JDBC nao encontrado!", e);
            throw new SQLException("Driver JDBC nao encontrado", e);
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Falha ao conectar com o banco de dados: " + e.getMessage(), e);
            throw e;
        }
    }

    private String getRequiredConfig(String envName) throws SQLException {
        String valor = System.getenv(envName);
        if (valor == null || valor.trim().isEmpty()) {
            throw new SQLException("Variavel de ambiente obrigatoria nao configurada: " + envName);
        }
        return valor.trim();
    }

    protected void closeConnection(Connection conn) {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
                logger.info("Conexao com o banco de dados fechada com sucesso!");
            }
        } catch (SQLException e) {
            logger.log(Level.WARNING, "Erro ao fechar Conexao: " + e.getMessage(), e);
        }
    }

    // Metodo de teste para verificar a Conexao
    public static void main(String[] args) {
        ConnectionFactory factory = new ConnectionFactory() {}; // Instancia anonima para teste
        try {
            Connection conn = factory.getConnection();
            factory.closeConnection(conn);
            System.out.println("Teste de Conexao: SUCESSO");
        } catch (SQLException e) {
            System.out.println("Teste de Conexao: FALHA - " + e.getMessage());
        }
    }
}
