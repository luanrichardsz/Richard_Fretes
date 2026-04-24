<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="true" %>
<%@ page import="java.util.List" %>
<%@ page import="br.com.model.OcorrenciaFrete" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Ocorrências - Richard Fretes</title>

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
          <option>Todos os tipos</option>
          <option>SAIDA_DO_PATIO</option>
          <option>EM_ROTA</option>
          <option>ENTREGA_REALIZADA</option>
          <option>AVARIA</option>
          <option>EXTRAVIO</option>
        </select>
      </div>

      <a href="ocorrencias?acao=novo">
        <button class="btn-primary">
          + Nova Ocorrência
        </button>
      </a>

    </div>
  </section>

  <!-- Table -->
  <section class="card">
    <table class="data-table">
      <thead>
        <tr>
          <th>Frete ID</th>
          <th>Tipo</th>
          <th>Município</th>
          <th>UF</th>
          <th>Data/Hora</th>
          <th>Ações</th>
        </tr>
      </thead>

      <tbody>
        <%
          List<OcorrenciaFrete> ocorrencias = (List<OcorrenciaFrete>) request.getAttribute("ocorrencias");

          if (ocorrencias != null && !ocorrencias.isEmpty()) {
              for (OcorrenciaFrete o : ocorrencias) {
        %>

        <tr>
          <td><%= o.getFreteId() %></td>
          <td>
            <span class="badge blue">
              <%= o.getTipo() %>
            </span>
          </td>
          <td><%= o.getMunicipio() %></td>
          <td><%= o.getUf() %></td>
          <td><%= o.getDataHora() %></td>
          <td>
            <a href="ocorrencias?acao=editar&id=<%= o.getId() %>">
              <button class="btn-small">Editar</button>
            </a>
            <a href="ocorrencias?acao=deletar&id=<%= o.getId() %>" onclick="return confirm('Tem certeza?')">
              <button class="btn-small btn-danger">Deletar</button>
            </a>
          </td>
        </tr>

        <%
              }
          } else {
        %>

        <tr>
          <td colspan="6" style="text-align: center; padding: 20px;">
            Nenhuma ocorrência cadastrada
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
