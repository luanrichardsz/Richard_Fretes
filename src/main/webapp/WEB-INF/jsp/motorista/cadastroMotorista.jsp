<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="br.com.model.Motorista" %>
<%@ page import="br.com.model.Motorista.*" %>

<% 
  Motorista motorista = (Motorista) request.getAttribute("motorista");
  boolean isEdicao = motorista != null;
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title><%= isEdicao ? "Editar Motorista" : "Novo Motorista" %></title>

<link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
<link rel="stylesheet" href="/RichardFretes/css/styleC.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
.form-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
}
.form-group {
  display: flex;
  flex-direction: column;
}
.full {
  grid-column: span 2;
}
.section-title {
  grid-column: span 2;
  font-weight: bold;
  margin-top: 15px;
  border-bottom: 1px solid #ddd;
  padding-bottom: 5px;
}
</style>

</head>

<body>

<header class="top-header">
    <a href="menu" class="logo-btn" title="Home"><i class="fas fa-home"></i></a>
</header>


<div class="container">

  <section class="card">
    <h2><%= isEdicao ? "Editar Motorista" : "Novo Motorista" %></h2>

    <form action="motoristas" method="post">
      
      <% if (isEdicao) { %>
        <input type="hidden" name="id" value="<%= motorista.getId() %>" />
      <% } %>

      <div class="form-grid">

        <!-- DADOS PESSOAIS -->
        <div class="section-title">Dados Pessoais</div>

        <!-- Nome Completo -->
        <div class="form-group full">
          <label>Nome Completo *</label>
          <input type="text" name="nomeCompleto" value="<%= isEdicao ? motorista.getNomeCompleto() : "" %>" required />
        </div>

        <!-- CPF -->
        <div class="form-group">
          <label>CPF *</label>
          <input type="text" name="cpf" maxlength="11" value="<%= isEdicao ? motorista.getCpf() : "" %>" required />
        </div>

        <!-- RG -->
        <div class="form-group">
          <label>RG *</label>
          <input type="text" name="rg" maxlength="9" value="<%= isEdicao ? motorista.getRg() : "" %>" required />
        </div>

        <!-- Data Nascimento -->
        <div class="form-group">
          <label>Data Nascimento *</label>
          <input type="date" name="dataNascimento" value="<%= isEdicao ? motorista.getDataNascimento() : "" %>" required />
        </div>

        <!-- Telefone -->
        <div class="form-group">
          <label>Telefone *</label>
          <input type="tel" name="telefone" maxlength="11" value="<%= isEdicao ? motorista.getTelefone() : "" %>" required />
        </div>

        <!-- EMERGÊNCIA -->
        <div class="section-title">Contato de Emergência</div>

        <!-- Nome Emergência -->
        <div class="form-group full">
          <label>Nome da Pessoa</label>
          <input type="text" name="nomeEmergencia" value="<%= isEdicao ? (motorista.getNomeEmergencia() != null ? motorista.getNomeEmergencia() : "") : "" %>" />
        </div>

        <!-- Telefone Emergência -->
        <div class="form-group">
          <label>Telefone</label>
          <input type="tel" name="telefoneEmergencia" maxlength="11" value="<%= isEdicao ? (motorista.getTelefoneEmergencia() != null ? motorista.getTelefoneEmergencia() : "") : "" %>" />
        </div>

        <!-- Parentesco -->
        <div class="form-group">
          <label>Parentesco</label>
          <input type="text" name="parentescoEmergencia" value="<%= isEdicao ? (motorista.getParentescoEmergencia() != null ? motorista.getParentescoEmergencia() : "") : "" %>" />
        </div>

        <!-- CNH -->
        <div class="section-title">Carteira de Habilitação</div>

        <!-- Número CNH -->
        <div class="form-group">
          <label>Número CNH *</label>
          <input type="text" name="numeroCnh" value="<%= isEdicao ? motorista.getNumeroCnh() : "" %>" required />
        </div>

        <!-- Categoria CNH -->
        <div class="form-group">
          <label>Categoria *</label>
          <select name="categoriaCnh" required>
            <option value="">Selecione</option>
            <% for (CategoriaCnh cat : CategoriaCnh.values()) { %>
              <option value="<%= cat.name() %>" <%= isEdicao && motorista.getCategoriaCnh() != null && motorista.getCategoriaCnh().name().equals(cat.name()) ? "selected" : "" %>>
                <%= cat.name() %>
              </option>
            <% } %>
          </select>
        </div>

        <!-- Validade CNH -->
        <div class="form-group">
          <label>Validade CNH *</label>
          <input type="date" name="validadeCnh" value="<%= isEdicao ? motorista.getValidadeCnh() : "" %>" required />
        </div>

        <!-- Validade Toxicológico -->
        <div class="form-group">
          <label>Validade Toxicológico</label>
          <input type="date" name="validadeToxicologico" value="<%= isEdicao ? (motorista.getValidadeToxicologico() != null ? motorista.getValidadeToxicologico() : "") : "" %>" />
        </div>

        <!-- FINANCEIRO -->
        <div class="section-title">Informações Financeiras</div>

        <!-- Tipo Vínculo -->
        <div class="form-group">
          <label>Tipo Vínculo *</label>
          <select name="tipoVinculo" required>
            <option value="">Selecione</option>
            <% for (TipoVinculo tipo : TipoVinculo.values()) { %>
              <option value="<%= tipo.name() %>" <%= isEdicao && motorista.getTipoVinculo() != null && motorista.getTipoVinculo().name().equals(tipo.name()) ? "selected" : "" %>>
                <%= tipo.name() %>
              </option>
            <% } %>
          </select>
        </div>

        <!-- Tipo PIX -->
        <div class="form-group">
          <label>Tipo PIX *</label>
          <select name="tipoPix" required>
            <option value="">Selecione</option>
            <% for (TipoPix tipo : TipoPix.values()) { %>
              <option value="<%= tipo.name() %>" <%= isEdicao && motorista.getTipoPix() != null && motorista.getTipoPix().name().equals(tipo.name()) ? "selected" : "" %>>
                <%= tipo.name() %>
              </option>
            <% } %>
          </select>
        </div>

        <!-- Chave PIX -->
        <div class="form-group full">
          <label>Chave PIX *</label>
          <input type="text" name="chavePix" value="<%= isEdicao ? motorista.getChavePix() : "" %>" required />
        </div>

        <!-- Status -->
        <div class="form-group">
          <label>Status *</label>
          <select name="status" required>
            <option value="">Selecione</option>
            <% for (StatusMotorista status : StatusMotorista.values()) { %>
              <option value="<%= status.name() %>" <%= isEdicao && motorista.getStatus() != null && motorista.getStatus().name().equals(status.name()) ? "selected" : "" %>>
                <%= status.name() %>
              </option>
            <% } %>
          </select>
        </div>

      </div>

      <div style="margin-top: 20px; display: flex; gap: 10px;">
        <button type="submit" class="btn-primary">Salvar</button>
        <a href="motoristas"><button type="button" class="btn-secondary">Cancelar</button></a>
      </div>

    </form>

  </section>

</div>

<script>
    document.querySelector('form').addEventListener('submit', function(e) {
      const dataNascimento = document.getElementById('dataNascimento').value;
      if (!dataNascimento) return;

      const dataInput = new Date(dataNascimento);
      const hoje = new Date();
      
      // Calcula a idade
      let idade = hoje.getFullYear() - dataInput.getFullYear();
      const m = hoje.getMonth() - dataInput.getMonth();
      if (m < 0 || (m === 0 && hoje.getDate() < dataInput.getDate())) {
          idade--;
      }

      if (idade < 18) {
          alert("O motorista deve ter pelo menos 18 anos!");
          e.preventDefault(); // Impede o envio do formulário
      }
      
      if (idade > 100) {
          alert("Por favor, insira uma data de nascimento válida.");
          e.preventDefault();
      }
  });
</script>
</body>
</html>
