<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="br.com.model.Endereco" %>

<% 
  Endereco endereco = (Endereco) request.getAttribute("endereco");
  boolean isEdicao = endereco != null;
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title><%= isEdicao ? "Editar Endereço" : "Novo Endereço" %></title>

<link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
<link rel="stylesheet" href="/RichardFretes/css/styleC.css" />
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
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
</style>

</head>

<body>

<header class="top-header">
    <a href="menu" class="logo-btn" title="Home"><i class="fas fa-home"></i></a>
</header>


<div class="container">

  <section class="card">
    <h2><%= isEdicao ? "Editar Endereço" : "Novo Endereço" %></h2>

    <form action="enderecos" method="post">
      
      <% if (isEdicao) { %>
        <input type="hidden" name="id" value="<%= endereco.getId() %>" />
      <% } %>

      <div class="form-grid">

        <!-- Cliente ID -->
        <div class="form-group">
          <label>Cliente ID *</label>
          <input type="number" name="clienteId" value="<%= isEdicao ? endereco.getClienteId() : "" %>" required />
        </div>

        <!-- CEP -->
        <div class="form-group">
          <label>CEP *</label>
          <input type="text" name="cep" value="<%= isEdicao ? endereco.getCep() : "" %>" required />
        </div>

        <!-- Logradouro -->
        <div class="form-group full">
          <label>Logradouro *</label>
          <input type="text" name="logradouro" value="<%= isEdicao ? endereco.getLogradouro() : "" %>" required />
        </div>

        <!-- Número -->
        <div class="form-group">
          <label>Número</label>
          <input type="text" name="numero" value="<%= isEdicao ? endereco.getNumero() : "" %>" />
        </div>

        <!-- Complemento -->
        <div class="form-group">
          <label>Complemento</label>
          <input type="text" name="complemento" value="<%= isEdicao ? (endereco.getComplemento() != null ? endereco.getComplemento() : "") : "" %>" />
        </div>

        <!-- Bairro -->
        <div class="form-group">
          <label>Bairro *</label>
          <input type="text" name="bairro" value="<%= isEdicao ? endereco.getBairro() : "" %>" required />
        </div>

        <!-- Município -->
        <div class="form-group">
          <label>Município *</label>
          <input type="text" name="municipio" value="<%= isEdicao ? endereco.getMunicipio() : "" %>" required />
        </div>

        <!-- Código IBGE -->
        <div class="form-group">
          <label>Código IBGE</label>
          <input type="text" name="codigoIbge" value="<%= isEdicao ? (endereco.getCodigoIbge() != null ? endereco.getCodigoIbge() : "") : "" %>" />
        </div>

        <!-- UF -->
        <div class="form-group">
          <label>UF *</label>
          <input type="text" name="uf" value="<%= isEdicao ? endereco.getUf() : "" %>" maxlength="2" required />
        </div>

        <!-- Ponto de Referência -->
        <div class="form-group full">
          <label>Ponto de Referência</label>
          <textarea name="pontoReferencia" rows="3"><%= isEdicao ? (endereco.getPontoReferencia() != null ? endereco.getPontoReferencia() : "") : "" %></textarea>
        </div>

      </div>

      <div style="margin-top: 20px; display: flex; gap: 10px;">
        <button type="submit" class="btn-primary">Salvar</button>
        <a href="enderecos"><button type="button" class="btn-secondary">Cancelar</button></a>
      </div>

    </form>

  </section>

</div>

</body>
</html>
