package br.com.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Logger;
import java.util.logging.Level;

public abstract class ConnectionFactory {

    private static final Logger logger = Logger.getLogger(ConnectionFactory.class.getName());

    protected static final String URL = "jdbc:postgresql://localhost:5432/richard_fretes";
    protected static final String USER = "root";
    protected static final String PASSWORD = "1234";

    protected Connection getConnection() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
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
