package br.com.auth.dto;

import br.com.usuario.Usuario;

public class UserResponse {
    private final Integer id;
    private final String usuario;
    private final String email;
    private final boolean administrador;
    private final Integer clienteId;

    public UserResponse(Usuario usuario) {
        this.id = usuario.getId();
        this.usuario = usuario.getUsuario();
        this.email = usuario.getEmail();
        this.administrador = usuario.isAdmin();
        this.clienteId = usuario.getClienteId();
    }

    public Integer getId() {
        return id;
    }

    public String getUsuario() {
        return usuario;
    }

    public String getEmail() {
        return email;
    }

    public boolean isAdministrador() {
        return administrador;
    }

    public Integer getClienteId() {
        return clienteId;
    }
}
