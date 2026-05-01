<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>${not empty motorista.id ? 'Editar Motorista' : 'Novo Motorista'}</title>

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
.section-title {
  grid-column: span 2;
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
    <h2>${not empty motorista.id ? 'Editar Motorista' : 'Novo Motorista'}</h2>

    <c:if test="${not empty erro}">
      <div style="margin-bottom: 15px; padding: 12px; border-radius: 8px; background: #fdecea; color: #b42318; border: 1px solid #f5c2c7;">
        ${erro}
      </div>
    </c:if>

    <form action="motoristas" method="post">
      <c:if test="${not empty motorista.id}">
        <input type="hidden" name="id" value="${motorista.id}" />
      </c:if>

      <div class="form-grid">

        <div class="section-title">Dados Pessoais</div>

        <div class="form-group full">
          <label>Nome Completo *</label>
          <input type="text" name="nomeCompleto" value="${motorista.nomeCompleto}" required />
        </div>

        <div class="form-group">
          <label>CPF *</label>
          <input type="text" id="cpf" name="cpf" maxlength="14" inputmode="numeric" value="${motorista.cpf}" required />
        </div>

        <div class="form-group">
          <label>RG *</label>
          <input type="text" id="rg" name="rg" maxlength="12" inputmode="numeric" value="${motorista.rg}" required />
        </div>

        <div class="form-group">
          <label>Data Nascimento *</label>
          <input type="date" id="dataNascimento" name="dataNascimento" max="${hoje}" value="${motorista.dataNascimento}" required />
        </div>

        <div class="form-group">
          <label>Telefone *</label>
          <input type="tel" id="telefone" name="telefone" maxlength="15" inputmode="numeric" value="${motorista.telefone}" required />
        </div>

        <c:if test="${sessionScope.usuarioAutenticado.admin}">
          <div class="form-group">
            <label>Empresa Selecionada *</label>
            <select name="clienteId" required>
              <option value="">Selecione uma empresa</option>
              <c:forEach var="cliente" items="${clientes}">
                <option value="${cliente.id}" ${not empty motorista.clienteId and motorista.clienteId eq cliente.id ? 'selected' : ''}>
                  ${cliente.razaoSocial}
                </option>
              </c:forEach>
            </select>
          </div>
        </c:if>

        <div class="section-title">Contato de Emergência</div>

        <div class="form-group full">
          <label>Nome da Pessoa</label>
          <input type="text" name="nomeEmergencia" value="${motorista.nomeEmergencia}" />
        </div>

        <div class="form-group">
          <label>Telefone</label>
          <input type="tel" id="telefoneEmergencia" name="telefoneEmergencia" maxlength="15" inputmode="numeric" value="${motorista.telefoneEmergencia}" />
        </div>

        <div class="form-group">
          <label>Parentesco</label>
          <input type="text" name="parentescoEmergencia" value="${motorista.parentescoEmergencia}" />
        </div>

        <div class="section-title">Carteira de Habilitação</div>

        <div class="form-group">
          <label>Número CNH *</label>
          <input type="text" id="numeroCnh" name="numeroCnh" maxlength="11" inputmode="numeric" value="${motorista.numeroCnh}" required />
        </div>

        <div class="form-group">
          <label>Categoria *</label>
          <select name="categoriaCnh" required>
            <option value="">Selecione</option>
            <c:forEach var="cat" items="${categoriaCnhOptions}">
              <option value="${cat}" ${motorista.categoriaCnh eq cat ? 'selected' : ''}>${cat}</option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label>Validade CNH *</label>
          <input type="date" name="validadeCnh" value="${motorista.validadeCnh}" required />
        </div>

        <div class="form-group">
          <label>Validade Toxicológico</label>
          <input type="date" name="validadeToxicologico" value="${motorista.validadeToxicologico}" />
        </div>

        <div class="section-title">Informações Financeiras</div>

        <div class="form-group">
          <label>Tipo Vínculo *</label>
          <select name="tipoVinculo" required>
            <option value="">Selecione</option>
            <c:forEach var="tipo" items="${tipoVinculoOptions}">
              <option value="${tipo}" ${motorista.tipoVinculo eq tipo ? 'selected' : ''}>${tipo}</option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group">
          <label>Tipo PIX *</label>
          <select id="tipoPix" name="tipoPix" required>
            <option value="">Selecione</option>
            <c:forEach var="tipo" items="${tipoPixOptions}">
              <option value="${tipo}" ${motorista.tipoPix eq tipo ? 'selected' : ''}>${tipo}</option>
            </c:forEach>
          </select>
        </div>

        <div class="form-group full">
          <label>Chave PIX *</label>
          <input type="text" id="chavePix" name="chavePix" value="${motorista.chavePix}" required />
        </div>

        <div class="form-group">
          <label>Status *</label>
          <select name="status" required>
            <option value="">Selecione</option>
            <c:forEach var="status" items="${statusMotoristaOptions}">
              <option value="${status}" ${motorista.status eq status ? 'selected' : ''}>${status}</option>
            </c:forEach>
          </select>
        </div>

      </div>

      <div style="margin-top: 20px; display: flex; gap: 10px;">
        <button type="submit" class="btn-primary">Salvar</button>
        <a href="motoristas"><button type="button" class="btn-secondary">Cancelar</button></a>
      </div>

    </form>

  </section>

</div>

<script src="/RichardFretes/js/funcoesCadastroM.js"></script>
</body>
</html>
