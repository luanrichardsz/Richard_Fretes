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

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>

<header class="top-header">
    <a href="menu" class="logo-btn" title="Voltar" onclick="if (window.history.length > 1) { window.history.back(); return false; }">
        <i class="fas fa-arrow-left"></i>
    </a>
    <a href="menu" class="logo-btn" title="Voltar ao menu">
        <i class="fas fa-home"></i>
    </a>
</header>

<main class="container">

    <div class="page-heading">
        <div>
            <span>Cadastro de cliente</span>

            <h1>
                ${not empty cliente.id ? 'Editar Cliente' : 'Novo Cliente'}
            </h1>

            <p>
                Preencha os dados comerciais, fiscais e de contato da empresa que será vinculada às operações de frete.
            </p>
        </div>
    </div>

    <section class="card">

        <c:if test="${not empty erro}">
            <div class="alert alert-error">
                <i class="fas fa-circle-exclamation"></i>
                ${erro}
            </div>
        </c:if>

        <form action="clientes" method="post">

            <c:if test="${not empty cliente.id}">
                <input type="hidden" name="id" value="${cliente.id}" />
            </c:if>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-building"></i>
                    </div>

                    <div>
                        <h3>Identificação da empresa</h3>
                        <p>Dados principais usados para reconhecer o cliente no sistema.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group full">
                        <label>Razão Social <span class="required">*</span></label>
                        <input
                            type="text"
                            name="razaoSocial"
                            value="${cliente.razaoSocial}"
                            placeholder="Ex: Richard Transportes LTDA"
                            required
                        />
                    </div>

                    <div class="form-group full">
                        <label>Nome Fantasia</label>
                        <input
                            type="text"
                            name="nomeFantasia"
                            value="${cliente.nomeFantasia}"
                            placeholder="Ex: Richard Fretes"
                        />
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-file-invoice"></i>
                    </div>

                    <div>
                        <h3>Dados fiscais</h3>
                        <p>Informações usadas para identificação fiscal e emissão de documentos.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group">
                        <label>CNPJ <span class="required">*</span></label>
                        <input
                            type="text"
                            id="documento"
                            name="documento"
                            maxlength="18"
                            inputmode="numeric"
                            value="${cliente.documento}"
                            placeholder="00.000.000/0000-00"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Inscrição Estadual</label>
                        <input
                            type="text"
                            name="inscricaoEstadual"
                            pattern="[0-9]*"
                            oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                            maxlength="14"
                            inputmode="numeric"
                            value="${cliente.inscricaoEstadual}"
                            placeholder="Somente números"
                        />
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-address-book"></i>
                    </div>

                    <div>
                        <h3>Contato</h3>
                        <p>Dados de comunicação com o cliente responsável pela operação.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group">
                        <label>Email <span class="required">*</span></label>
                        <input
                            type="email"
                            name="email"
                            value="${cliente.email}"
                            placeholder="empresa@email.com"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Telefone <span class="required">*</span></label>
                        <input
                            type="text"
                            id="telefone"
                            name="telefone"
                            minlength="14"
                            maxlength="15"
                            inputmode="numeric"
                            value="${cliente.telefone}"
                            placeholder="(81) 99999-9999"
                            required
                        />
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-user-shield"></i>
                    </div>

                    <div>
                        <h3>Usuário responsável</h3>
                        <p>Selecione o usuário que ficará vinculado a este cliente.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group full">
                        <label>Usuário Responsável <span class="required">*</span></label>

                        <select name="usuarioId" required>
                            <option value="0">Selecione um usuário</option>

                            <c:forEach var="u" items="${usuarios}">
                                <option
                                    value="${u.id}"
                                    ${not empty cliente.id and not empty u.clienteId and u.clienteId eq cliente.id ? 'selected' : ''}
                                >
                                    ${u.usuario} (${u.email})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                </div>

            </div>

            <div class="form-actions">
                <a href="clientes" class="btn-small">
                    <i class="fas fa-arrow-left"></i>
                    Cancelar
                </a>

                <button type="submit" class="btn-primary">
                    <i class="fas fa-save"></i>
                    ${not empty cliente.id ? 'Atualizar Cliente' : 'Salvar Cliente'}
                </button>
            </div>

        </form>

    </section>

</main>

<script src="/RichardFretes/js/funcoesCadastroC.js"></script>

</body>
</html>
