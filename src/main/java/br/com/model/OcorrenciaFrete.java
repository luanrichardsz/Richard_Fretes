import java.math.BigDecimal;
import java.time.LocalDateTime;

public class OcorrenciaFrete {

    public enum TipoOcorrencia {
        SAIDA_DO_PATIO, 
        EM_ROTA, 
        TENTATIVA_DE_ENTREGA, 
        ENTREGA_REALIZADA, 
        AVARIA, 
        EXTRAVIO, 
        OUTROS
    }

    private Integer id;
    private Integer freteId;
    private TipoOcorrencia tipo;
    private LocalDateTime dataHora;
    private String municipio;
    private String uf;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private String descricao;
    private String recebedorNome;
    private String recebedorDocumento;
    private String fotoEvidenciaUrl;

    public OcorrenciaFrete() {
        this.dataHora = LocalDateTime.now();
    }

    // Geters e Setters

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getFreteId() {
        return freteId;
    }

    public void setFreteId(Integer freteId) {
        this.freteId = freteId;
    }

    public TipoOcorrencia getTipo() {
        return tipo;
    }

    public void setTipo(TipoOcorrencia tipo) {
        this.tipo = tipo;
    }

    public LocalDateTime getDataHora() {
        return dataHora;
    }

    public void setDataHora(LocalDateTime dataHora) {
        this.dataHora = dataHora;
    }

    public String getMunicipio() {
        return municipio;
    }

    public void setMunicipio(String municipio) {
        this.municipio = municipio;
    }

    public String getUf() {
        return uf;
    }

    public void setUf(String uf) {
        this.uf = uf;
    }

    public BigDecimal getLatitude() {
        return latitude;
    }

    public void setLatitude(BigDecimal latitude) {
        this.latitude = latitude;
    }

    public BigDecimal getLongitude() {
        return longitude;
    }

    public void setLongitude(BigDecimal longitude) {
        this.longitude = longitude;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getRecebedorNome() {
        return recebedorNome;
    }

    public void setRecebedorNome(String recebedorNome) {
        this.recebedorNome = recebedorNome;
    }

    public String getRecebedorDocumento() {
        return recebedorDocumento;
    }

    public void setRecebedorDocumento(String recebedorDocumento) {
        this.recebedorDocumento = recebedorDocumento;
    }

    public String getFotoEvidenciaUrl() {
        return fotoEvidenciaUrl;
    }

    public void setFotoEvidenciaUrl(String fotoEvidenciaUrl) {
        this.fotoEvidenciaUrl = fotoEvidenciaUrl;
    }
}