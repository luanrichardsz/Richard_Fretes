<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="br.com.model.Endereco" %>
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
  Endereco endereco = (Endereco) request.getAttribute("endereco");
  boolean possuiDados = endereco != null;
  boolean isEdicao = endereco != null && endereco.getId() != null;
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

    <% if (request.getAttribute("erro") != null) { %>
      <div style="margin-bottom: 15px; padding: 12px; border-radius: 8px; background: #fdecea; color: #b42318; border: 1px solid #f5c2c7;">
        <%= request.getAttribute("erro") %>
      </div>
    <% } %>

    <form action="enderecos" method="post">
      
      <% if (isEdicao) { %>
        <input type="hidden" name="id" value="<%= endereco.getId() %>" />
      <% } %>

      <div class="form-grid">

        <% if (usuarioLogado.isAdmin()) { %>
          <div class="form-group">
            <label>Empresa Selecionada *</label>
            <select name="clienteId" required>
              <option value="">Selecione uma empresa</option>
              <%
                List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
                if (clientes != null) {
                  for (Cliente cliente : clientes) {
              %>
                <option value="<%= cliente.getId() %>" <%= possuiDados && endereco.getClienteId() != null && endereco.getClienteId().equals(cliente.getId()) ? "selected" : "" %>>
                  <%= cliente.getNomeFantasia() %>
                </option>
              <%
                  }
                }
              %>
            </select>
          </div>
        <% } %>

        <!-- CEP -->
        <div class="form-group">
          <label>CEP *</label>
          <input type="text" id="cep" name="cep" maxlength="9" inputmode="numeric" value="<%= possuiDados ? endereco.getCep() : "" %>" required />
        </div>

        <!-- Logradouro -->
        <div class="form-group full">
          <label>Logradouro *</label>
          <input type="text" name="logradouro" value="<%= possuiDados ? endereco.getLogradouro() : "" %>" required />
        </div>

        <!-- Número -->
        <div class="form-group">
          <label>Número</label>
          <input type="text" name="numero" value="<%= possuiDados ? endereco.getNumero() : "" %>" />
        </div>

        <!-- Complemento -->
        <div class="form-group">
          <label>Complemento</label>
          <input type="text" name="complemento" value="<%= possuiDados ? (endereco.getComplemento() != null ? endereco.getComplemento() : "") : "" %>" />
        </div>

        <!-- Bairro -->
        <div class="form-group">
          <label>Bairro *</label>
          <input type="text" name="bairro" value="<%= possuiDados ? endereco.getBairro() : "" %>" required />
        </div>

        <!-- Município -->
        <div class="form-group">
          <label>Município *</label>
          <input type="text" name="municipio" value="<%= possuiDados ? endereco.getMunicipio() : "" %>" required />
        </div>

        <!-- Código IBGE -->
        <div class="form-group">
          <label>Código IBGE</label>
          <input type="text" id="codigoIbge" name="codigoIbge" maxlength="7" inputmode="numeric" value="<%= possuiDados ? (endereco.getCodigoIbge() != null ? endereco.getCodigoIbge() : "") : "" %>" />
        </div>

        <!-- UF -->
        <div class="form-group">
          <label>UF *</label>
          <input type="text" id="uf" name="uf" value="<%= possuiDados ? endereco.getUf() : "" %>" maxlength="2" required />
        </div>

        <!-- Ponto de Referência -->
        <div class="form-group full">
          <label>Ponto de Referência</label>
          <textarea name="pontoReferencia" rows="3"><%= possuiDados ? (endereco.getPontoReferencia() != null ? endereco.getPontoReferencia() : "") : "" %></textarea>
        </div>

      </div>

      <div style="margin-top: 20px; display: flex; gap: 10px;">
        <button type="submit" class="btn-primary">Salvar</button>
        <a href="enderecos"><button type="button" class="btn-secondary">Cancelar</button></a>
      </div>

    </form>

  </section>

</div>

<script src="/RichardFretes/js/funcoesCadastroE.js"></script>

</body>
</html>
