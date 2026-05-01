<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

  <section class="card">
    <table class="data-table">
      <thead>
        <tr>
          <c:if test="${sessionScope.usuarioAutenticado.admin}">
            <th>Cliente</th>
          </c:if>
          <th>Logradouro</th>
          <th>Número</th>
          <th>Bairro</th>
          <th>Município</th>
          <th>UF</th>
          <th>Ações</th>
        </tr>
      </thead>

      <tbody>
        <c:choose>
          <c:when test="${not empty enderecos}">
            <c:forEach items="${enderecos}" var="e">
              <tr>
                <c:if test="${sessionScope.usuarioAutenticado.admin}">
                  <td>${e.clienteRazaoSocial}</td>
                </c:if>
                <td>${e.logradouro}</td>
                <td>${e.numero}</td>
                <td>${e.bairro}</td>
                <td>${e.municipio}</td>
                <td>${e.uf}</td>
                <td>
                  <a href="enderecos?acao=editar&id=${e.id}">
                    <button class="btn-small">Editar</button>
                  </a>
                  <a href="enderecos?acao=deletar&id=${e.id}" onclick="return confirm('Tem certeza?')">
                    <button class="btn-small btn-danger">Deletar</button>
                  </a>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr>
              <td colspan="${sessionScope.usuarioAutenticado.admin ? 7 : 6}" style="text-align: center; padding: 20px;">
                Nenhum endereço cadastrado
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
