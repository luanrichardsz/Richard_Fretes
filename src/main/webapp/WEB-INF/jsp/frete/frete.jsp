<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <c:choose>
          <c:when test="${not empty fretes}">
            <c:forEach items="${fretes}" var="f">
              <tr>
                <td>${f.numeroFrete}</td>
                <td>${f.remetenteId}</td>
                <td>${f.destinatarioId}</td>
                <td>
                  <span class="badge ${f.status == 'ENTREGUE' ? 'green' : 'orange'}">
                    ${f.status}
                  </span>
                </td>
                <td>R$ <fmt:formatNumber value="${f.valorTotal}" minFractionDigits="2" maxFractionDigits="2"/></td>
                <td>${f.dataEmissao}</td>
                <td>
                  <a href="fretes?acao=detalhes&id=${f.id}">
                    <button class="btn-small">Detalhes</button>
                  </a>
                  <c:if test="${f.status != 'ENTREGUE'}">
                    <a href="fretes?acao=editar&id=${f.id}">
                      <button class="btn-small">Editar</button>
                    </a>
                  </c:if>
                  <a href="fretes?acao=deletar&id=${f.id}" onclick="return confirm('Tem certeza?')">
                    <button class="btn-small btn-danger">Deletar</button>
                  </a>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr>
              <td colspan="7" style="text-align: center; padding: 20px;">
                Nenhum frete cadastrado
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
