<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Clientes</title>

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

  <section class="card">
    <table class="data-table">
      <thead>
        <tr>
          <th>Razão Social</th>
          <th>CNPJ</th>
          <th>Contato</th>
          <th>Status</th>
          <th>Ações</th>
        </tr>
      </thead>

      <tbody>
        <c:choose>
          <c:when test="${not empty clientes}">
            <c:forEach items="${clientes}" var="c">
              <tr>
                <td>${c.razaoSocial}</td>
                <td>${c.documento}</td>
                <td>
                  ${c.email}<br>
                  ${c.telefone}
                </td>
                <td>
                  <span class="badge ${c.ativo ? 'green' : 'red'}">
                    ${c.ativo ? 'Ativo' : 'Inativo'}
                  </span>
                </td>
                <td>
                  <a href="clientes?acao=editar&id=${c.id}">
                    <button class="btn-small">Editar</button>
                  </a>
                  <a href="clientes?acao=deletar&id=${c.id}" onclick="return confirm('Tem certeza que deseja excluir este cliente?');">
                    <button class="btn-small danger">Excluir</button>
                  </a>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr>
              <td colspan="5" style="text-align:center; padding:20px;">
                Nenhum cliente encontrado
              </td>
            </tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </section>

</div>

</body>
</html>
