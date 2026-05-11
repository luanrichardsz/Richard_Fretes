package br.com.manutencao;

import br.com.veiculo.Veiculo;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class ManutencaoVeiculo {

    public enum TipoManutencao {
        PREVENTIVA, CORRETIVA
    }

    public enum StatusManutencao {
        AGENDADA, EM_ANDAMENTO, CONCLUIDA, CANCELADA
    }

    private Integer id;
    private Integer veiculoId;
    private TipoManutencao tipo;
    private StatusManutencao status;
    private String descricao;
    private LocalDate dataPrevista;
    private LocalDate dataRealizacao;
    private BigDecimal custo;
    private String fornecedorOficina;
    private String observacao;
    private LocalDateTime adicionadoEm;
    private Veiculo veiculo;

    public ManutencaoVeiculo() {
        this.status = StatusManutencao.AGENDADA;
        this.custo = BigDecimal.ZERO;
        this.adicionadoEm = LocalDateTime.now();
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getVeiculoId() {
        return veiculoId;
    }

    public void setVeiculoId(Integer veiculoId) {
        this.veiculoId = veiculoId;
    }

    public TipoManutencao getTipo() {
        return tipo;
    }

    public void setTipo(TipoManutencao tipo) {
        this.tipo = tipo;
    }

    public StatusManutencao getStatus() {
        return status;
    }

    public void setStatus(StatusManutencao status) {
        this.status = status;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public LocalDate getDataPrevista() {
        return dataPrevista;
    }

    public void setDataPrevista(LocalDate dataPrevista) {
        this.dataPrevista = dataPrevista;
    }

    public LocalDate getDataRealizacao() {
        return dataRealizacao;
    }

    public void setDataRealizacao(LocalDate dataRealizacao) {
        this.dataRealizacao = dataRealizacao;
    }

    public BigDecimal getCusto() {
        return custo;
    }

    public void setCusto(BigDecimal custo) {
        this.custo = custo;
    }

    public String getFornecedorOficina() {
        return fornecedorOficina;
    }

    public void setFornecedorOficina(String fornecedorOficina) {
        this.fornecedorOficina = fornecedorOficina;
    }

    public String getObservacao() {
        return observacao;
    }

    public void setObservacao(String observacao) {
        this.observacao = observacao;
    }

    public LocalDateTime getAdicionadoEm() {
        return adicionadoEm;
    }

    public void setAdicionadoEm(LocalDateTime adicionadoEm) {
        this.adicionadoEm = adicionadoEm;
    }

    public Veiculo getVeiculo() {
        return veiculo;
    }

    public void setVeiculo(Veiculo veiculo) {
        this.veiculo = veiculo;
    }
}
