<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Ocorrências</title>

<link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/richardFretes01-removebg-preview.ico"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleC.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
.ocorrencia-page .date-primary,
.ocorrencia-page .date-secondary {
  white-space: nowrap;
}
.empty-state-panel {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 26px 12px;
  text-align: center;
}
.empty-state-icon {
  width: 58px;
  height: 58px;
  border-radius: 18px;
  background: var(--royal-soft);
  border: 1px solid var(--royal-border);
  color: var(--royal-light);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
}
.empty-state-panel p {
  max-width: 420px;
  color: var(--muted);
  font-size: 0.9rem;
  font-weight: 700;
  line-height: 1.55;
}
</style>
</head>

<body class="ocorrencia-page">

<header class="top-header">
    <a href="menu" class="logo-btn" title="Voltar" onclick="if (window.history.length > 1) { window.history.back(); return false; }"><i class="fas fa-arrow-left"></i></a>
    <a href="menu" class="logo-btn" title="Home"><i class="fas fa-home"></i></a>
</header>

<main class="container">

  <div class="page-heading">
    <div>
      <span>Monitoramento logístico</span>
      <h1>Ocorrências</h1>
      <p>Consulte os registros operacionais criados ao longo das viagens e acompanhe atualizações importantes dos fretes.</p>
    </div>

    <a href="ocorrencias?acao=novo" class="btn-primary">
      <i class="fas fa-plus"></i>
      Nova Ocorrência
    </a>
  </div>

  <c:if test="${not empty erro}">
    <section class="card">
      <div class="alert alert-error">
        <i class="fas fa-circle-exclamation"></i>
        ${erro}
      </div>
    </section>
  </c:if>

  <section class="summary-grid">
    <div class="summary-card">
      <div class="summary-icon">
        <i class="fas fa-clipboard-list"></i>
      </div>
      <div>
        <span>Total de ocorrências</span>
        <strong>${empty ocorrencias ? 0 : ocorrencias.size()}</strong>
      </div>
    </div>

    <div class="summary-card">
      <div class="summary-icon green-icon">
        <i class="fas fa-circle-check"></i>
      </div>
      <div>
        <span>Entregas registradas</span>
        <strong>
          <c:set var="entregasRealizadas" value="0" />
          <c:forEach items="${ocorrencias}" var="o">
            <c:if test="${o.tipo == 'ENTREGA_REALIZADA'}">
              <c:set var="entregasRealizadas" value="${entregasRealizadas + 1}" />
            </c:if>
          </c:forEach>
          ${entregasRealizadas}
        </strong>
      </div>
    </div>

    <div class="summary-card">
      <div class="summary-icon red-icon">
        <i class="fas fa-triangle-exclamation"></i>
      </div>
      <div>
        <span>Ocorrências críticas</span>
        <strong>
          <c:set var="ocorrenciasCriticas" value="0" />
          <c:forEach items="${ocorrencias}" var="o">
            <c:if test="${o.tipo == 'AVARIA' || o.tipo == 'EXTRAVIO'}">
              <c:set var="ocorrenciasCriticas" value="${ocorrenciasCriticas + 1}" />
            </c:if>
          </c:forEach>
          ${ocorrenciasCriticas}
        </strong>
      </div>
    </div>
  </section>

  <section class="card table-card">
    <div class="table-header">
      <div>
        <span class="section-label">Registros</span>
        <h2>Histórico cadastrado</h2>
      </div>
    </div>

    <table class="data-table professional-table">
      <thead>
        <tr>
          <th>Frete</th>
          <th>Tipo</th>
          <th>Local</th>
          <th>Data/Hora</th>
          <th class="actions-column">Ações</th>
        </tr>
      </thead>

      <tbody>
        <c:choose>
          <c:when test="${not empty ocorrencias}">
            <c:forEach items="${ocorrencias}" var="o">
              <tr>
                <td>
                  <div class="entity-cell">
                    <div class="entity-avatar">
                      <i class="fas fa-file-lines"></i>
                    </div>
                    <div class="entity-info">
                      <strong>Frete #${o.freteId}</strong>
                      <span>Ocorrência #${o.id}</span>
                    </div>
                  </div>
                </td>

                <td>
                  <span class="badge ${o.tipo == 'ENTREGA_REALIZADA' ? 'green' : o.tipo == 'AVARIA' || o.tipo == 'EXTRAVIO' ? 'red' : 'blue'}">
                    ${o.tipo}
                  </span>
                </td>

                <td>
                  <div class="stacked-info">
                    <strong>${o.municipio}</strong>
                    <span class="muted-line">${o.uf}</span>
                  </div>
                </td>

                <td>
                  <div class="date-time-cell mask-datetime" data-iso="${o.dataHora}">
                    <strong class="date-primary">${o.dataHora}</strong>
                    <span class="date-secondary">Data e hora local</span>
                  </div>
                </td>

                <td class="actions-column">
                  <div class="table-actions">
                    <a href="ocorrencias?acao=editar&id=${o.id}" class="btn-small" title="Editar ocorrência">
                      <i class="fas fa-pen"></i>
                      Editar
                    </a>
                    <a href="ocorrencias?acao=deletar&id=${o.id}" class="btn-small btn-danger" title="Excluir ocorrência" onclick="return confirm('Tem certeza?')">
                      <i class="fas fa-trash"></i>
                      Excluir
                    </a>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </c:when>

          <c:otherwise>
            <tr>
              <td colspan="5">
                <div class="empty-state-panel">
                  <div class="empty-state-icon">
                    <i class="fas fa-inbox"></i>
                  </div>
                  <strong>Nenhuma ocorrência cadastrada</strong>
                  <p>Comece registrando eventos operacionais para manter o histórico dos fretes mais completo.</p>
                </div>
              </td>
            </tr>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>
  </section>

</main>

<script src="${pageContext.request.contextPath}/js/funcoesDetalheFrete.js"></script>

</body>
</html>
