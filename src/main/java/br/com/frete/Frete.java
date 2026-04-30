package br.com.frete;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class Frete {

    public enum StatusFrete {
        EMITIDO, SAIDA_CONFIRMADA, EM_TRANSITO, ENTREGUE, NAO_ENTREGUE, CANCELADO
    }

    private Integer id;
    private String numeroFrete; // Gerado automaticamente no formato: "FRT-2026-0001"
    private Integer remetenteId;
    private Integer destinatarioId;
    private Integer enderecoOrigemId;
    private Integer enderecoDestinoId;
    private Integer motoristaId;
    private Integer veiculoId;
    private String chaveNfe;
    private String origemIbge;
    private String destinoIbge;
    private String naturezaCarga;
    private BigDecimal pesoBruto;
    private Integer volumes;
    private BigDecimal valorFreteBruto;
    private BigDecimal valorPedagio;
    private BigDecimal aliquotaIcms;
    private BigDecimal valorIcms;
    private BigDecimal valorTotal;
    private StatusFrete status;
    private LocalDateTime dataEmissao;
    private LocalDate previsaoEntrega;
    private String motivoFalha;
    private LocalDateTime dataSaida;
    private LocalDateTime dataEntrega;
    private BigDecimal distanciaKm;

    public Frete() {
        this.status = StatusFrete.EMITIDO;
        this.dataEmissao = LocalDateTime.now();
        this.valorFreteBruto = BigDecimal.ZERO;
        this.valorPedagio = BigDecimal.ZERO;
        this.valorTotal = BigDecimal.ZERO;
        this.distanciaKm = BigDecimal.ZERO;
    }

    // Getters e Setters

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getNumeroFrete() {
        return numeroFrete;
    }

    public void setNumeroFrete(String numeroFrete) {
        this.numeroFrete = numeroFrete;
    }

    public Integer getRemetenteId() {
        return remetenteId;
    }

    public void setRemetenteId(Integer remetenteId) {
        this.remetenteId = remetenteId;
    }

    public Integer getDestinatarioId() {
        return destinatarioId;
    }

    public void setDestinatarioId(Integer destinatarioId) {
        this.destinatarioId = destinatarioId;
    }

    public Integer getEnderecoOrigemId() {
        return enderecoOrigemId;
    }

    public void setEnderecoOrigemId(Integer enderecoOrigemId) {
        this.enderecoOrigemId = enderecoOrigemId;
    }

    public Integer getEnderecoDestinoId() {
        return enderecoDestinoId;
    }

    public void setEnderecoDestinoId(Integer enderecoDestinoId) {
        this.enderecoDestinoId = enderecoDestinoId;
    }

    public Integer getMotoristaId() {
        return motoristaId;
    }

    public void setMotoristaId(Integer motoristaId) {
        this.motoristaId = motoristaId;
    }

    public Integer getVeiculoId() {
        return veiculoId;
    }

    public void setVeiculoId(Integer veiculoId) {
        this.veiculoId = veiculoId;
    }

    public String getChaveNfe() {
        return chaveNfe;
    }

    public void setChaveNfe(String chaveNfe) {
        this.chaveNfe = chaveNfe;
    }

    public String getOrigemIbge() {
        return origemIbge;
    }

    public void setOrigemIbge(String origemIbge) {
        this.origemIbge = origemIbge;
    }

    public String getDestinoIbge() {
        return destinoIbge;
    }

    public void setDestinoIbge(String destinoIbge) {
        this.destinoIbge = destinoIbge;
    }

    public String getNaturezaCarga() {
        return naturezaCarga;
    }

    public void setNaturezaCarga(String naturezaCarga) {
        this.naturezaCarga = naturezaCarga;
    }

    public BigDecimal getPesoBruto() {
        return pesoBruto;
    }

    public void setPesoBruto(BigDecimal pesoBruto) {
        this.pesoBruto = pesoBruto;
    }

    public Integer getVolumes() {
        return volumes;
    }

    public void setVolumes(Integer volumes) {
        this.volumes = volumes;
    }

    public BigDecimal getValorFreteBruto() {
        return valorFreteBruto;
    }

    public void setValorFreteBruto(BigDecimal valorFreteBruto) {
        this.valorFreteBruto = valorFreteBruto;
    }

    public BigDecimal getValorPedagio() {
        return valorPedagio;
    }

    public void setValorPedagio(BigDecimal valorPedagio) {
        this.valorPedagio = valorPedagio;
    }

    public BigDecimal getAliquotaIcms() {
        return aliquotaIcms;
    }

    public void setAliquotaIcms(BigDecimal aliquotaIcms) {
        this.aliquotaIcms = aliquotaIcms;
    }

    public BigDecimal getValorIcms() {
        return valorIcms;
    }

    public void setValorIcms(BigDecimal valorIcms) {
        this.valorIcms = valorIcms;
    }

    public BigDecimal getValorTotal() {
        return valorTotal;
    }

    public void setValorTotal(BigDecimal valorTotal) {
        this.valorTotal = valorTotal;
    }

    public StatusFrete getStatus() {
        return status;
    }

    public void setStatus(StatusFrete status) {
        this.status = status;
    }

    public LocalDateTime getDataEmissao() {
        return dataEmissao;
    }

    public void setDataEmissao(LocalDateTime dataEmissao) {
        this.dataEmissao = dataEmissao;
    }

    public LocalDate getPrevisaoEntrega() {
        return previsaoEntrega;
    }

    public void setPrevisaoEntrega(LocalDate previsaoEntrega) {
        this.previsaoEntrega = previsaoEntrega;
    }

    public String getMotivoFalha() {
        return motivoFalha;
    }

    public void setMotivoFalha(String motivoFalha) {
        this.motivoFalha = motivoFalha;
    }
    
    public LocalDateTime getDataSaida() {
        return dataSaida;
    }
    
    public void setDataSaida(LocalDateTime dataSaida) {
        this.dataSaida = dataSaida;
    }
    
    public LocalDateTime getDataEntrega() {
        return dataEntrega;
    }
    
    public void setDataEntrega(LocalDateTime dataEntrega) {
        this.dataEntrega = dataEntrega;
    }
    
    public BigDecimal getDistanciaKm() {
        return distanciaKm;
    }
    
    public void setDistanciaKm(BigDecimal distanciaKm) {
        this.distanciaKm = distanciaKm;
    }
}