package br.com.manutencao;

import java.time.LocalDate;

public class ResumoManutencaoVeiculo {

    private final boolean manutencaoEmAndamento;
    private final boolean manutencaoPendente;
    private final boolean manutencaoVencida;
    private final boolean manutencaoProxima;
    private final LocalDate proximaDataPrevista;
    private final String proximaDescricao;
    private final LocalDate ultimaDataRealizacao;
    private final String ultimaDescricao;

    public ResumoManutencaoVeiculo(
            boolean manutencaoEmAndamento,
            boolean manutencaoPendente,
            boolean manutencaoVencida,
            boolean manutencaoProxima,
            LocalDate proximaDataPrevista,
            String proximaDescricao,
            LocalDate ultimaDataRealizacao,
            String ultimaDescricao) {
        this.manutencaoEmAndamento = manutencaoEmAndamento;
        this.manutencaoPendente = manutencaoPendente;
        this.manutencaoVencida = manutencaoVencida;
        this.manutencaoProxima = manutencaoProxima;
        this.proximaDataPrevista = proximaDataPrevista;
        this.proximaDescricao = proximaDescricao;
        this.ultimaDataRealizacao = ultimaDataRealizacao;
        this.ultimaDescricao = ultimaDescricao;
    }

    public boolean isManutencaoEmAndamento() {
        return manutencaoEmAndamento;
    }

    public boolean isManutencaoPendente() {
        return manutencaoPendente;
    }

    public boolean isManutencaoVencida() {
        return manutencaoVencida;
    }

    public boolean isManutencaoProxima() {
        return manutencaoProxima;
    }

    public LocalDate getProximaDataPrevista() {
        return proximaDataPrevista;
    }

    public String getProximaDescricao() {
        return proximaDescricao;
    }

    public LocalDate getUltimaDataRealizacao() {
        return ultimaDataRealizacao;
    }

    public String getUltimaDescricao() {
        return ultimaDescricao;
    }
}
