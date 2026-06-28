<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>${not empty endereco.id ? 'Editar Endereço' : 'Novo Endereço'}</title>

    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleC.css" />

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
            <span>Cadastro de endereço</span>

            <h1>
                ${not empty endereco.id ? 'Editar Endereço' : 'Novo Endereço'}
            </h1>

            <p>
                Cadastre os locais de origem, destino e referência que serão usados nas operações de frete.
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

        <form action="enderecos" method="post">

            <c:if test="${not empty endereco.id}">
                <input type="hidden" name="id" value="${endereco.id}" />
            </c:if>

            <c:if test="${sessionScope.usuarioAutenticado.admin}">
                <div class="form-section">

                    <div class="form-section-header">
                        <div class="form-section-icon">
                            <i class="fas fa-building"></i>
                        </div>

                        <div>
                            <h3>Vínculo do endereço</h3>
                            <p>Selecione a empresa responsável por este endereço.</p>
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group full">
                            <label>Empresa Selecionada <span class="required">*</span></label>

                            <select name="clienteId" required>
                                <option value="">Selecione uma empresa</option>

                                <c:forEach var="cliente" items="${clientes}">
                                    <option
                                        value="${cliente.id}"
                                        ${not empty endereco.clienteId and endereco.clienteId eq cliente.id ? 'selected' : ''}
                                    >
                                        ${cliente.razaoSocial}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                </div>
            </c:if>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-magnifying-glass-location"></i>
                    </div>

                    <div>
                        <h3>Consulta por CEP</h3>
                        <p>Informe o CEP para facilitar o preenchimento dos dados de localização.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group">
                        <label>CEP <span class="required">*</span></label>

                        <input
                            type="text"
                            id="cep"
                            name="cep"
                            maxlength="9"
                            inputmode="numeric"
                            value="${endereco.cep}"
                            placeholder="00000-000"
                            required
                        />

                        <small id="cepMensagem" class="field-hint"></small>
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-map-location-dot"></i>
                    </div>

                    <div>
                        <h3>Localização</h3>
                        <p>Dados principais do endereço usado na operação logística.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group full">
                        <label>Logradouro <span class="required">*</span></label>

                        <input
                            type="text"
                            id="logradouro"
                            name="logradouro"
                            value="${endereco.logradouro}"
                            placeholder="Rua, avenida, rodovia ou estrada"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Número</label>

                        <input
                            type="text"
                            name="numero"
                            value="${endereco.numero}"
                            placeholder="Ex: 1200"
                        />
                    </div>

                    <div class="form-group">
                        <label>Complemento</label>

                        <input
                            type="text"
                            name="complemento"
                            value="${endereco.complemento}"
                            placeholder="Sala, galpão, bloco, lote..."
                        />
                    </div>

                    <div class="form-group">
                        <label>Bairro <span class="required">*</span></label>

                        <input
                            type="text"
                            id="bairro"
                            name="bairro"
                            value="${endereco.bairro}"
                            placeholder="Informe o bairro"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Município <span class="required">*</span></label>

                        <input
                            type="text"
                            id="municipio"
                            name="municipio"
                            value="${endereco.municipio}"
                            placeholder="Informe o município"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>UF <span class="required">*</span></label>

                        <input
                            type="text"
                            id="uf"
                            name="uf"
                            value="${endereco.uf}"
                            maxlength="2"
                            placeholder="PE"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Código IBGE</label>

                        <input
                            type="text"
                            id="codigoIbge"
                            name="codigoIbge"
                            maxlength="7"
                            inputmode="numeric"
                            value="${endereco.codigoIbge}"
                            placeholder="Ex: 2611606"
                        />
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-location-crosshairs"></i>
                    </div>

                    <div>
                        <h3>Referência operacional</h3>
                        <p>Informações extras para ajudar motorista, coleta ou entrega.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group full">
                        <label>Ponto de Referência</label>

                        <textarea
                            name="pontoReferencia"
                            rows="3"
                            placeholder="Ex: Próximo ao posto, entrada lateral, portaria de cargas..."
                        >${endereco.pontoReferencia}</textarea>
                    </div>

                </div>

            </div>

            <div class="form-actions">
                <a href="enderecos" class="btn-small">
                    <i class="fas fa-arrow-left"></i>
                    Cancelar
                </a>

                <button type="submit" class="btn-primary">
                    <i class="fas fa-save"></i>
                    ${not empty endereco.id ? 'Atualizar Endereço' : 'Salvar Endereço'}
                </button>
            </div>

        </form>

    </section>

</main>

<script src="${pageContext.request.contextPath}/js/funcoesCadastroE.js"></script>

</body>
</html>
