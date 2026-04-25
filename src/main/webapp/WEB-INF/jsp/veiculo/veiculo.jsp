<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="true" %>
<%@ page import="java.util.List" %>
<%@ page import="br.com.model.Veiculo" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Veículos</title>

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
        <input type="text" placeholder="Buscar por placa" />

        <select>
          <option>Todos os status</option>
          <option>DISPONIVEL</option>
          <option>EM_VIAGEM</option>
          <option>EM_MANUTENCAO</option>
          <option>INATIVO</option>
        </select>
      </div>

      <a href="veiculos?acao=novo">
        <button class="btn-primary">
          + Novo Veículo
        </button>
      </a>

    </div>
  </section>

  <!-- Table -->
  <section class="card">
    <table class="data-table">
      <thead>
        <tr>
          <th>Placa</th>
          <th>Tipo</th>
          <th>Ano</th>
          <th>Combustível</th>
          <th>Capacidade (kg)</th>
          <th>Status</th>
          <th>Ações</th>
        </tr>
      </thead>

      <tbody>
        <%
          List<Veiculo> veiculos = (List<Veiculo>) request.getAttribute("veiculos");

          if (veiculos != null && !veiculos.isEmpty()) {
              for (Veiculo v : veiculos) {
        %>

        <tr>
          <td><strong><%= v.getPlaca() %></strong></td>
          <td><%= v.getTipo() %></td>
          <td><%= v.getAnoModelo() %></td>
          <td><%= v.getCombustivel() %></td>
          <td><%= v.getCapacidadeCargaKg() %> kg</td>
          <td>
            <span class="badge <%= v.getStatus().toString().equals("DISPONIVEL") ? "green" : v.getStatus().toString().equals("EM_VIAGEM") ? "blue" : v.getStatus().toString().equals("EM_MANUTENCAO") ? "orange" : "gray" %>">
              <%= v.getStatus() %>
            </span>
          </td>
          <td>
            <a href="veiculos?acao=editar&id=<%= v.getId() %>">
              <button class="btn-small">Editar</button>
            </a>
            <a href="veiculos?acao=deletar&id=<%= v.getId() %>" onclick="return confirm('Tem certeza?')">
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
            Nenhum veículo cadastrado
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
