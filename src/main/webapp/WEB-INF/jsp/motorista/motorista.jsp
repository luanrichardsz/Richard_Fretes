<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

  <c:if test="${not empty erro}">
    <section class="card">
      <div style="padding: 12px; border-radius: 8px; background: #fdecea; color: #b42318; border: 1px solid #f5c2c7;">
        ${erro}
      </div>
    </section>
  </c:if>

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
          <th>CNH Vencida</th>
          <th>Ações</th>
        </tr>
      </thead>

      <tbody>
        <c:choose>
          <c:when test="${not empty motoristas}">
            <c:forEach items="${motoristas}" var="m">
              <tr>
                <td>${m.nomeCompleto}</td>
                <td>${m.cpf}</td>
                <td>${m.numeroCnh}</td>
                <td>${m.categoriaCnh}</td>
                <td>${m.telefone}</td>
                <td>
                  <span class="badge ${m.status == 'ATIVO' ? 'green' : m.status == 'SUSPENSO' ? 'red' : 'gray'}">
                    ${m.status}
                  </span>
                </td>
                <td>
                  <span class="badge ${m.cnhVencida ? 'red' : 'green'}">
                    ${m.cnhVencida ? 'SIM' : 'NAO'}
                  </span>
                </td>
                <td>
                  <a href="motoristas?acao=editar&id=${m.id}">
                    <button class="btn-small">Editar</button>
                  </a>
                  <a href="motoristas?acao=deletar&id=${m.id}" onclick="return confirm('Tem certeza?')">
                    <button class="btn-small btn-danger">Deletar</button>
                  </a>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr>
              <td colspan="8" style="text-align: center; padding: 20px;">
                Nenhum motorista cadastrado
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
