<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="true" %>
<%@ page import="java.util.List" %>
<%@ page import="br.com.model.Motorista" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Motoristas</title>

<link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
<link rel="stylesheet" href="/RichardFretes/css/styleC.css" />
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
          <option>Todos os status</option>
          <option>ATIVO</option>
          <option>INATIVO</option>
          <option>SUSPENSO</option>
        </select>
      </div>

      <a href="motoristas?acao=novo">
        <button class="btn-primary">
          + Novo Motorista
        </button>
      </a>

    </div>
  </section>

  <!-- Table -->
  <section class="card">
    <table class="data-table">
      <thead>
        <tr>
          <th>Nome</th>
          <th>CPF</th>
          <th>CNH</th>
          <th>Categoria</th>
          <th>Telefone</th>
          <th>Status</th>
          <th>Ações</th>
        </tr>
      </thead>

      <tbody>
        <%
          List<Motorista> motoristas = (List<Motorista>) request.getAttribute("motoristas");

          if (motoristas != null && !motoristas.isEmpty()) {
              for (Motorista m : motoristas) {
        %>

        <tr>
          <td><%= m.getNomeCompleto() %></td>
          <td><%= m.getCpf() %></td>
          <td><%= m.getNumeroCnh() %></td>
          <td><%= m.getCategoriaCnh() %></td>
          <td><%= m.getTelefone() %></td>
          <td>
            <span class="badge <%= m.getStatus().toString().equals("ATIVO") ? "green" : m.getStatus().toString().equals("SUSPENSO") ? "red" : "gray" %>">
              <%= m.getStatus() %>
            </span>
          </td>
          <td>
            <a href="motoristas?acao=editar&id=<%= m.getId() %>">
              <button class="btn-small">Editar</button>
            </a>
            <a href="motoristas?acao=deletar&id=<%= m.getId() %>" onclick="return confirm('Tem certeza?')">
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
            Nenhum motorista cadastrado
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
