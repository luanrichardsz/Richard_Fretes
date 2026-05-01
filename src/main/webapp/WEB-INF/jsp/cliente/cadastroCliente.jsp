<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>${not empty cliente.id ? 'Editar Cliente' : 'Novo Cliente'}</title>

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
    <h2>${not empty cliente.id ? 'Editar Cliente' : 'Novo Cliente'}</h2>

    <c:if test="${not empty erro}">
      <div style="margin-bottom: 15px; padding: 12px; border-radius: 8px; background: #fdecea; color: #b42318; border: 1px solid #f5c2c7;">
        ${erro}
      </div>
    </c:if>

    <form action="clientes" method="post">
      <c:if test="${not empty cliente.id}">
        <input type="hidden" name="id" value="${cliente.id}" />
      </c:if>

      <div class="form-grid">

        <div class="form-group full">
          <label>Razão Social *</label>
          <input type="text" name="razaoSocial" value="${cliente.razaoSocial}" required />
        </div>

        <div class="form-group full">
          <label>Nome Fantasia</label>
          <input type="text" name="nomeFantasia" value="${cliente.nomeFantasia}" />
        </div>

        <div class="form-group">
          <label>CNPJ *</label>
          <input type="text" id="documento" name="documento" maxlength="18" inputmode="numeric" value="${cliente.documento}" required />
        </div>

        <div class="form-group">
          <label>Inscrição Estadual (Sem Pontuação)</label>
          <input type="text" name="inscricaoEstadual" pattern="[0-9]*" oninput="this.value = this.value.replace(/[^0-9]/g, '')" maxlength="14" inputmode="numeric" value="${cliente.inscricaoEstadual}" />
        </div>

        <div class="form-group">
          <label>Email *</label>
          <input type="email" name="email" value="${cliente.email}" required />
        </div>

        <div class="form-group">
          <label>Telefone *</label>
          <input type="text" id="telefone" name="telefone" minlength="15" maxlength="15" inputmode="numeric" value="${cliente.telefone}" required />
        </div>

        <div class="form-group full">
          <label>Usuário Responsável *</label>
          <select name="usuarioId" required>
            <option value="0">Selecione um usuário</option>
            <c:forEach var="u" items="${usuarios}">
              <option value="${u.id}" ${not empty cliente.id and not empty u.clienteId and u.clienteId eq cliente.id ? 'selected' : ''}>
                ${u.usuario} (${u.email})
              </option>
            </c:forEach>
          </select>
        </div>

      </div>

      <div style="margin-top:20px;">
        <button type="submit" class="btn-primary">${not empty cliente.id ? 'Atualizar Cliente' : 'Salvar Cliente'}</button>
        <a href="clientes" class="btn-small">Cancelar</a>
      </div>

    </form>
  </section>

</div>

<script src="/RichardFretes/js/funcoesCadastroC.js"></script>

</body>
</html>
