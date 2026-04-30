<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="br.com.model.Motorista" %>
<%@ page import="br.com.model.Motorista.*" %>
<%@ page import="br.com.model.Usuario" %>
<%@ page import="br.com.model.Cliente" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioAutenticado");
    if (usuarioLogado == null) {
        response.sendRedirect("login");
        return;
    }
%>

<% 
  Motorista motorista = (Motorista) request.getAttribute("motorista");
  boolean possuiDados = motorista != null;
  boolean isEdicao = motorista != null && motorista.getId() != null;
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

    <% if (request.getAttribute("erro") != null) { %>
      <div style="margin-bottom: 15px; padding: 12px; border-radius: 8px; background: #fdecea; color: #b42318; border: 1px solid #f5c2c7;">
        <%= request.getAttribute("erro") %>
      </div>
    <% } %>

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
          <input type="text" name="nomeCompleto" value="<%= possuiDados ? motorista.getNomeCompleto() : "" %>" required />
        </div>

        <!-- CPF -->
        <div class="form-group">
          <label>CPF *</label>
          <input type="text" id="cpf" name="cpf" maxlength="14" inputmode="numeric" value="<%= possuiDados ? motorista.getCpf() : "" %>" required />
        </div>

        <!-- RG -->
        <div class="form-group">
          <label>RG *</label>
          <input type="text" id="rg" name="rg" maxlength="12" inputmode="numeric" value="<%= possuiDados ? motorista.getRg() : "" %>" required />
        </div>

        <!-- Data Nascimento -->
        <div class="form-group">
          <label>Data Nascimento *</label>
          <input type="date" id="dataNascimento" name="dataNascimento" max="<%= java.time.LocalDate.now() %>" value="<%= possuiDados ? motorista.getDataNascimento() : "" %>" required />
        </div>

        <!-- Telefone -->
        <div class="form-group">
          <label>Telefone *</label>
          <input type="tel" id="telefone" name="telefone" maxlength="15" inputmode="numeric" value="<%= possuiDados ? motorista.getTelefone() : "" %>" required />
        </div>

        <% if (usuarioLogado != null && usuarioLogado.isAdmin()) { %>
          <!-- Empresa -->
          <div class="form-group">
            <label>Empresa Selecionada *</label>
            <select name="clienteId" required>
              <option value="">Selecione uma empresa</option>
              <% 
                List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
                if (clientes != null) {
                  for (Cliente cliente : clientes) {
              %>
                <option value="<%= cliente.getId() %>" <%= possuiDados && motorista.getClienteId() != null && motorista.getClienteId().equals(cliente.getId()) ? "selected" : "" %>>
                  <%= cliente.getNomeFantasia() %>
                </option>
              <% 
                  }
                }
              %>
            </select>
          </div>
        <% } %>

        <!-- EMERGÊNCIA -->
        <div class="section-title">Contato de Emergência</div>

        <!-- Nome Emergência -->
        <div class="form-group full">
          <label>Nome da Pessoa</label>
          <input type="text" name="nomeEmergencia" value="<%= possuiDados ? (motorista.getNomeEmergencia() != null ? motorista.getNomeEmergencia() : "") : "" %>" />
        </div>

        <!-- Telefone Emergência -->
        <div class="form-group">
          <label>Telefone</label>
          <input type="tel" id="telefoneEmergencia" name="telefoneEmergencia" maxlength="15" inputmode="numeric" value="<%= possuiDados ? (motorista.getTelefoneEmergencia() != null ? motorista.getTelefoneEmergencia() : "") : "" %>" />
        </div>

        <!-- Parentesco -->
        <div class="form-group">
          <label>Parentesco</label>
          <input type="text" name="parentescoEmergencia" value="<%= possuiDados ? (motorista.getParentescoEmergencia() != null ? motorista.getParentescoEmergencia() : "") : "" %>" />
        </div>

        <!-- CNH -->
        <div class="section-title">Carteira de Habilitação</div>

        <!-- Número CNH -->
        <div class="form-group">
          <label>Número CNH *</label>
          <input type="text" id="numeroCnh" name="numeroCnh" maxlength="11" inputmode="numeric" value="<%= possuiDados ? motorista.getNumeroCnh() : "" %>" required />
        </div>

        <!-- Categoria CNH -->
        <div class="form-group">
          <label>Categoria *</label>
          <select name="categoriaCnh" required>
            <option value="">Selecione</option>
            <% for (CategoriaCnh cat : CategoriaCnh.values()) { %>
              <option value="<%= cat.name() %>" <%= possuiDados && motorista.getCategoriaCnh() != null && motorista.getCategoriaCnh().name().equals(cat.name()) ? "selected" : "" %>>
                <%= cat.name() %>
              </option>
            <% } %>
          </select>
        </div>

        <!-- Validade CNH -->
        <div class="form-group">
          <label>Validade CNH *</label>
          <input type="date" name="validadeCnh" value="<%= possuiDados ? motorista.getValidadeCnh() : "" %>" required />
        </div>

        <!-- Validade Toxicológico -->
        <div class="form-group">
          <label>Validade Toxicológico</label>
          <input type="date" name="validadeToxicologico" value="<%= possuiDados ? (motorista.getValidadeToxicologico() != null ? motorista.getValidadeToxicologico() : "") : "" %>" />
        </div>

        <!-- FINANCEIRO -->
        <div class="section-title">Informações Financeiras</div>

        <!-- Tipo Vínculo -->
        <div class="form-group">
          <label>Tipo Vínculo *</label>
          <select name="tipoVinculo" required>
            <option value="">Selecione</option>
            <% for (TipoVinculo tipo : TipoVinculo.values()) { %>
              <option value="<%= tipo.name() %>" <%= possuiDados && motorista.getTipoVinculo() != null && motorista.getTipoVinculo().name().equals(tipo.name()) ? "selected" : "" %>>
                <%= tipo.name() %>
              </option>
            <% } %>
          </select>
        </div>

        <!-- Tipo PIX -->
        <div class="form-group">
          <label>Tipo PIX *</label>
          <select id="tipoPix" name="tipoPix" required>
            <option value="">Selecione</option>
            <% for (TipoPix tipo : TipoPix.values()) { %>
              <option value="<%= tipo.name() %>" <%= possuiDados && motorista.getTipoPix() != null && motorista.getTipoPix().name().equals(tipo.name()) ? "selected" : "" %>>
                <%= tipo.name() %>
              </option>
            <% } %>
          </select>
        </div>

        <!-- Chave PIX -->
        <div class="form-group full">
          <label>Chave PIX *</label>
          <input type="text" id="chavePix" name="chavePix" value="<%= possuiDados ? motorista.getChavePix() : "" %>" required />
        </div>

        <!-- Status -->
        <div class="form-group">
          <label>Status *</label>
          <select name="status" required>
            <option value="">Selecione</option>
            <% for (StatusMotorista status : StatusMotorista.values()) { %>
              <option value="<%= status.name() %>" <%= possuiDados && motorista.getStatus() != null && motorista.getStatus().name().equals(status.name()) ? "selected" : "" %>>
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

<script src="/RichardFretes/js/funcoesCadastroM.js"></script>
</body>
</html>
