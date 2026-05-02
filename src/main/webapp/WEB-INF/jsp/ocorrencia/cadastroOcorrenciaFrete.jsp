<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>${not empty ocorrencia.id ? 'Editar Ocorrência' : 'Nova Ocorrência'}</title>

<link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
<link rel="stylesheet" href="/RichardFretes/css/styleC.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
.form-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
}
.form-group {
  display: flex;
  flex-direction: column;
}
.full {
  grid-column: span 2;
}
</style>

</head>

<body>

<header class="top-header">
    <a href="menu" class="logo-btn" title="Home"><i class="fas fa-home"></i></a>
</header>

<div class="container">

  <section class="card">
    <h2>${not empty ocorrencia.id ? 'Editar Ocorrência' : 'Nova Ocorrência'}</h2>

    <c:if test="${not empty erro}">
      <div style="margin-bottom: 15px; padding: 12px; border-radius: 8px; background: #fdecea; color: #b42318; border: 1px solid #f5c2c7;">
        ${erro}
      </div>
    </c:if>

    <form action="ocorrencias" method="post">
      <c:if test="${not empty ocorrencia.id}">
        <input type="hidden" name="id" value="${ocorrencia.id}" />
      </c:if>
      <c:if test="${not empty retornoFreteId}">
        <input type="hidden" name="retornoFreteId" value="${retornoFreteId}" />
      </c:if>

      <div class="form-grid">

        <div class="form-group">
          <label>Frete ID *</label>
          <c:choose>
            <c:when test="${not empty retornoFreteId}">
              <input type="hidden" name="freteId" value="${ocorrencia.freteId}" />
              <input type="text" value="${ocorrencia.freteId} - ${freteRelacionado.numeroFrete}" readonly style="background: #f3f4f6; color: #475467;" />
            </c:when>
            <c:otherwise>
              <input type="number" name="freteId" value="${ocorrencia.freteId}" required />
            </c:otherwise>
          </c:choose>
        </div>

        <div class="form-group">
          <label>Tipo Ocorrência *</label>
          <select name="tipo" required>
            <option value="">Selecione</option>
            <c:forEach var="tipo" items="${tipoOcorrenciaOptions}">
              <option value="${tipo}" ${ocorrencia.tipo eq tipo ? 'selected' : ''}>${tipo}</option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label>Município *</label>
          <input type="text" name="municipio" value="${ocorrencia.municipio}" required />
        </div>

        <div class="form-group">
          <label>UF *</label>
          <input type="text" id="uf" name="uf" value="${ocorrencia.uf}" maxlength="2" required />
        </div>

        <div class="form-group">
          <label>Latitude</label>
          <input type="number" step="0.000001" name="latitude" value="${ocorrencia.latitude}" />
        </div>

        <div class="form-group">
          <label>Longitude</label>
          <input type="number" step="0.000001" name="longitude" value="${ocorrencia.longitude}" />
        </div>

        <div class="form-group full">
          <label>Descrição</label>
          <textarea name="descricao" rows="3">${ocorrencia.descricao}</textarea>
        </div>

        <div class="form-group">
          <label>Recebedor Nome</label>
          <input type="text" name="recebedorNome" value="${ocorrencia.recebedorNome}" />
        </div>

        <div class="form-group">
          <label>Recebedor Documento</label>
          <input type="text" id="recebedorDocumento" name="recebedorDocumento" maxlength="18" inputmode="numeric" value="${ocorrencia.recebedorDocumento}" />
        </div>

        <div class="form-group full">
          <label>Foto Evidência URL</label>
          <input type="url" name="fotoEvidenciaUrl" value="${ocorrencia.fotoEvidenciaUrl}" />
        </div>

      </div>

      <div style="margin-top: 20px; display: flex; gap: 10px;">
        <button type="submit" class="btn-primary">Salvar</button>
        <c:choose>
          <c:when test="${not empty retornoFreteId}">
            <a href="fretes?acao=detalhes&id=${retornoFreteId}"><button type="button" class="btn-secondary">Cancelar</button></a>
          </c:when>
          <c:otherwise>
            <a href="ocorrencias"><button type="button" class="btn-secondary">Cancelar</button></a>
          </c:otherwise>
        </c:choose>
      </div>

    </form>

  </section>

</div>

<script src="/RichardFretes/js/funcoesCadastroO.js"></script>

</body>
</html>
