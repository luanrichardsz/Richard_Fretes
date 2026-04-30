<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="br.com.model.Cliente" %>
<%@ page import="br.com.model.Endereco" %>
<%@ page import="br.com.model.Frete" %>
<%@ page import="br.com.model.Frete.StatusFrete" %>
<%@ page import="br.com.model.Motorista" %>
<%@ page import="br.com.model.Veiculo" %>
<%@ page import="java.util.List" %>

<% 
  Frete frete = (Frete) request.getAttribute("frete");
  boolean possuiDados = frete != null;
  boolean isEdicao = frete != null && frete.getId() != null;
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title><%= isEdicao ? "Editar Frete" : "Novo Frete" %></title>

<link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
<link rel="stylesheet" href="/RichardFretes/css/styleC.css" />
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

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

<header class="top-header">
    <a href="menu" class="logo-btn" title="Home"><i class="fas fa-home"></i></a>
</header>


<div class="container">

  <section class="card">
    <h2><%= isEdicao ? "Editar Frete" : "Novo Frete" %></h2>

    <% if (request.getAttribute("erro") != null) { %>
      <div style="margin-bottom: 15px; padding: 12px; border-radius: 8px; background: #fdecea; color: #b42318; border: 1px solid #f5c2c7;">
        <%= request.getAttribute("erro") %>
      </div>
    <% } %>

    <form action="fretes" method="post">
      
      <% if (isEdicao) { %>
        <input type="hidden" name="id" value="<%= frete.getId() %>" />
      <% } %>

      <div class="form-grid">

        <!-- Número Frete -->
        <div class="form-group">
          <label>Número Frete</label>
          <input type="text" id="numeroFrete" name="numeroFrete" maxlength="20" value="<%= possuiDados ? frete.getNumeroFrete() : "" %>" />
        </div>

        <!-- Remetente ID -->
        <div class="form-group">
          <label>Remetente *</label>
          <select name="remetenteId" required>
            <option value="">Selecione um cliente</option>
            <%
              List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
              if (clientes != null) {
                for (Cliente cliente : clientes) {
                  String nomeCliente = cliente.getNomeFantasia() != null && !cliente.getNomeFantasia().trim().isEmpty()
                    ? cliente.getNomeFantasia()
                    : cliente.getRazaoSocial();
            %>
              <option value="<%= cliente.getId() %>" <%= possuiDados && frete.getRemetenteId() != null && frete.getRemetenteId().equals(cliente.getId()) ? "selected" : "" %>>
                <%= nomeCliente %>
              </option>
            <%
                }
              }
            %>
          </select>
        </div>

        <!-- Destinatário ID -->
        <div class="form-group">
          <label>Destinatário *</label>
          <select name="destinatarioId" required>
            <option value="">Selecione um cliente</option>
            <%
              if (clientes != null) {
                for (Cliente cliente : clientes) {
                  String nomeCliente = cliente.getNomeFantasia() != null && !cliente.getNomeFantasia().trim().isEmpty()
                    ? cliente.getNomeFantasia()
                    : cliente.getRazaoSocial();
            %>
              <option value="<%= cliente.getId() %>" <%= possuiDados && frete.getDestinatarioId() != null && frete.getDestinatarioId().equals(cliente.getId()) ? "selected" : "" %>>
                <%= nomeCliente %>
              </option>
            <%
                }
              }
            %>
          </select>
        </div>

        <!-- Endereço Origem ID -->
        <div class="form-group">
          <label>Endereço Origem *</label>
          <select name="enderecoOrigemId" required>
            <option value="">Selecione um endereço</option>
            <%
              List<Endereco> enderecos = (List<Endereco>) request.getAttribute("enderecos");
              if (enderecos != null) {
                for (Endereco endereco : enderecos) {
            %>
              <option value="<%= endereco.getId() %>" <%= possuiDados && frete.getEnderecoOrigemId() != null && frete.getEnderecoOrigemId().equals(endereco.getId()) ? "selected" : "" %>>
                <%= endereco.getLogradouro() %>, <%= endereco.getNumero() %> - <%= endereco.getMunicipio() %>/<%= endereco.getUf() %>
              </option>
            <%
                }
              }
            %>
          </select>
        </div>

        <!-- Endereço Destino ID -->
        <div class="form-group">
          <label>Endereço Destino *</label>
          <select name="enderecoDestinoId" required>
            <option value="">Selecione um endereço</option>
            <%
              if (enderecos != null) {
                for (Endereco endereco : enderecos) {
            %>
              <option value="<%= endereco.getId() %>" <%= possuiDados && frete.getEnderecoDestinoId() != null && frete.getEnderecoDestinoId().equals(endereco.getId()) ? "selected" : "" %>>
                <%= endereco.getLogradouro() %>, <%= endereco.getNumero() %> - <%= endereco.getMunicipio() %>/<%= endereco.getUf() %>
              </option>
            <%
                }
              }
            %>
          </select>
        </div>

        <!-- Motorista ID -->
        <div class="form-group">
          <label>Motorista *</label>
          <select name="motoristaId" required>
            <option value="">Selecione um motorista</option>
            <%
              List<Motorista> motoristas = (List<Motorista>) request.getAttribute("motoristas");
              if (motoristas != null) {
                for (Motorista motorista : motoristas) {
            %>
              <option value="<%= motorista.getId() %>" <%= possuiDados && frete.getMotoristaId() != null && frete.getMotoristaId().equals(motorista.getId()) ? "selected" : "" %>>
                <%= motorista.getNomeCompleto() %>
              </option>
            <%
                }
              }
            %>
          </select>
        </div>

        <!-- Veículo ID -->
        <div class="form-group">
          <label>Veículo *</label>
          <select name="veiculoId" required>
            <option value="">Selecione um veículo</option>
            <%
              List<Veiculo> veiculos = (List<Veiculo>) request.getAttribute("veiculos");
              if (veiculos != null) {
                for (Veiculo veiculo : veiculos) {
            %>
              <option value="<%= veiculo.getId() %>" <%= possuiDados && frete.getVeiculoId() != null && frete.getVeiculoId().equals(veiculo.getId()) ? "selected" : "" %>>
                <%= veiculo.getPlaca() %> - <%= veiculo.getTipo() %>
              </option>
            <%
                }
              }
            %>
          </select>
        </div>

        <!-- Chave NFe -->
        <div class="form-group">
          <label>Chave NFe</label>
          <input type="text" id="chaveNfe" name="chaveNfe" maxlength="44" inputmode="numeric" value="<%= possuiDados ? (frete.getChaveNfe() != null ? frete.getChaveNfe() : "") : "" %>" />
        </div>

        <!-- Natureza Carga -->
        <div class="form-group">
          <label>Natureza Carga *</label>
          <input type="text" name="naturezaCarga" value="<%= possuiDados ? frete.getNaturezaCarga() : "" %>" required />
        </div>

        <!-- Peso Bruto -->
        <div class="form-group">
          <label>Peso Bruto (kg) *</label>
          <input type="number" step="0.01" name="pesoBruto" value="<%= possuiDados ? frete.getPesoBruto() : "" %>" required />
        </div>

        <!-- Volumes -->
        <div class="form-group">
          <label>Volumes *</label>
          <input type="number" name="volumes" value="<%= possuiDados ? frete.getVolumes() : "" %>" required />
        </div>

        <!-- Distância KM -->
        <div class="form-group">
          <label>Distância (km) *</label>
          <input type="number" step="0.01" name="distanciaKm" value="<%= possuiDados ? frete.getDistanciaKm() : "" %>" required />
        </div>

        <!-- Valor Frete Bruto -->
        <div class="form-group">
          <label>Valor Frete Bruto *</label>
          <input type="number" step="0.01" name="valorFreteBruto" value="<%= possuiDados ? frete.getValorFreteBruto() : "" %>" required />
        </div>

        <!-- Valor Pedágio -->
        <div class="form-group">
          <label>Valor Pedágio</label>
          <input type="number" step="0.01" name="valorPedagio" value="<%= possuiDados ? frete.getValorPedagio() : "" %>" />
        </div>

        <!-- Alíquota ICMS -->
        <div class="form-group">
          <label>Alíquota ICMS (%)</label>
          <input type="number" step="0.01" name="aliquotaIcms" value="<%= possuiDados ? frete.getAliquotaIcms() : "" %>" />
        </div>

        <!-- Valor ICMS -->
        <div class="form-group">
          <label>Valor ICMS</label>
          <input type="number" step="0.01" name="valorIcms" value="<%= possuiDados ? frete.getValorIcms() : "" %>" />
        </div>

        <!-- Valor Total -->
        <div class="form-group">
          <label>Valor Total *</label>
          <input type="number" step="0.01" name="valorTotal" value="<%= possuiDados ? frete.getValorTotal() : "" %>" required />
        </div>

        <!-- Status -->
        <div class="form-group">
          <label>Status *</label>
          <select name="status" required>
            <option value="">Selecione</option>
            <% for (StatusFrete status : StatusFrete.values()) { %>
              <option value="<%= status.name() %>" <%= possuiDados && frete.getStatus() != null && frete.getStatus().name().equals(status.name()) ? "selected" : "" %>>
                <%= status.name() %>
              </option>
            <% } %>
          </select>
        </div>

        <!-- Previsão Entrega -->
        <div class="form-group">
          <label>Previsão Entrega *</label>
          <input type="date" name="previsaoEntrega" min="<%= java.time.LocalDate.now() %>" value="<%= possuiDados ? frete.getPrevisaoEntrega() : "" %>" required />
        </div>

        <!-- Origem IBGE -->
        <div class="form-group">
          <label>Origem IBGE</label>
          <input type="text" id="origemIbge" name="origemIbge" maxlength="7" inputmode="numeric" value="<%= possuiDados ? (frete.getOrigemIbge() != null ? frete.getOrigemIbge() : "") : "" %>" />
        </div>

        <!-- Destino IBGE -->
        <div class="form-group">
          <label>Destino IBGE</label>
          <input type="text" id="destinoIbge" name="destinoIbge" maxlength="7" inputmode="numeric" value="<%= possuiDados ? (frete.getDestinoIbge() != null ? frete.getDestinoIbge() : "") : "" %>" />
        </div>

      </div>

      <div style="margin-top: 20px; display: flex; gap: 10px;">
        <button type="submit" class="btn-primary">Salvar</button>
        <a href="fretes"><button type="button" class="btn-secondary">Cancelar</button></a>
      </div>

    </form>

  </section>

</div>

<script src="/RichardFretes/js/funcoesCadastroF.js"></script>

</body>
</html>
