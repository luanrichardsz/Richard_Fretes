<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>${not empty veiculo.id ? 'Editar Veículo' : 'Novo Veículo'}</title>

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
    <h2>${not empty veiculo.id ? 'Editar Veículo' : 'Novo Veículo'}</h2>

    <c:if test="${not empty erro}">
      <div style="margin-bottom: 15px; padding: 12px; border-radius: 8px; background: #fdecea; color: #b42318; border: 1px solid #f5c2c7;">
        ${erro}
      </div>
    </c:if>

    <form action="veiculos" method="post">
      <c:if test="${not empty veiculo.id}">
        <input type="hidden" name="id" value="${veiculo.id}" />
      </c:if>

      <div class="form-grid">

        <div class="section-title">Identificação</div>

        <div class="form-group">
          <label>Placa *</label>
          <input type="text" id="placa" name="placa" value="${veiculo.placa}" required maxlength="8" />
        </div>

        <div class="form-group">
          <label>RENAVAM *</label>
          <input type="text" id="renavam" name="renavam" maxlength="11" inputmode="numeric" value="${veiculo.renavam}" required />
        </div>

        <div class="form-group">
          <label>RNTRC</label>
          <input type="text" id="rntrc" name="rntrc" maxlength="8" inputmode="numeric" value="${veiculo.rntrc}" />
        </div>

        <c:if test="${sessionScope.usuarioAutenticado.admin}">
          <div class="form-group">
            <label>Empresa Selecionada *</label>
            <select name="clienteId" required>
              <option value="">Selecione uma empresa</option>
              <c:forEach var="cliente" items="${clientes}">
                <option value="${cliente.id}" ${not empty veiculo.clienteId and veiculo.clienteId eq cliente.id ? 'selected' : ''}>
                  ${cliente.razaoSocial}
                </option>
              </c:forEach>
            </select>
          </div>
        </c:if>

        <div class="section-title">Características do Veículo</div>

        <div class="form-group">
          <label>Ano Fabricação *</label>
          <input type="number" name="anoFabricacao" maxlength="4" value="${veiculo.anoFabricacao}" required />
        </div>

        <div class="form-group">
          <label>Ano Modelo *</label>
          <input type="number" name="anoModelo" maxlength="4" value="${veiculo.anoModelo}" required />
        </div>

        <div class="form-group">
          <label>Combustível *</label>
          <select name="combustivel" required>
            <option value="">Selecione</option>
            <option value="Diesel" ${veiculo.combustivel eq 'Diesel' ? 'selected' : ''}>Diesel</option>
            <option value="Gasolina" ${veiculo.combustivel eq 'Gasolina' ? 'selected' : ''}>Gasolina</option>
            <option value="Etanol" ${veiculo.combustivel eq 'Etanol' ? 'selected' : ''}>Etanol</option>
            <option value="GNV" ${veiculo.combustivel eq 'GNV' ? 'selected' : ''}>GNV</option>
          </select>
        </div>

        <div class="form-group">
          <label>Tipo *</label>
          <input type="text" name="tipo" value="${veiculo.tipo}" required />
        </div>

        <div class="form-group">
          <label>Tipo Outros</label>
          <input type="text" name="tipoOutros" value="${veiculo.tipoOutros}" />
        </div>

        <div class="form-group">
          <label>Quantidade Eixos *</label>
          <input type="number" name="quantidadeEixos" value="${veiculo.quantidadeEixos}" required />
        </div>

        <div class="section-title">Capacidade e Peso</div>

        <div class="form-group">
          <label>Tara (kg) *</label>
          <input type="number" name="taraKg" value="${veiculo.taraKg}" required />
        </div>

        <div class="form-group">
          <label>Capacidade Carga (kg) *</label>
          <input type="number" name="capacidadeCargaKg" value="${veiculo.capacidadeCargaKg}" required />
        </div>

        <div class="form-group">
          <label>Volume (m³)</label>
          <input type="number" name="volumeM3" value="${veiculo.volumeM3}" />
        </div>

        <div class="section-title">Informações Operacionais</div>

        <div class="form-group">
          <label>Status *</label>
          <select name="status" required>
            <option value="">Selecione</option>
            <c:forEach var="status" items="${statusVeiculoOptions}">
              <option value="${status}" ${veiculo.status eq status ? 'selected' : ''}>${status}</option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label>Motorista</label>
          <select name="motoristaId">
            <option value="">Selecione um motorista</option>
            <c:forEach var="motorista" items="${motoristas}">
              <option value="${motorista.id}" ${not empty veiculo.motoristaId and veiculo.motoristaId eq motorista.id ? 'selected' : ''}>
                ${motorista.nomeCompleto}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label>Seguro Validade</label>
          <input type="date" name="seguroValidade" value="${veiculo.seguroValidade}" />
        </div>

        <div class="form-group">
          <label>
            <input type="checkbox" name="manutencaoPendente" value="true" ${veiculo.manutencaoPendente ? 'checked' : ''} />
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
