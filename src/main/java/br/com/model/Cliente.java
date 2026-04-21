import java.time.LocalDateTime;

public class Cliente {

    public enum TipoEntrega{
        REMETENTE,
        DESTINATARIO,
        AMBOS
    }

    public enum TipoPessoa {
        FISICA,
        JURIDICA
    }

    private Integer id;
    private String razaoSocial;
    private String nomeFantasia;
    private String cnpj;
    private String inscricaoEstadual;
    private TipoPessoa tipoPessoa;
    private TipoEntrega tipoEntrega;
    private String email;
    private String telefone;
    private boolean ativo;
    private LocalDateTime criadoEm;

    private List<Endereco> enderecos; // Relacionamento 1:N

    // Construtor para padronizar 
    public Cliente() {
        this.ativo = true;
        this.criadoEm = LocalDateTime.now();
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

    public String getCnpj() {
        return cnpj;
    }

    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }

    public String getInscricaoEstadual() {
        return inscricaoEstadual;
    }

    public void setInscricaoEstadual(String inscricaoEstadual) {
        this.inscricaoEstadual = inscricaoEstadual;
    }

    public TipoPessoa getTipoPessoa() {
        return tipoPessoa;
    }

    public void setTipoPessoa(TipoPessoa tipoPessoa) {
        this.tipoPessoa = tipoPessoa;
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