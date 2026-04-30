<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ page import="br.com.veiculo.Veiculo" %>
<%@ page import="br.com.veiculo.Veiculo.StatusVeiculo" %>
<%@ page import="br.com.usuario.Usuario" %>
<%@ page import="br.com.cliente.Cliente" %>
<%@ page import="br.com.motorista.Motorista" %>
<%@ page import="java.util.List" %>

<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioAutenticado");
    if (usuarioLogado == null) {
        response.sendRedirect("login");
        return;
    }
%>

<% 
  Veiculo veiculo = (Veiculo) request.getAttribute("veiculo");
  boolean possuiDados = veiculo != null;
  boolean isEdicao = veiculo != null && veiculo.getId() != null;
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title><%= isEdicao ? "Editar Veículo" : "Novo Veículo" %></title>

<link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
<link rel="stylesheet" href="/RichardFretes/css/styleC.css" />
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
.section-title {
  grid-column: span 3;
  font-weight: bold;
  margin-top: 15px;
  border-bottom: 1px solid #ddd;
  padding-bottom: 5px;
}
</style>

</head>

<body>

<header class="top-header">
    <a href="menu" class="logo-btn" title="Home"><i class="fas fa-home"></i></a>
</header>



<div class="container">

  <section class="card">
    <h2><%= isEdicao ? "Editar Veículo" : "Novo Veículo" %></h2>

    <% if (request.getAttribute("erro") != null) { %>
      <div style="margin-bottom: 15px; padding: 12px; border-radius: 8px; background: #fdecea; color: #b42318; border: 1px solid #f5c2c7;">
        <%= request.getAttribute("erro") %>
      </div>
    <% } %>

    <form action="veiculos" method="post">
      
      <% if (isEdicao) { %>
        <input type="hidden" name="id" value="<%= veiculo.getId() %>" />
      <% } %>

      <div class="form-grid">

        <!-- IDENTIFICAÇÃO -->
        <div class="section-title">Identificação</div>

        <!-- Placa -->
        <div class="form-group">
          <label>Placa *</label>
          <input type="text" id="placa" name="placa" value="<%= possuiDados ? veiculo.getPlaca() : "" %>" required maxlength="8" />
        </div>

        <!-- RENAVAM -->
        <div class="form-group">
          <label>RENAVAM *</label>
          <input type="text" id="renavam" name="renavam" maxlength="11" inputmode="numeric" value="<%= possuiDados ? veiculo.getRenavam() : "" %>" required />
        </div>

        <!-- RNTRC -->
        <div class="form-group">
          <label>RNTRC</label>
          <input type="text" id="rntrc" name="rntrc" maxlength="8" inputmode="numeric" value="<%= possuiDados ? (veiculo.getRntrc() != null ? veiculo.getRntrc() : "") : "" %>" />
        </div>

        <% if (usuarioLogado.isAdmin()) { %>
          <div class="form-group">
            <label>Empresa Selecionada *</label>
            <select name="clienteId" required>
              <option value="">Selecione uma empresa</option>
              <%
                List<Cliente> clientes = (List<Cliente>) request.getAttribute("clientes");
                if (clientes != null) {
                  for (Cliente cliente : clientes) {
              %>
                <option value="<%= cliente.getId() %>" <%= possuiDados && veiculo.getClienteId() != null && veiculo.getClienteId().equals(cliente.getId()) ? "selected" : "" %>>
                  <%= cliente.getNomeFantasia() %>
                </option>
              <%
                  }
                }
              %>
            </select>
          </div>
        <% } %>

        <!-- CARACTERÍSTICAS -->
        <div class="section-title">Características do Veículo</div>

        <!-- Ano Fabricação -->
        <div class="form-group">
          <label>Ano Fabricação *</label>
          <input type="number" name="anoFabricacao" maxlength="4" value="<%= possuiDados ? veiculo.getAnoFabricacao() : "" %>" required />
        </div>

        <!-- Ano Modelo -->
        <div class="form-group">
          <label>Ano Modelo *</label>
          <input type="number" name="anoModelo" maxlength="4" value="<%= possuiDados ? veiculo.getAnoModelo() : "" %>" required />
        </div>

        <!-- Combustível -->
        <div class="form-group">
          <label>Combustível *</label>
          <select name="combustivel" required>
            <option value="">Selecione</option>
            <option value="Diesel" <%= possuiDados && veiculo.getCombustivel() != null && veiculo.getCombustivel().equals("Diesel") ? "selected" : "" %>>Diesel</option>
            <option value="Gasolina" <%= possuiDados && veiculo.getCombustivel() != null && veiculo.getCombustivel().equals("Gasolina") ? "selected" : "" %>>Gasolina</option>
            <option value="Etanol" <%= possuiDados && veiculo.getCombustivel() != null && veiculo.getCombustivel().equals("Etanol") ? "selected" : "" %>>Etanol</option>
            <option value="GNV" <%= possuiDados && veiculo.getCombustivel() != null && veiculo.getCombustivel().equals("GNV") ? "selected" : "" %>>GNV</option>
          </select>
        </div>

        <!-- Tipo -->
        <div class="form-group">
          <label>Tipo *</label>
          <input type="text" name="tipo" value="<%= possuiDados ? veiculo.getTipo() : "" %>" required />
        </div>

        <!-- Tipo Outros -->
        <div class="form-group">
          <label>Tipo Outros</label>
          <input type="text" name="tipoOutros" value="<%= possuiDados ? (veiculo.getTipoOutros() != null ? veiculo.getTipoOutros() : "") : "" %>" />
        </div>

        <!-- Quantidade Eixos -->
        <div class="form-group">
          <label>Quantidade Eixos *</label>
          <input type="number" name="quantidadeEixos" value="<%= possuiDados ? veiculo.getQuantidadeEixos() : "" %>" required />
        </div>

        <!-- CAPACIDADE E PESO -->
        <div class="section-title">Capacidade e Peso</div>

        <!-- Tara (kg) -->
        <div class="form-group">
          <label>Tara (kg) *</label>
          <input type="number" name="taraKg" value="<%= possuiDados ? veiculo.getTaraKg() : "" %>" required />
        </div>

        <!-- Capacidade Carga (kg) -->
        <div class="form-group">
          <label>Capacidade Carga (kg) *</label>
          <input type="number" name="capacidadeCargaKg" value="<%= possuiDados ? veiculo.getCapacidadeCargaKg() : "" %>" required />
        </div>

        <!-- Volume (m³) -->
        <div class="form-group">
          <label>Volume (m³)</label>
          <input type="number" name="volumeM3" value="<%= possuiDados ? veiculo.getVolumeM3() : "" %>" />
        </div>

        <!-- OPERACIONAL -->
        <div class="section-title">Informações Operacionais</div>

        <!-- Status -->
        <div class="form-group">
          <label>Status *</label>
          <select name="status" required>
            <option value="">Selecione</option>
            <% for (StatusVeiculo status : StatusVeiculo.values()) { %>
              <option value="<%= status.name() %>" <%= possuiDados && veiculo.getStatus() != null && veiculo.getStatus().name().equals(status.name()) ? "selected" : "" %>>
                <%= status.name() %>
              </option>
            <% } %>
          </select>
        </div>

        <!-- Motorista ID -->
        <div class="form-group">
          <label>Motorista</label>
          <select name="motoristaId">
            <option value="">Selecione um motorista</option>
            <%
              List<Motorista> motoristas = (List<Motorista>) request.getAttribute("motoristas");
              if (motoristas != null) {
                for (Motorista motorista : motoristas) {
            %>
              <option value="<%= motorista.getId() %>" <%= possuiDados && veiculo.getMotoristaId() != null && veiculo.getMotoristaId().equals(motorista.getId()) ? "selected" : "" %>>
                <%= motorista.getNomeCompleto() %>
              </option>
            <%
                }
              }
            %>
          </select>
        </div>

        <!-- Seguro Validade -->
        <div class="form-group">
          <label>Seguro Validade</label>
          <input type="date" name="seguroValidade" value="<%= possuiDados ? (veiculo.getSeguroValidade() != null ? veiculo.getSeguroValidade() : "") : "" %>" />
        </div>

        <!-- Manutenção Pendente -->
        <div class="form-group">
          <label>
            <input type="checkbox" name="manutencaoPendente" value="true" <%= possuiDados && veiculo.isManutencaoPendente() ? "checked" : "" %> />
            Manutenção Pendente
          </label>
        </div>

      </div>

      <div style="margin-top: 20px; display: flex; gap: 10px;">
        <button type="submit" class="btn-primary">Salvar</button>
        <a href="veiculos"><button type="button" class="btn-secondary">Cancelar</button></a>
      </div>

    </form>

  </section>

</div>

<script src="/RichardFretes/js/funcoesCadastroV.js"></script>

</body>
</html>
