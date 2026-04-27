package br.com.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Cliente {

    public enum TipoEntrega{
        REMETENTE,
        DESTINATARIO,
        AMBOS
    }

    private Integer id;
    private String razaoSocial;
    private String nomeFantasia;
    private String documento;
    private String inscricaoEstadual;
    private TipoEntrega tipoEntrega;
    private String email;
    private String senha;
    private String telefone;
    private boolean ativo;
    private LocalDateTime criadoEm;

    private List<Endereco> enderecos; // Relacionamento 1:N

    // Construtor para padronizar 
    public Cliente() {
        this.ativo = true;
        this.criadoEm = LocalDateTime.now();
        this.enderecos = new ArrayList<>();
    }

    // Getters e Setters

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getRazaoSocial() {
        return razaoSocial;
    }

    public void setRazaoSocial(String razaoSocial) {
        this.razaoSocial = razaoSocial;
    }

    public String getNomeFantasia() {
        return nomeFantasia;
    }

    public void setNomeFantasia(String nomeFantasia) {
        this.nomeFantasia = nomeFantasia;
    }

    public String getDocumento() {
        return documento;
    }

    public void setDocumento(String documento) {
        this.documento = documento;
    }

    public String getInscricaoEstadual() {
        return inscricaoEstadual;
    }

    public void setInscricaoEstadual(String inscricaoEstadual) {
        this.inscricaoEstadual = inscricaoEstadual;
    }

    public TipoEntrega getTipoEntrega() {
        return tipoEntrega;
    }

    public void setTipo(TipoEntrega tipoEntrega) {
        this.tipoEntrega = tipoEntrega;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
    public String getSenha() {
        return senha;
    }  

    public void setSenha(String senha) {
        this.senha = senha;
    }

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    public boolean isAtivo() {
        return ativo;
    }

    public void setAtivo(boolean ativo) {
        this.ativo = ativo;
    }

    public LocalDateTime getCriadoEm() {
        return criadoEm;
    }

    public void setCriadoEm(LocalDateTime criadoEm) {
        this.criadoEm = criadoEm;
    }

    public List<Endereco> getEnderecos() { 
        return enderecos; 
    }

    public void setEnderecos(List<Endereco> enderecos) { 
        this.enderecos = enderecos; 
    }

    // Adicionar os enderecos sem limpar 
    public void adicionarEndereco(Endereco endereco) {
        this.enderecos.add(endereco);
    }
}