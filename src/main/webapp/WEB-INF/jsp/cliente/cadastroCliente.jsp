<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="br.com.model.Cliente" %>

<% 
  Cliente cliente = (Cliente) request.getAttribute("cliente");
  boolean isEdicao = cliente != null;
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title><%= isEdicao ? "Editar Cliente" : "Novo Cliente" %></title>

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
    <h2><%= isEdicao ? "Editar Cliente" : "Novo Cliente" %></h2>

    <form action="clientes" method="post">
      
      <% if (isEdicao) { %>
        <input type="hidden" name="id" value="<%= cliente.getId() %>" />
      <% } %>

      <div class="form-grid">

        <!-- Tipo Pessoa -->
        <div class="form-group">
          <label>Tipo Pessoa *</label>
          <select name="tipoPessoa" required>
            <option value="">Selecione</option>
            <option value="FISICA" <%= isEdicao && cliente.getTipoPessoa() != null && cliente.getTipoPessoa().name().equals("FISICA") ? "selected" : "" %>>Pessoa Física</option>
            <option value="JURIDICA" <%= isEdicao && cliente.getTipoPessoa() != null && cliente.getTipoPessoa().name().equals("JURIDICA") ? "selected" : "" %>>Pessoa Jurídica</option>
          </select>
        </div>

        <!-- Tipo Entrega -->
        <div class="form-group">
          <label>Tipo de Entrega *</label>
          <select name="tipoEntrega" required>
            <option value="">Selecione</option>
            <option value="REMETENTE" <%= isEdicao && cliente.getTipoEntrega() != null && cliente.getTipoEntrega().name().equals("REMETENTE") ? "selected" : "" %>>Remetente</option>
            <option value="DESTINATARIO" <%= isEdicao && cliente.getTipoEntrega() != null && cliente.getTipoEntrega().name().equals("DESTINATARIO") ? "selected" : "" %>>Destinatario</option>
            <option value="AMBOS" <%= isEdicao && cliente.getTipoEntrega() != null && cliente.getTipoEntrega().name().equals("AMBOS") ? "selected" : "" %>>Ambos</option>
          </select>
        </div>

        <!-- Razão Social -->
        <div class="form-group full">
          <label>Razão Social / Nome *</label>
          <input type="text" name="razaoSocial" value="<%= isEdicao ? cliente.getRazaoSocial() : "" %>" required />
        </div>

        <!-- Nome Fantasia -->
        <div class="form-group full">
          <label>Nome Fantasia</label>
          <input type="text" name="nomeFantasia" value="<%= isEdicao ? (cliente.getNomeFantasia() != null ? cliente.getNomeFantasia() : "") : "" %>" />
        </div>

        <!-- Documento -->
        <div class="form-group">
          <label>CPF / CNPJ *</label>
          <input type="text" name="documento" maxlength="14" value="<%= isEdicao ? cliente.getDocumento() : "" %>" required />
        </div>

        <!-- IE -->
        <div class="form-group">
          <label>Inscrição Estadual</label>
          <input type="text" name="inscricaoEstadual" maxlength="13" value="<%= isEdicao ? (cliente.getInscricaoEstadual() != null ? cliente.getInscricaoEstadual() : "") : "" %>" />
        </div>

        <!-- Email -->
        <div class="form-group">
          <label>Email *</label>
          <input type="email" name="email" value="<%= isEdicao ? cliente.getEmail() : "" %>" required />
        </div>

        <!-- Telefone -->
        <div class="form-group">
          <label>Telefone *</label>
          <input type="text" name="telefone" maxlength="11" value="<%= isEdicao ? cliente.getTelefone() : "" %>" required />
        </div>

        <!-- Status -->
        <div class="form-group">
          <label>Status</label>
          <select name="ativo">
            <option value="true" <%= isEdicao && cliente.isAtivo() ? "selected" : "" %>>Ativo</option>
            <option value="false" <%= isEdicao && !cliente.isAtivo() ? "selected" : "" %>>Inativo</option>
          </select>
        </div>

      </div>

      <!-- Botões -->
      <div style="margin-top:20px;">
        <button type="submit" class="btn-primary"><%= isEdicao ? "Atualizar Cliente" : "Salvar Cliente" %></button>
        <a href="clientes" class="btn-small">Cancelar</a>
      </div>

    </form>
  </section>

</div>

</body>
</html>