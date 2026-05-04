package br.com.auth.dto;

public class AuthResponse {
    private final boolean sucesso;
    private final String mensagem;
    private final UserResponse usuario;

    public AuthResponse(boolean sucesso, String mensagem, UserResponse usuario) {
        this.sucesso = sucesso;
        this.mensagem = mensagem;
        this.usuario = usuario;
    }

    public boolean isSucesso() {
        return sucesso;
    }

    public String getMensagem() {
        return mensagem;
    }

    public UserResponse getUsuario() {
        return usuario;
    }
}
