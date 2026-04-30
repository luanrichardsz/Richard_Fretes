<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="br.com.model.OcorrenciaFrete" %>
<%@ page import="br.com.model.OcorrenciaFrete.TipoOcorrencia" %>

<% 
  OcorrenciaFrete ocorrencia = (OcorrenciaFrete) request.getAttribute("ocorrencia");
  boolean possuiDados = ocorrencia != null;
  boolean isEdicao = ocorrencia != null && ocorrencia.getId() != null;
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title><%= isEdicao ? "Editar Ocorrência" : "Nova Ocorrência" %></title>

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
    <h2><%= isEdicao ? "Editar Ocorrência" : "Nova Ocorrência" %></h2>

    <% if (request.getAttribute("erro") != null) { %>
      <div style="margin-bottom: 15px; padding: 12px; border-radius: 8px; background: #fdecea; color: #b42318; border: 1px solid #f5c2c7;">
        <%= request.getAttribute("erro") %>
      </div>
    <% } %>

    <form action="ocorrencias" method="post">
      
      <% if (isEdicao) { %>
        <input type="hidden" name="id" value="<%= ocorrencia.getId() %>" />
      <% } %>

      <div class="form-grid">

        <!-- Frete ID -->
        <div class="form-group">
          <label>Frete ID *</label>
          <input type="number" name="freteId" value="<%= possuiDados ? ocorrencia.getFreteId() : "" %>" required />
        </div>

        <!-- Tipo Ocorrência -->
        <div class="form-group">
          <label>Tipo Ocorrência *</label>
          <select name="tipo" required>
            <option value="">Selecione</option>
            <% for (TipoOcorrencia tipo : TipoOcorrencia.values()) { %>
              <option value="<%= tipo.name() %>" <%= possuiDados && ocorrencia.getTipo() != null && ocorrencia.getTipo().name().equals(tipo.name()) ? "selected" : "" %>>
                <%= tipo.name() %>
              </option>
            <% } %>
          </select>
        </div>

        <!-- Município -->
        <div class="form-group">
          <label>Município *</label>
          <input type="text" name="municipio" value="<%= possuiDados ? ocorrencia.getMunicipio() : "" %>" required />
        </div>

        <!-- UF -->
        <div class="form-group">
          <label>UF *</label>
          <input type="text" id="uf" name="uf" value="<%= possuiDados ? ocorrencia.getUf() : "" %>" maxlength="2" required />
        </div>

        <!-- Latitude -->
        <div class="form-group">
          <label>Latitude</label>
          <input type="number" step="0.000001" name="latitude" value="<%= possuiDados ? (ocorrencia.getLatitude() != null ? ocorrencia.getLatitude() : "") : "" %>" />
        </div>

        <!-- Longitude -->
        <div class="form-group">
          <label>Longitude</label>
          <input type="number" step="0.000001" name="longitude" value="<%= possuiDados ? (ocorrencia.getLongitude() != null ? ocorrencia.getLongitude() : "") : "" %>" />
        </div>

        <!-- Descrição -->
        <div class="form-group full">
          <label>Descrição</label>
          <textarea name="descricao" rows="3"><%= possuiDados ? (ocorrencia.getDescricao() != null ? ocorrencia.getDescricao() : "") : "" %></textarea>
        </div>

        <!-- Recebedor Nome -->
        <div class="form-group">
          <label>Recebedor Nome</label>
          <input type="text" name="recebedorNome" value="<%= possuiDados ? (ocorrencia.getRecebedorNome() != null ? ocorrencia.getRecebedorNome() : "") : "" %>" />
        </div>

        <!-- Recebedor Documento -->
        <div class="form-group">
          <label>Recebedor Documento</label>
          <input type="text" id="recebedorDocumento" name="recebedorDocumento" maxlength="18" inputmode="numeric" value="<%= possuiDados ? (ocorrencia.getRecebedorDocumento() != null ? ocorrencia.getRecebedorDocumento() : "") : "" %>" />
        </div>

        <!-- Foto Evidência URL -->
        <div class="form-group full">
          <label>Foto Evidência URL</label>
          <input type="url" name="fotoEvidenciaUrl" value="<%= possuiDados ? (ocorrencia.getFotoEvidenciaUrl() != null ? ocorrencia.getFotoEvidenciaUrl() : "") : "" %>" />
        </div>

      </div>

      <div style="margin-top: 20px; display: flex; gap: 10px;">
        <button type="submit" class="btn-primary">Salvar</button>
        <a href="ocorrencias"><button type="button" class="btn-secondary">Cancelar</button></a>
      </div>

    </form>

  </section>

</div>

<script src="/RichardFretes/js/funcoesCadastroO.js"></script>

</body>
</html>
