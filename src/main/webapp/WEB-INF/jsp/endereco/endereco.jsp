<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="true" %>
<%@ page import="java.util.List" %>
<%@ page import="br.com.endereco.Endereco" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Endereços</title>

<link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
<link rel="stylesheet" href="/RichardFretes/css/styleC.css" />
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

</head>

<body>

<header class="top-header">
    <a href="menu" class="logo-btn" title="Home"><i class="fas fa-home"></i></a>
</header>


<div class="container">

  <!-- Toolbar -->
  <section class="card toolbar">
    <div class="toolbar-row">
      
      <div class="filters">
        <input type="text" placeholder="Buscar" />

        <select>
          <option>Todos municípios</option>
        </select>
      </div>

      <a href="enderecos?acao=novo">
        <button class="btn-primary">
          + Novo Endereço
        </button>
      </a>

    </div>
  </section>

  <!-- Table -->
  <section class="card">
    <table class="data-table">
      <thead>
        <tr>
          <th>Cliente ID</th>
          <th>Logradouro</th>
          <th>Número</th>
          <th>Bairro</th>
          <th>Município</th>
          <th>UF</th>
          <th>Ações</th>
        </tr>
      </thead>

      <tbody>
        <%
          List<Endereco> enderecos = (List<Endereco>) request.getAttribute("enderecos");

          if (enderecos != null && !enderecos.isEmpty()) {
              for (Endereco e : enderecos) {
        %>

        <tr>
          <td><%= e.getClienteId() %></td>
          <td><%= e.getLogradouro() %></td>
          <td><%= e.getNumero() %></td>
          <td><%= e.getBairro() %></td>
          <td><%= e.getMunicipio() %></td>
          <td><%= e.getUf() %></td>
          <td>
            <a href="enderecos?acao=editar&id=<%= e.getId() %>">
              <button class="btn-small">Editar</button>
            </a>
            <a href="enderecos?acao=deletar&id=<%= e.getId() %>" onclick="return confirm('Tem certeza?')">
              <button class="btn-small btn-danger">Deletar</button>
            </a>
          </td>
        </tr>

        <%
              }
          } else {
        %>

        <tr>
          <td colspan="7" style="text-align: center; padding: 20px;">
            Nenhum endereço cadastrado
          </td>
        </tr>

        <%
          }
        %>
      </tbody>
    </table>
  </section>

</div>

</body>
</html>
