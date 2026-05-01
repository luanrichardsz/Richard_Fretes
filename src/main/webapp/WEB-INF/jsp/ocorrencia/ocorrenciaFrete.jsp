<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Ocorrências</title>

<link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
<link rel="stylesheet" href="/RichardFretes/css/styleC.css" />
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
        <c:choose>
          <c:when test="${not empty ocorrencias}">
            <c:forEach items="${ocorrencias}" var="o">
              <tr>
                <td>${o.freteId}</td>
                <td>
                  <span class="badge blue">
                    ${o.tipo}
                  </span>
                </td>
                <td>${o.municipio}</td>
                <td>${o.uf}</td>
                <td>${o.dataHora}</td>
                <td>
                  <a href="ocorrencias?acao=editar&id=${o.id}">
                    <button class="btn-small">Editar</button>
                  </a>
                  <a href="ocorrencias?acao=deletar&id=${o.id}" onclick="return confirm('Tem certeza?')">
                    <button class="btn-small btn-danger">Deletar</button>
                  </a>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr>
              <td colspan="6" style="text-align: center; padding: 20px;">
                Nenhuma ocorrência cadastrada
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
