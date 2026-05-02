<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <c:choose>
          <c:when test="${not empty veiculos}">
            <c:forEach items="${veiculos}" var="v">
              <tr>
                <td><strong>${v.placa}</strong></td>
                <td>${v.tipo}</td>
                <td>${v.anoModelo}</td>
                <td>${v.combustivel}</td>
                <td>${v.capacidadeCargaKg} kg</td>
                <td>
                  <span class="badge ${v.status == 'DISPONIVEL' ? 'green' : v.status == 'EM_VIAGEM' ? 'blue' : v.status == 'EM_MANUTENCAO' ? 'orange' : 'gray'}">
                    ${v.status}
                  </span>
                </td>
                <td>
                  <a href="veiculos?acao=editar&id=${v.id}">
                    <button class="btn-small">Editar</button>
                  </a>
                  <a href="veiculos?acao=deletar&id=${v.id}" onclick="return confirm('Tem certeza?')">
                    <button class="btn-small btn-danger">Deletar</button>
                  </a>
                </td>
              </tr>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <tr>
              <td colspan="7" style="text-align: center; padding: 20px;">
                Nenhum veículo cadastrado
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
