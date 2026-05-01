<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>${not empty frete.id ? 'Editar Frete' : 'Novo Frete'}</title>

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
    <h2>${not empty frete.id ? 'Editar Frete' : 'Novo Frete'}</h2>

    <c:if test="${not empty erro}">
      <div style="margin-bottom: 15px; padding: 12px; border-radius: 8px; background: #fdecea; color: #b42318; border: 1px solid #f5c2c7;">
        ${erro}
      </div>
    </c:if>

    <form action="fretes" method="post">
      <c:if test="${not empty frete.id}">
        <input type="hidden" name="id" value="${frete.id}" />
      </c:if>

      <div class="form-grid">

        <div class="form-group">
          <label>Número Frete</label>
          <input type="hidden" name="numeroFrete" value="${frete.numeroFrete}" />
          <input type="text" id="numeroFrete" maxlength="20" value="${frete.numeroFrete}" readonly style="background: #f3f4f6; color: #475467; cursor: not-allowed;" />
        </div>

        <div class="form-group">
          <label>Remetente *</label>
          <select name="remetenteId" required>
            <option value="">Selecione um cliente</option>
            <c:forEach var="cliente" items="${clientes}">
              <option value="${cliente.id}" ${not empty frete.remetenteId and frete.remetenteId eq cliente.id ? 'selected' : ''}>
                ${not empty cliente.nomeFantasia ? cliente.nomeFantasia : cliente.razaoSocial}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label>Destinatário *</label>
          <select name="destinatarioId" required>
            <option value="">Selecione um cliente</option>
            <c:forEach var="cliente" items="${clientes}">
              <option value="${cliente.id}" ${not empty frete.destinatarioId and frete.destinatarioId eq cliente.id ? 'selected' : ''}>
                ${not empty cliente.nomeFantasia ? cliente.nomeFantasia : cliente.razaoSocial}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label>Endereço Origem *</label>
          <select id="enderecoOrigemId" name="enderecoOrigemId" required>
            <option value="">Selecione um endereço</option>
            <c:forEach var="endereco" items="${enderecos}">
              <option value="${endereco.id}" data-codigo-ibge="${endereco.codigoIbge}" ${not empty frete.enderecoOrigemId and frete.enderecoOrigemId eq endereco.id ? 'selected' : ''}>
                ${endereco.logradouro}, ${endereco.numero} - ${endereco.municipio}/${endereco.uf}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label>Endereço Destino *</label>
          <select id="enderecoDestinoId" name="enderecoDestinoId" required>
            <option value="">Selecione um endereço</option>
            <c:forEach var="endereco" items="${enderecos}">
              <option value="${endereco.id}" data-codigo-ibge="${endereco.codigoIbge}" ${not empty frete.enderecoDestinoId and frete.enderecoDestinoId eq endereco.id ? 'selected' : ''}>
                ${endereco.logradouro}, ${endereco.numero} - ${endereco.municipio}/${endereco.uf}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label>Motorista *</label>
          <select name="motoristaId" required>
            <option value="">Selecione um motorista</option>
            <c:forEach var="motorista" items="${motoristas}">
              <option value="${motorista.id}" ${not empty frete.motoristaId and frete.motoristaId eq motorista.id ? 'selected' : ''}>
                ${motorista.nomeCompleto}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label>Veículo *</label>
          <select name="veiculoId" required>
            <option value="">Selecione um veículo</option>
            <c:forEach var="veiculo" items="${veiculos}">
              <option value="${veiculo.id}" ${not empty frete.veiculoId and frete.veiculoId eq veiculo.id ? 'selected' : ''}>
                ${veiculo.placa} - ${veiculo.tipo}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label>Chave NFe</label>
          <input type="text" id="chaveNfe" name="chaveNfe" maxlength="44" inputmode="numeric" value="${frete.chaveNfe}" />
        </div>

        <div class="form-group">
          <label>Natureza Carga *</label>
          <input type="text" name="naturezaCarga" value="${frete.naturezaCarga}" required />
        </div>

        <div class="form-group">
          <label>Peso Bruto (kg) *</label>
          <input type="number" step="0.01" min="0.01" name="pesoBruto" value="${frete.pesoBruto}" required />
        </div>

        <div class="form-group">
          <label>Volumes *</label>
          <input type="number" min="1" name="volumes" value="${frete.volumes}" required />
        </div>

        <div class="form-group">
          <label>Distância (km) *</label>
          <input type="number" step="0.01" min="0.01" name="distanciaKm" value="${frete.distanciaKm}" required />
        </div>

        <div class="form-group">
          <label>Valor Frete Bruto *</label>
          <input type="number" step="0.01" min="0.01" id="valorFreteBruto" name="valorFreteBruto" value="${frete.valorFreteBruto}" required />
        </div>

        <div class="form-group">
          <label>Valor Pedágio</label>
          <input type="number" step="0.01" min="0" id="valorPedagio" name="valorPedagio" value="${frete.valorPedagio}" />
        </div>

        <div class="form-group">
          <label>Alíquota ICMS (%)</label>
          <input type="number" step="0.01" min="0" id="aliquotaIcms" name="aliquotaIcms" value="${frete.aliquotaIcms}" />
        </div>

        <div class="form-group">
          <label>Valor ICMS</label>
          <input type="number" step="0.01" min="0" id="valorIcms" name="valorIcms" value="${frete.valorIcms}" />
        </div>

        <div class="form-group">
          <label>Valor Total *</label>
          <input type="number" step="0.01" min="0.01" id="valorTotal" name="valorTotal" value="${frete.valorTotal}" readonly style="background: #f3f4f6; color: #475467;" required />
        </div>

        <div class="form-group">
          <label>Previsão Entrega *</label>
          <input type="date" name="previsaoEntrega" min="${hoje}" value="${frete.previsaoEntrega}" required />
        </div>

        <div class="form-group">
          <label>Origem IBGE</label>
          <input type="text" id="origemIbge" name="origemIbge" maxlength="7" inputmode="numeric" value="${frete.origemIbge}" readonly style="background: #f3f4f6; color: #475467; cursor: not-allowed;" />
        </div>

        <div class="form-group">
          <label>Destino IBGE</label>
          <input type="text" id="destinoIbge" name="destinoIbge" maxlength="7" inputmode="numeric" value="${frete.destinoIbge}" readonly style="background: #f3f4f6; color: #475467; cursor: not-allowed;" />
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
