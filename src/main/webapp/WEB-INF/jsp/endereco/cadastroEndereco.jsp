<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>${not empty endereco.id ? 'Editar Endereço' : 'Novo Endereço'}</title>

<link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
<link rel="stylesheet" href="/RichardFretes/css/styleC.css" />
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
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
    <h2>${not empty endereco.id ? 'Editar Endereço' : 'Novo Endereço'}</h2>

    <c:if test="${not empty erro}">
      <div style="margin-bottom: 15px; padding: 12px; border-radius: 8px; background: #fdecea; color: #b42318; border: 1px solid #f5c2c7;">
        ${erro}
      </div>
    </c:if>

    <form action="enderecos" method="post">
      <c:if test="${not empty endereco.id}">
        <input type="hidden" name="id" value="${endereco.id}" />
      </c:if>

      <div class="form-grid">

        <c:if test="${sessionScope.usuarioAutenticado.admin}">
          <div class="form-group">
            <label>Empresa Selecionada *</label>
            <select name="clienteId" required>
              <option value="">Selecione uma empresa</option>
              <c:forEach var="cliente" items="${clientes}">
                <option value="${cliente.id}" ${not empty endereco.clienteId and endereco.clienteId eq cliente.id ? 'selected' : ''}>
                  ${cliente.razaoSocial}
                </option>
              </c:forEach>
            </select>
          </div>
        </c:if>

        <div class="form-group">
          <label>CEP *</label>
          <input type="text" id="cep" name="cep" maxlength="9" inputmode="numeric" value="${endereco.cep}" required />
          <small id="cepMensagem" style="margin-top: 6px; color: #667085;"></small>
        </div>

        <div class="form-group full">
          <label>Logradouro *</label>
          <input type="text" id="logradouro" name="logradouro" value="${endereco.logradouro}" required />
        </div>

        <div class="form-group">
          <label>Número</label>
          <input type="text" name="numero" value="${endereco.numero}" />
        </div>

        <div class="form-group">
          <label>Complemento</label>
          <input type="text" name="complemento" value="${endereco.complemento}" />
        </div>

        <div class="form-group">
          <label>Bairro *</label>
          <input type="text" id="bairro" name="bairro" value="${endereco.bairro}" required />
        </div>

        <div class="form-group">
          <label>Município *</label>
          <input type="text" id="municipio" name="municipio" value="${endereco.municipio}" required />
        </div>

        <div class="form-group">
          <label>Código IBGE</label>
          <input type="text" id="codigoIbge" name="codigoIbge" maxlength="7" inputmode="numeric" value="${endereco.codigoIbge}" />
        </div>

        <div class="form-group">
          <label>UF *</label>
          <input type="text" id="uf" name="uf" value="${endereco.uf}" maxlength="2" required />
        </div>

        <div class="form-group full">
          <label>Ponto de Referência</label>
          <textarea name="pontoReferencia" rows="3">${endereco.pontoReferencia}</textarea>
        </div>

      </div>

      <div style="margin-top: 20px; display: flex; gap: 10px;">
        <button type="submit" class="btn-primary">Salvar</button>
        <a href="enderecos"><button type="button" class="btn-secondary">Cancelar</button></a>
      </div>

    </form>

  </section>

</div>

<script src="/RichardFretes/js/funcoesCadastroE.js"></script>

</body>
</html>
