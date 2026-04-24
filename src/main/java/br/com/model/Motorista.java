package br.com.model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class Motorista {

    // Organiza��o
    public enum CategoriaCnh {
        A, B, C, D, E, AB, AC, AD, AE
    }

    public enum TipoVinculo {
        FUNCIONARIO, AGREGADO, TERCEIRO
    }

    public enum TipoPix {
        CPF, CNPJ, EMAIL, CELULAR, CHAVE_ALEATORIA
    }

    public enum StatusMotorista {
        ATIVO, INATIVO, SUSPENSO
    }

    private Integer id;
    private String nomeCompleto;
    private String rg;
    private String cpf;
    private LocalDate dataNascimento;
    private String telefone;

    // Emergencia
    private String nomeEmergencia;
    private String telefoneEmergencia;
    private String parentescoEmergencia;

    // CNH
    private String numeroCnh;
    private CategoriaCnh categoriaCnh;
    private LocalDate validadeCnh;
    private LocalDate validadeToxicologico;

    // Financeiro
    private TipoVinculo tipoVinculo;
    private String chavePix;
    private TipoPix tipoPix;
    private StatusMotorista status;
    private LocalDateTime adicionadoEm;

    public Motorista() {
        this.status = StatusMotorista.ATIVO;
        this.adicionadoEm = LocalDateTime.now();
    }

    // Getters e Setters

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNomeCompleto() {
        return nomeCompleto;
    }

    public void setNomeCompleto(String nomeCompleto) {
        this.nomeCompleto = nomeCompleto;
    }

    public String getRg() {
        return rg;
    }

    public void setRg(String rg) {
        this.rg = rg;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public LocalDate getDataNascimento() {
        return dataNascimento;
    }

    public void setDataNascimento(LocalDate dataNascimento) {
        this.dataNascimento = dataNascimento;
    }

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    public String getNomeEmergencia() {
        return nomeEmergencia;
    }

    public void setNomeEmergencia(String nomeEmergencia) {
        this.nomeEmergencia = nomeEmergencia;
    }

    public String getTelefoneEmergencia() {
        return telefoneEmergencia;
    }

    public void setTelefoneEmergencia(String telefoneEmergencia) {
        this.telefoneEmergencia = telefoneEmergencia;
    }

    public String getParentescoEmergencia() {
        return parentescoEmergencia;
    }

    public void setParentescoEmergencia(String parentescoEmergencia) {
        this.parentescoEmergencia = parentescoEmergencia;
    }

    public String getNumeroCnh() {
        return numeroCnh;
    }

    public void setNumeroCnh(String numeroCnh) {
        this.numeroCnh = numeroCnh;
    }

    public CategoriaCnh getCategoriaCnh() {
        return categoriaCnh;
    }

    public void setCategoriaCnh(CategoriaCnh categoriaCnh) {
        this.categoriaCnh = categoriaCnh;
    }

    public LocalDate getValidadeCnh() {
        return validadeCnh;
    }

    public void setValidadeCnh(LocalDate validadeCnh) {
        this.validadeCnh = validadeCnh;
    }

    public LocalDate getValidadeToxicologico() {
        return validadeToxicologico;
    }

    public void setValidadeToxicologico(LocalDate validadeToxicologico) {
        this.validadeToxicologico = validadeToxicologico;
    }

    public TipoVinculo getTipoVinculo() {
        return tipoVinculo;
    }

    public void setTipoVinculo(TipoVinculo tipoVinculo) {
        this.tipoVinculo = tipoVinculo;
    }

    public String getChavePix() {
        return chavePix;
    }

    public void setChavePix(String chavePix) {
        this.chavePix = chavePix;
    }

    public TipoPix getTipoPix() {
        return tipoPix;
    }

    public void setTipoPix(TipoPix tipoPix) {
        this.tipoPix = tipoPix;
    }

    public StatusMotorista getStatus() {
        return status;
    }

    public void setStatus(StatusMotorista status) {
        this.status = status;
    }

    public LocalDateTime getAdicionadoEm() {
        return adicionadoEm;
    }

    public void setAdicionadoEm(LocalDateTime adicionadoEm) {
        this.adicionadoEm = adicionadoEm;
    }
}