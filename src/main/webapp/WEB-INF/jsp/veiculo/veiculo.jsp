<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="true" %>
<%@ page import="java.util.List" %>
<%@ page import="br.com.model.Veiculo" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Veículos - Richard Fretes</title>

<link rel="stylesheet" href="css/styleC.css" />

</head>

<body>

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
