<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="true" %>
<%@ page import="java.util.List" %>
<%@ page import="br.com.model.Frete" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Fretes</title>

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
          <option>Todos os status</option>
          <option>EMITIDO</option>
          <option>EM_TRANSITO</option>
          <option>ENTREGUE</option>
          <option>CANCELADO</option>
        </select>
      </div>

      <a href="fretes?acao=novo">
        <button class="btn-primary">
          + Novo Frete
        </button>
      </a>

    </div>
  </section>

  <!-- Table -->
  <section class="card">
    <table class="data-table">
      <thead>
        <tr>
          <th>Número Frete</th>
          <th>Remetente</th>
          <th>Destinatário</th>
          <th>Status</th>
          <th>Valor Total</th>
          <th>Data Emissão</th>
          <th>Ações</th>
        </tr>
      </thead>

      <tbody>
        <%
          List<Frete> fretes = (List<Frete>) request.getAttribute("fretes");

          if (fretes != null && !fretes.isEmpty()) {
              for (Frete f : fretes) {
        %>

        <tr>
          <td><%= f.getNumeroFrete() %></td>
          <td><%= f.getRemetenteId() %></td>
          <td><%= f.getDestinatarioId() %></td>
          <td>
            <span class="badge <%= f.getStatus().toString().equals("ENTREGUE") ? "green" : "orange" %>">
              <%= f.getStatus() %>
            </span>
          </td>
          <td>R$ <%= String.format("%.2f", f.getValorTotal()) %></td>
          <td><%= f.getDataEmissao() %></td>
          <td>
            <a href="fretes?acao=editar&id=<%= f.getId() %>">
              <button class="btn-small">Editar</button>
            </a>
            <a href="fretes?acao=deletar&id=<%= f.getId() %>" onclick="return confirm('Tem certeza?')">
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
            Nenhum frete cadastrado
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
