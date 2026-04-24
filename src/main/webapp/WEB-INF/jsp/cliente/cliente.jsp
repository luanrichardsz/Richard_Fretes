<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="true" %>
<%@ page import="java.util.List" %>
<%@ page import="br.com.model.Cliente" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Clientes - Richard Fretes</title>

<link rel="stylesheet" href="css/styleC.css" />

</head>

<body>

<div class="container">

  <!-- Toolbar -->
  <section class="card toolbar">
    <div class="toolbar-row">
      
      <div class="filters">
        <input type="text" placeholder="Buscar" />

        <select>
          <option>Todos os tipos</option>
          <option>PJ</option>
          <option>PF</option>
        </select>

        <select>
          <option>Todos status</option>
          <option>Ativo</option>
          <option>Inativo</option>
        </select>
      </div>

      <a href="clientes?acao=novo">
        <button class="btn-primary">
          + Novo Cliente
        </button>
      </a>

    </div>
  </section>

  <!-- Table -->
  <section class="card">
    <table class="data-table">
      <thead>
        <tr>
          <th>Tipo</th>
          <th>Nome</th>
          <th>Documento</th>
          <th>Município</th>
          <th>Contato</th>
          <th>Status</th>
          <th>Ações</th>
        </tr>
      </thead>

      <tbody>
        <%
          List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");

          if (clientes != null && !clientes.isEmpty()) {
              for (Cliente c : clientes) {
        %>

        <tr>
          <!-- Tipo -->
          <td>
            <span class="badge <%= c.getTipoPessoa().toString().equals("PJ") ? "blue" : "gray" %>">
              <%= c.getTipoPessoa() %>
            </span>
          </td>

          <!-- Nome -->
          <td>
            <%= c.getTipoPessoa().toString().equals("PJ") 
                ? c.getRazaoSocial() 
                : c.getNomeFantasia() %>
          </td>

          <!-- Documento -->
          <td>
            <%= c.getTipoPessoa().toString().equals("PJ") 
                ? c.getDocumento() 
                : "-" %>
          </td>

          <!-- Município (placeholder) -->
          <td>-</td>

          <!-- Contato -->
          <td>
            <%= c.getEmail() %><br>
            <%= c.getTelefone() %>
          </td>

          <!-- Status -->
          <td>
            <span class="badge <%= c.isAtivo() ? "green" : "red" %>">
              <%= c.isAtivo() ? "Ativo" : "Inativo" %>
            </span>
          </td>

          <!-- Ações -->
          <td>
            <a href="clientes?acao=editar&id=<%= c.getId() %>">
              <button class="btn-small">Editar</button>
            </a>
          <a href="clientes?acao=deletar&id=<%= c.getId() %>"
            onclick="return confirm('Tem certeza que deseja excluir este cliente?');">
            <button class="btn-small danger">Excluir</button>
          </a>
          </td>
        </tr>

        <%
              }
          } else {
        %>

        <tr>
          <td colspan="7" style="text-align:center; padding:20px;">
            Nenhum cliente encontrado
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