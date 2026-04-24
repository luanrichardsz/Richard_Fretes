<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="br.com.model.OcorrenciaFrete" %>
<%@ page import="br.com.model.OcorrenciaFrete.TipoOcorrencia" %>

<% 
  OcorrenciaFrete ocorrencia = (OcorrenciaFrete) request.getAttribute("ocorrencia");
  boolean isEdicao = ocorrencia != null;
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title><%= isEdicao ? "Editar Ocorrência - Richard Fretes" : "Nova Ocorrência - Richard Fretes" %></title>

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
    <h2><%= isEdicao ? "Editar Ocorrência" : "Nova Ocorrência" %></h2>

    <form action="ocorrencias" method="post">
      
      <% if (isEdicao) { %>
        <input type="hidden" name="id" value="<%= ocorrencia.getId() %>" />
      <% } %>

      <div class="form-grid">

        <!-- Frete ID -->
        <div class="form-group">
          <label>Frete ID *</label>
          <input type="number" name="freteId" value="<%= isEdicao ? ocorrencia.getFreteId() : "" %>" required />
        </div>

        <!-- Tipo Ocorrência -->
        <div class="form-group">
          <label>Tipo Ocorrência *</label>
          <select name="tipo" required>
            <option value="">Selecione</option>
            <% for (TipoOcorrencia tipo : TipoOcorrencia.values()) { %>
              <option value="<%= tipo.name() %>" <%= isEdicao && ocorrencia.getTipo() != null && ocorrencia.getTipo().name().equals(tipo.name()) ? "selected" : "" %>>
                <%= tipo.name() %>
              </option>
            <% } %>
          </select>
        </div>

        <!-- Município -->
        <div class="form-group">
          <label>Município *</label>
          <input type="text" name="municipio" value="<%= isEdicao ? ocorrencia.getMunicipio() : "" %>" required />
        </div>

        <!-- UF -->
        <div class="form-group">
          <label>UF *</label>
          <input type="text" name="uf" value="<%= isEdicao ? ocorrencia.getUf() : "" %>" maxlength="2" required />
        </div>

        <!-- Latitude -->
        <div class="form-group">
          <label>Latitude</label>
          <input type="number" step="0.000001" name="latitude" value="<%= isEdicao ? (ocorrencia.getLatitude() != null ? ocorrencia.getLatitude() : "") : "" %>" />
        </div>

        <!-- Longitude -->
        <div class="form-group">
          <label>Longitude</label>
          <input type="number" step="0.000001" name="longitude" value="<%= isEdicao ? (ocorrencia.getLongitude() != null ? ocorrencia.getLongitude() : "") : "" %>" />
        </div>

        <!-- Descrição -->
        <div class="form-group full">
          <label>Descrição</label>
          <textarea name="descricao" rows="3"><%= isEdicao ? (ocorrencia.getDescricao() != null ? ocorrencia.getDescricao() : "") : "" %></textarea>
        </div>

        <!-- Recebedor Nome -->
        <div class="form-group">
          <label>Recebedor Nome</label>
          <input type="text" name="recebedorNome" value="<%= isEdicao ? (ocorrencia.getRecebedorNome() != null ? ocorrencia.getRecebedorNome() : "") : "" %>" />
        </div>

        <!-- Recebedor Documento -->
        <div class="form-group">
          <label>Recebedor Documento</label>
          <input type="text" name="recebedorDocumento" value="<%= isEdicao ? (ocorrencia.getRecebedorDocumento() != null ? ocorrencia.getRecebedorDocumento() : "") : "" %>" />
        </div>

        <!-- Foto Evidência URL -->
        <div class="form-group full">
          <label>Foto Evidência URL</label>
          <input type="url" name="fotoEvidenciaUrl" value="<%= isEdicao ? (ocorrencia.getFotoEvidenciaUrl() != null ? ocorrencia.getFotoEvidenciaUrl() : "") : "" %>" />
        </div>

      </div>

      <div style="margin-top: 20px; display: flex; gap: 10px;">
        <button type="submit" class="btn-primary">Salvar</button>
        <a href="ocorrencias"><button type="button" class="btn-secondary">Cancelar</button></a>
      </div>

    </form>

  </section>

</div>

</body>
</html>
