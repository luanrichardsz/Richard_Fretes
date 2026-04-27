package br.com.model;

import java.time.LocalDateTime;
import java.time.LocalDate;

public class Veiculo {

    public enum StatusVeiculo {
        DISPONIVEL, 
        EM_VIAGEM, 
        EM_MANUTENCAO, 
        INATIVO
    }

    private Integer id;
    private String placa;
    private String renavam;
    private String rntrc;
    private int anoFabricacao;
    private int anoModelo;
    private String tipo;
    private String tipoOutros;
    private int quantidadeEixos;
    private String combustivel;
    private int taraKg;
    private int capacidadeCargaKg;
    private int volumeM3;
    private StatusVeiculo status;
    private LocalDateTime adicionadoEm;
    private Integer motoristaId; 
    private boolean manutencaoPendente;
    private LocalDate seguroValidade;
    private Integer clienteId;
    private Cliente cliente;

    public Veiculo() {
        this.status = StatusVeiculo.DISPONIVEL;
        this.combustivel = "Diesel";
        this.volumeM3 = 0;
        this.adicionadoEm = LocalDateTime.now();
    }

    // Getters e Setters

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getPlaca() {
        return placa;
    }

    public void setPlaca(String placa) {
        this.placa = placa;
    }

    public String getRenavam() {
        return renavam;
    }

    public void setRenavam(String renavam) {
        this.renavam = renavam;
    }

    public String getRntrc() {
        return rntrc;
    }

    public void setRntrc(String rntrc) {
        this.rntrc = rntrc;
    }

    public int getAnoFabricacao() {
        return anoFabricacao;
    }

    public void setAnoFabricacao(int anoFabricacao) {
        this.anoFabricacao = anoFabricacao;
    }

    public int getAnoModelo() {
        return anoModelo;
    }

    public void setAnoModelo(int anoModelo) {
        this.anoModelo = anoModelo;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getTipoOutros() {
        return tipoOutros;
    }

    public void setTipoOutros(String tipoOutros) {
        this.tipoOutros = tipoOutros;
    }

    public int getQuantidadeEixos() {
        return quantidadeEixos;
    }

    public void setQuantidadeEixos(int quantidadeEixos) {
        this.quantidadeEixos = quantidadeEixos;
    }

    public String getCombustivel() {
        return combustivel;
    }

    public void setCombustivel(String combustivel) {
        this.combustivel = combustivel;
    }

    public int getTaraKg() {
        return taraKg;
    }

    public void setTaraKg(int taraKg) {
        this.taraKg = taraKg;
    }

    public int getCapacidadeCargaKg() {
        return capacidadeCargaKg;
    }

    public void setCapacidadeCargaKg(int capacidadeCargaKg) {
        this.capacidadeCargaKg = capacidadeCargaKg;
    }

    public int getVolumeM3() {
        return volumeM3;
    }

    public void setVolumeM3(int volumeM3) {
        this.volumeM3 = volumeM3;
    }

    public StatusVeiculo getStatus() {
        return status;
    }

    public void setStatus(StatusVeiculo status) {
        this.status = status;
    }

    public LocalDateTime getAdicionadoEm() {
        return adicionadoEm;
    }

    public void setAdicionadoEm(LocalDateTime adicionadoEm) {
        this.adicionadoEm = adicionadoEm;
    }

    public Integer getMotoristaId() {
        return motoristaId;
    }

    public void setMotoristaId(Integer motoristaId) {
        this.motoristaId = motoristaId;
    }

    public boolean isManutencaoPendente() {
        return manutencaoPendente;
    }

    public void setManutencaoPendente(boolean manutencaoPendente) {
        this.manutencaoPendente = manutencaoPendente;
    }

    public LocalDate getSeguroValidade() {
        return seguroValidade;
    }

    public void setSeguroValidade(LocalDate seguroValidade) {
        this.seguroValidade = seguroValidade;
    }

    public Integer getClienteId() {
        return clienteId;
    }

    public void setClienteId(Integer clienteId) {
        this.clienteId = clienteId;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    
}