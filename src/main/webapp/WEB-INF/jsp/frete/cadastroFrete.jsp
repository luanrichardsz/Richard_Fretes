<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="br.com.model.Frete" %>
<%@ page import="br.com.model.Frete.StatusFrete" %>

<% 
  Frete frete = (Frete) request.getAttribute("frete");
  boolean isEdicao = frete != null;
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title><%= isEdicao ? "Editar Frete - Richard Fretes" : "Novo Frete - Richard Fretes" %></title>

<link rel="stylesheet" href="css/styleC.css" />

<style>
.form-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 15px;
}
.form-group {
  display: flex;
  flex-direction: column;
}
.full {
  grid-column: span 3;
}
.half {
  grid-column: span 1;
}
</style>

</head>

<body>

<div class="container">

  <section class="card">
    <h2><%= isEdicao ? "Editar Frete" : "Novo Frete" %></h2>

    <form action="fretes" method="post">
      
      <% if (isEdicao) { %>
        <input type="hidden" name="id" value="<%= frete.getId() %>" />
      <% } %>

      <div class="form-grid">

        <!-- Número Frete -->
        <div class="form-group">
          <label>Número Frete</label>
          <input type="text" name="numeroFrete" value="<%= isEdicao ? frete.getNumeroFrete() : "" %>" />
        </div>

        <!-- Remetente ID -->
        <div class="form-group">
          <label>Remetente ID *</label>
          <input type="number" name="remetenteId" value="<%= isEdicao ? frete.getRemetenteId() : "" %>" required />
        </div>

        <!-- Destinatário ID -->
        <div class="form-group">
          <label>Destinatário ID *</label>
          <input type="number" name="destinatarioId" value="<%= isEdicao ? frete.getDestinatarioId() : "" %>" required />
        </div>

        <!-- Endereço Origem ID -->
        <div class="form-group">
          <label>Endereço Origem ID *</label>
          <input type="number" name="enderecoOrigemId" value="<%= isEdicao ? frete.getEnderecoOrigemId() : "" %>" required />
        </div>

        <!-- Endereço Destino ID -->
        <div class="form-group">
          <label>Endereço Destino ID *</label>
          <input type="number" name="enderecoDestinoId" value="<%= isEdicao ? frete.getEnderecoDestinoId() : "" %>" required />
        </div>

        <!-- Motorista ID -->
        <div class="form-group">
          <label>Motorista ID *</label>
          <input type="number" name="motoristaId" value="<%= isEdicao ? frete.getMotoristaId() : "" %>" required />
        </div>

        <!-- Veículo ID -->
        <div class="form-group">
          <label>Veículo ID *</label>
          <input type="number" name="veiculoId" value="<%= isEdicao ? frete.getVeiculoId() : "" %>" required />
        </div>

        <!-- Chave NFe -->
        <div class="form-group">
          <label>Chave NFe</label>
          <input type="text" name="chaveNfe" value="<%= isEdicao ? (frete.getChaveNfe() != null ? frete.getChaveNfe() : "") : "" %>" />
        </div>

        <!-- Natureza Carga -->
        <div class="form-group">
          <label>Natureza Carga *</label>
          <input type="text" name="naturezaCarga" value="<%= isEdicao ? frete.getNaturezaCarga() : "" %>" required />
        </div>

        <!-- Peso Bruto -->
        <div class="form-group">
          <label>Peso Bruto (kg) *</label>
          <input type="number" step="0.01" name="pesoBruto" value="<%= isEdicao ? frete.getPesoBruto() : "" %>" required />
        </div>

        <!-- Volumes -->
        <div class="form-group">
          <label>Volumes *</label>
          <input type="number" name="volumes" value="<%= isEdicao ? frete.getVolumes() : "" %>" required />
        </div>

        <!-- Distância KM -->
        <div class="form-group">
          <label>Distância (km) *</label>
          <input type="number" step="0.01" name="distanciaKm" value="<%= isEdicao ? frete.getDistanciaKm() : "" %>" required />
        </div>

        <!-- Valor Frete Bruto -->
        <div class="form-group">
          <label>Valor Frete Bruto *</label>
          <input type="number" step="0.01" name="valorFreteBruto" value="<%= isEdicao ? frete.getValorFreteBruto() : "" %>" required />
        </div>

        <!-- Valor Pedágio -->
        <div class="form-group">
          <label>Valor Pedágio</label>
          <input type="number" step="0.01" name="valorPedagio" value="<%= isEdicao ? frete.getValorPedagio() : "" %>" />
        </div>

        <!-- Alíquota ICMS -->
        <div class="form-group">
          <label>Alíquota ICMS (%)</label>
          <input type="number" step="0.01" name="aliquotaIcms" value="<%= isEdicao ? frete.getAliquotaIcms() : "" %>" />
        </div>

        <!-- Valor ICMS -->
        <div class="form-group">
          <label>Valor ICMS</label>
          <input type="number" step="0.01" name="valorIcms" value="<%= isEdicao ? frete.getValorIcms() : "" %>" />
        </div>

        <!-- Valor Total -->
        <div class="form-group">
          <label>Valor Total *</label>
          <input type="number" step="0.01" name="valorTotal" value="<%= isEdicao ? frete.getValorTotal() : "" %>" required />
        </div>

        <!-- Status -->
        <div class="form-group">
          <label>Status *</label>
          <select name="status" required>
            <option value="">Selecione</option>
            <% for (StatusFrete status : StatusFrete.values()) { %>
              <option value="<%= status.name() %>" <%= isEdicao && frete.getStatus() != null && frete.getStatus().name().equals(status.name()) ? "selected" : "" %>>
                <%= status.name() %>
              </option>
            <% } %>
          </select>
        </div>

        <!-- Previsão Entrega -->
        <div class="form-group">
          <label>Previsão Entrega *</label>
          <input type="date" name="previsaoEntrega" value="<%= isEdicao ? frete.getPrevisaoEntrega() : "" %>" required />
        </div>

        <!-- Origem IBGE -->
        <div class="form-group">
          <label>Origem IBGE</label>
          <input type="text" name="origemIbge" value="<%= isEdicao ? (frete.getOrigemIbge() != null ? frete.getOrigemIbge() : "") : "" %>" />
        </div>

        <!-- Destino IBGE -->
        <div class="form-group">
          <label>Destino IBGE</label>
          <input type="text" name="destinoIbge" value="<%= isEdicao ? (frete.getDestinoIbge() != null ? frete.getDestinoIbge() : "") : "" %>" />
        </div>

      </div>

      <div style="margin-top: 20px; display: flex; gap: 10px;">
        <button type="submit" class="btn-primary">Salvar</button>
        <a href="fretes"><button type="button" class="btn-secondary">Cancelar</button></a>
      </div>

    </form>

  </section>

</div>

</body>
</html>
