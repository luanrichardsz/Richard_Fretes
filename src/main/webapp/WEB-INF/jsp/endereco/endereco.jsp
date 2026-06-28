<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Endereços</title>

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
            <span>Gestão logística</span>
            <h1>Endereços</h1>
            <p>
                Consulte e gerencie locais de origem, destino, coleta e entrega vinculados às operações de frete.
            </p>
        </div>

        <a href="enderecos?acao=novo" class="btn-primary">
            <i class="fas fa-plus"></i>
            Novo Endereço
        </a>
    </div>

    <section class="summary-grid">

        <div class="summary-card">
            <div class="summary-icon">
                <i class="fas fa-map-location-dot"></i>
            </div>

            <div>
                <span>Total de endereços</span>
                <strong>${empty enderecos ? 0 : enderecos.size()}</strong>
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon green-icon">
                <i class="fas fa-city"></i>
            </div>

            <div>
                <span>Municípios</span>
                <strong id="totalMunicipios">0</strong>
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon">
                <i class="fas fa-location-crosshairs"></i>
            </div>

            <div>
                <span>Com referência</span>
                <strong id="totalReferencias">0</strong>
            </div>
        </div>

    </section>

    <section class="card toolbar-card">

        <div class="toolbar-row">

            <div class="filters">

                <div class="filter-field">
                    <i class="fas fa-search"></i>
                    <input
                        type="text"
                        id="buscaEndereco"
                        placeholder="Buscar por cliente, logradouro, bairro, município, UF ou CEP"
                    />
                </div>

                <select id="filtroUf">
                    <option value="">Todas as UFs</option>
                </select>

            </div>

        </div>

    </section>

    <section class="card table-card">

        <div class="table-header">
            <div>
                <span class="section-label">Registros</span>
                <h2>Endereços cadastrados</h2>
            </div>
        </div>

        <table class="data-table professional-table">
            <thead>
                <tr>
                    <c:if test="${sessionScope.usuarioAutenticado.admin}">
                        <th>Cliente</th>
                    </c:if>

                    <th>Endereço</th>
                    <th>Localização</th>
                    <th>CEP</th>
                    <th>Referência</th>
                    <th class="actions-column">Ações</th>
                </tr>
            </thead>

            <tbody id="enderecosTableBody">

                <c:choose>
                    <c:when test="${not empty enderecos}">

                        <c:forEach items="${enderecos}" var="e">
                            <tr
                                class="endereco-row"
                                data-uf="${e.uf}"
                                data-municipio="${e.municipio}"
                                data-referencia="${not empty e.pontoReferencia ? 'sim' : 'nao'}"
                                data-search="${e.clienteRazaoSocial} ${e.logradouro} ${e.numero} ${e.complemento} ${e.bairro} ${e.municipio} ${e.uf} ${e.cep} ${e.codigoIbge} ${e.pontoReferencia}"
                            >

                                <c:if test="${sessionScope.usuarioAutenticado.admin}">
                                    <td>
                                        <div class="entity-cell">
                                            <div class="entity-avatar">
                                                <i class="fas fa-building"></i>
                                            </div>

                                            <div class="entity-info">
                                                <strong>${e.clienteRazaoSocial}</strong>
                                                <span>Empresa vinculada</span>
                                            </div>
                                        </div>
                                    </td>
                                </c:if>

                                <td>
                                    <div class="entity-cell">
                                        <div class="entity-avatar">
                                            <i class="fas fa-location-dot"></i>
                                        </div>

                                        <div class="entity-info">
                                            <strong>${e.logradouro}</strong>

                                            <span>
                                                <c:choose>
                                                    <c:when test="${not empty e.numero}">
                                                        Nº ${e.numero}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Sem número
                                                    </c:otherwise>
                                                </c:choose>

                                                <c:if test="${not empty e.complemento}">
                                                    • ${e.complemento}
                                                </c:if>
                                            </span>
                                        </div>
                                    </div>
                                </td>

                                <td>
                                    <div class="stacked-info">
                                        <small>Bairro / Município</small>
                                        <strong>${e.bairro}</strong>
                                        <span class="muted-line">${e.municipio} - ${e.uf}</span>
                                    </div>
                                </td>

                                <td>
                                    <div class="stacked-info">
                                        <small>CEP</small>
                                        <strong class="mask-cep">${e.cep}</strong>

                                        <c:if test="${not empty e.codigoIbge}">
                                            <span class="muted-line">IBGE ${e.codigoIbge}</span>
                                        </c:if>
                                    </div>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${not empty e.pontoReferencia}">
                                            <div class="reference-preview" title="${e.pontoReferencia}">
                                                <i class="fas fa-circle-info"></i>
                                                <span>${e.pontoReferencia}</span>
                                            </div>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="badge gray">
                                                Sem referência
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <div class="table-actions">

                                        <a href="enderecos?acao=editar&id=${e.id}" class="btn-small" title="Editar endereço">
                                            <i class="fas fa-pen"></i>
                                            Editar
                                        </a>

                                        <a
                                            href="enderecos?acao=deletar&id=${e.id}"
                                            class="btn-small danger"
                                            title="Excluir endereço"
                                            onclick="return confirm('Tem certeza que deseja excluir este endereço?');"
                                        >
                                            <i class="fas fa-trash"></i>
                                            Excluir
                                        </a>

                                    </div>
                                </td>

                            </tr>
                        </c:forEach>

                    </c:when>

                    <c:otherwise>
                        <tr>
                            <td colspan="${sessionScope.usuarioAutenticado.admin ? 6 : 5}">
                                <div class="empty-state">
                                    <div class="empty-icon">
                                        <i class="fas fa-map-location-dot"></i>
                                    </div>

                                    <h3>Nenhum endereço cadastrado</h3>
                                    <p>Cadastre o primeiro endereço para usar como origem ou destino nos fretes.</p>

                                    <a href="enderecos?acao=novo" class="btn-primary">
                                        <i class="fas fa-plus"></i>
                                        Novo Endereço
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>

            </tbody>
        </table>

        <div class="empty-state hidden" id="emptyFilterState">
            <div class="empty-icon">
                <i class="fas fa-magnifying-glass"></i>
            </div>

            <h3>Nenhum resultado para sua busca</h3>
            <p>Tente pesquisar por outro logradouro, município, UF, CEP ou cliente.</p>
        </div>

    </section>

</main>

<script src="${pageContext.request.contextPath}/js/funcoesEndereco.js"></script>

</body>
</html>
