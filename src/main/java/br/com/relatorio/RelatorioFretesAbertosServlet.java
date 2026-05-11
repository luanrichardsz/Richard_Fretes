package br.com.relatorio;

import br.com.cliente.ClienteDAO;
import br.com.connection.ConnectionFactory;
import br.com.usuario.Usuario;
import br.com.usuario.UsuarioSessionUtils;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;

@WebServlet("/relatorios/fretes-abertos")
public class RelatorioFretesAbertosServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final ReportConnectionFactory CONNECTION_FACTORY = new ReportConnectionFactory();
    private final ClienteDAO clienteDAO = new ClienteDAO();

    private static class ReportConnectionFactory extends ConnectionFactory {
        public Connection openConnection() throws SQLException {
            return getConnection();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuarioAutenticado") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Usuario usuarioLogado = UsuarioSessionUtils.obterUsuarioLogado(request);
        if (usuarioLogado == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (usuarioLogado.isAdmin() && !deveGerarRelatorio(request)) {
            request.setAttribute("clientes", clienteDAO.listarTodos());
            request.getRequestDispatcher("/WEB-INF/jsp/relatorio/filtroFretesAbertos.jsp").forward(request, response);
            return;
        }

        Integer clienteIdFiltro = resolverClienteIdFiltro(request, usuarioLogado);
        if (!usuarioLogado.isAdmin() && clienteIdFiltro == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Usuario sem cliente vinculado.");
            return;
        }

        Connection connection = null;
        OutputStream outputStream = null;

        try {
            connection = CONNECTION_FACTORY.openConnection();

            Map<String, Object> parametros = new HashMap<String, Object>();
            parametros.put("CLIENTE_ID", clienteIdFiltro);
            JasperPrint jasperPrint;

            try (InputStream jrxmlStream = getServletContext().getResourceAsStream(
                    "/reports/fretes_abertos.jrxml")) {
                if (jrxmlStream == null) {
                    throw new ServletException("Arquivo do relatorio nao encontrado em /reports/fretes_abertos.jrxml");
                }

                JasperReport jasperReport = JasperCompileManager.compileReport(jrxmlStream);
                jasperPrint = JasperFillManager.fillReport(
                        jasperReport,
                        parametros,
                        connection
                );
            }

            response.setContentType("application/pdf");
            response.setHeader(
                    "Content-Disposition",
                    "inline; filename=relatorio_fretes_abertos.pdf"
            );

            outputStream = response.getOutputStream();
            JasperExportManager.exportReportToPdfStream(jasperPrint, outputStream);

            outputStream.flush();

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Erro ao gerar relatorio de fretes abertos.", e);

        } finally {
            if (outputStream != null) {
                try {
                    outputStream.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }

            if (connection != null) {
                try {
                    connection.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private boolean deveGerarRelatorio(HttpServletRequest request) {
        return "true".equalsIgnoreCase(request.getParameter("gerar"))
                || request.getParameter("clienteId") != null;
    }

    private Integer resolverClienteIdFiltro(HttpServletRequest request, Usuario usuarioLogado) {
        if (!usuarioLogado.isAdmin()) {
            return usuarioLogado.getClienteId();
        }

        String clienteIdParam = request.getParameter("clienteId");
        if (clienteIdParam == null || clienteIdParam.trim().isEmpty()) {
            return null;
        }

        try {
            return Integer.valueOf(clienteIdParam);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
