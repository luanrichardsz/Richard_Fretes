package br.com.auth;

import br.com.auth.dto.AuthRequest;
import br.com.auth.dto.AuthResponse;
import br.com.auth.dto.UserResponse;
import br.com.exception.CadastroException;
import br.com.exception.NegocioException;
import br.com.usuario.Usuario;
import br.com.usuario.UsuarioBO;
import br.com.usuario.UsuarioDAO;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

@WebServlet("/api/auth/*")
public class AuthApiServlet extends HttpServlet {

    private final ObjectMapper objectMapper = new ObjectMapper()
        .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final UsuarioBO usuarioBO = new UsuarioBO(usuarioDAO);

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        configurarRespostaJson(resp);
        try {
            String path = req.getPathInfo();
            if ("/register".equals(path)) {
                registrar(req, resp);
                return;
            }

            if ("/login".equals(path)) {
                login(req, resp);
                return;
            }

            escreverJson(resp, HttpServletResponse.SC_NOT_FOUND,
                new AuthResponse(false, "Endpoint de autenticacao nao encontrado.", null));
        } catch (Exception e) {
            escreverJson(resp, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                new AuthResponse(false, "Erro interno na API de autenticacao: " + e.getMessage(), null));
        }
    }

    private void registrar(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        AuthRequest authRequest;
        try {
            authRequest = lerBody(req);
        } catch (IOException e) {
            escreverJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                new AuthResponse(false, "JSON invalido para cadastro.", null));
            return;
        }

        Usuario novoUsuario = new Usuario();
        novoUsuario.setUsuario(authRequest.getUsuario());
        novoUsuario.setEmail(authRequest.getEmail());
        novoUsuario.setSenha(authRequest.getSenha());
        novoUsuario.setAdmin(false);
        novoUsuario.setAtivo(true);

        try {
            usuarioBO.cadastrar(novoUsuario);
            escreverJson(resp, HttpServletResponse.SC_CREATED,
                new AuthResponse(true, "Usuario cadastrado com sucesso.", new UserResponse(novoUsuario)));
        } catch (CadastroException e) {
            escreverJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                new AuthResponse(false, e.getMessage(), null));
        }
    }

    private void login(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        AuthRequest authRequest;
        try {
            authRequest = lerBody(req);
        } catch (IOException e) {
            escreverJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                new AuthResponse(false, "JSON invalido para login.", null));
            return;
        }

        try {
            Usuario usuario = usuarioBO.autenticar(authRequest.getEmail(), authRequest.getSenha());

            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }

            session = req.getSession(true);
            session.setAttribute("usuarioAutenticado", usuario);
            session.setMaxInactiveInterval(30 * 60);

            escreverJson(resp, HttpServletResponse.SC_OK,
                new AuthResponse(true, "Login realizado com sucesso.", new UserResponse(usuario)));
        } catch (NegocioException e) {
            escreverJson(resp, HttpServletResponse.SC_UNAUTHORIZED,
                new AuthResponse(false, e.getMessage(), null));
        }
    }

    private AuthRequest lerBody(HttpServletRequest req) throws IOException {
        return objectMapper.readValue(req.getInputStream(), AuthRequest.class);
    }

    private void configurarRespostaJson(HttpServletResponse resp) {
        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json");
    }

    private void escreverJson(HttpServletResponse resp, int status, AuthResponse response) throws IOException {
        resp.setStatus(status);
        objectMapper.writeValue(resp.getWriter(), response);
    }
}
