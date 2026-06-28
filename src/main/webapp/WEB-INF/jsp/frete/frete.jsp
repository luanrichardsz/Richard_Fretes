<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Fretes</title>

    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleC.css" />

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body class="frete-page">

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
            <span>Operação logística</span>
            <h1>Fretes</h1>
            <p>
                Acompanhe emissões, situação operacional e geração de relatórios em uma visão mais clara da rotina de transporte.
            </p>
        </div>

        <a href="fretes?acao=novo" class="btn-primary">
            <i class="fas fa-plus"></i>
            Novo Frete
        </a>
    </div>

    <c:if test="${not empty erro}">
        <section class="card">
            <div class="alert alert-error">
                <i class="fas fa-circle-exclamation"></i>
                ${erro}
            </div>
        </section>
    </c:if>

    <section class="summary-grid">

        <div class="summary-card">
            <div class="summary-icon">
                <i class="fas fa-truck-fast"></i>
            </div>

            <div>
                <span>Total de fretes</span>
                <strong>${empty fretes ? 0 : fretes.size()}</strong>
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon">
                <i class="fas fa-route"></i>
            </div>

            <div>
                <span>Em operação</span>
                <strong id="totalEmOperacao">0</strong>
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon green-icon">
                <i class="fas fa-circle-check"></i>
            </div>

            <div>
                <span>Entregues</span>
                <strong id="totalEntregues">0</strong>
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
                        id="buscaFrete"
                        placeholder="Buscar por número, remetente, destinatário ou status"
                    />
                </div>

                <select id="filtroStatus">
                    <option value="">Todos os status</option>
                    <option value="EMITIDO">Emitido</option>
                    <option value="SAIDA_CONFIRMADA">Saída confirmada</option>
                    <option value="EM_TRANSITO">Em trânsito</option>
                    <option value="ENTREGUE">Entregue</option>
                    <option value="NAO_ENTREGUE">Não entregue</option>
                    <option value="CANCELADO">Cancelado</option>
                </select>

            </div>

            <div class="toolbar-actions report-actions">
                <a href="relatorios/fretes-abertos" target="_blank" class="report-link" title="Abrir filtro do relatório de fretes em aberto">
                    <div class="report-link-icon">
                        <i class="fas fa-file-lines"></i>
                    </div>

                    <div class="report-link-content">
                        <strong>Relatório de fretes</strong>
                        <small>Abrir filtro e gerar PDF</small>
                    </div>

                    <i class="fas fa-arrow-up-right-from-square report-link-arrow"></i>
                </a>

                <a href="relatorios/romaneio-carga" target="_blank" class="report-link" title="Abrir filtro do romaneio de carga">
                    <div class="report-link-icon">
                        <i class="fas fa-print"></i>
                    </div>

                    <div class="report-link-content">
                        <strong>Romaneio de carga</strong>
                        <small>Preparar impressão do romaneio</small>
                    </div>

                    <i class="fas fa-arrow-up-right-from-square report-link-arrow"></i>
                </a>
            </div>
        </div>

    </section>

    <section class="card table-card">

        <div class="table-header">
            <div>
                <span class="section-label">Registros</span>
                <h2>Fretes cadastrados</h2>
            </div>
        </div>

        <table class="data-table professional-table">
            <thead>
                <tr>
                    <th>Frete</th>
                    <th>Remetente</th>
                    <th>Destinatário</th>
                    <th class="status-column">Status</th>
                    <th>Valor total</th>
                    <th>Emissão</th>
                    <th class="actions-column">Ações</th>
                </tr>
            </thead>

            <tbody id="fretesTableBody">
                <c:choose>
                    <c:when test="${not empty fretes}">
                        <c:forEach items="${fretes}" var="f">
                            <c:set
                                var="statusClass"
                                value="${f.status == 'ENTREGUE' ? 'green' :
                                    f.status == 'EM_TRANSITO' ? 'blue' :
                                    f.status == 'SAIDA_CONFIRMADA' ? 'orange' :
                                    f.status == 'EMITIDO' ? 'gray' : 'red'}"
                            />
                            <c:set
                                var="statusIcon"
                                value="${f.status == 'ENTREGUE' ? 'fa-circle-check' :
                                    f.status == 'EM_TRANSITO' ? 'fa-route' :
                                    f.status == 'SAIDA_CONFIRMADA' ? 'fa-truck' :
                                    f.status == 'EMITIDO' ? 'fa-file-signature' :
                                    f.status == 'CANCELADO' ? 'fa-ban' : 'fa-triangle-exclamation'}"
                            />
                            <c:set
                                var="statusLabel"
                                value="${f.status == 'ENTREGUE' ? 'Entregue' :
                                    f.status == 'EM_TRANSITO' ? 'Em trânsito' :
                                    f.status == 'SAIDA_CONFIRMADA' ? 'Saída confirmada' :
                                    f.status == 'EMITIDO' ? 'Emitido' :
                                    f.status == 'NAO_ENTREGUE' ? 'Não entregue' : 'Cancelado'}"
                            />
                            <tr
                                class="frete-row"
                                data-status="${f.status}"
                                data-search="${f.numeroFrete} ${clientesPorId[f.remetenteId]} ${clientesPorId[f.destinatarioId]} ${f.status} ${f.remetenteId} ${f.destinatarioId}"
                            >
                                <td>
                                    <div class="entity-cell">
                                        <div class="entity-avatar">
                                            <i class="fas fa-file-invoice-dollar"></i>
                                        </div>

                                        <div class="entity-info">
                                            <strong>${f.numeroFrete}</strong>
                                            <span>Registro #${f.id}</span>
                                        </div>
                                    </div>
                                </td>

                                <td>
                                    <div class="stacked-info">
                                        <small>Empresa remetente</small>
                                        <strong>
                                            <c:choose>
                                                <c:when test="${not empty clientesPorId[f.remetenteId]}">
                                                    ${clientesPorId[f.remetenteId]}
                                                </c:when>
                                                <c:otherwise>
                                                    Cliente não identificado
                                                </c:otherwise>
                                            </c:choose>
                                        </strong>
                                        <span class="muted-line">Código ${f.remetenteId}</span>
                                    </div>
                                </td>

                                <td>
                                    <div class="stacked-info">
                                        <small>Empresa destinatária</small>
                                        <strong>
                                            <c:choose>
                                                <c:when test="${not empty clientesPorId[f.destinatarioId]}">
                                                    ${clientesPorId[f.destinatarioId]}
                                                </c:when>
                                                <c:otherwise>
                                                    Cliente não identificado
                                                </c:otherwise>
                                            </c:choose>
                                        </strong>
                                        <span class="muted-line">Código ${f.destinatarioId}</span>
                                    </div>
                                </td>

                                <td class="status-column">
                                    <div class="status-stack">
                                        <span class="badge status-badge ${statusClass}">
                                            <i class="fas ${statusIcon}"></i>
                                            ${statusLabel}
                                        </span>
                                    </div>
                                </td>

                                <td>
                                    <div class="stacked-info">
                                        <small>Valor faturado</small>
                                        <strong>
                                            R$
                                            <fmt:formatNumber value="${f.valorTotal}" minFractionDigits="2" maxFractionDigits="2"/>
                                        </strong>
                                    </div>
                                </td>

                                <td>
                                    <div class="date-time-cell mask-datetime" data-iso="${f.dataEmissao}">
                                        <strong class="date-primary">${f.dataEmissao}</strong>
                                        <span class="date-secondary">Data e hora local</span>
                                    </div>
                                </td>

                                <td class="actions-column">
                                    <div class="table-actions">

                                        <a href="fretes?acao=detalhes&id=${f.id}" class="btn-small" title="Ver detalhes do frete">
                                            <i class="fas fa-eye"></i>
                                            Detalhes
                                        </a>

                                        <c:if test="${f.status == 'EMITIDO'}">
                                            <a href="fretes?acao=editar&id=${f.id}" class="btn-small" title="Editar frete">
                                                <i class="fas fa-pen"></i>
                                                Editar
                                            </a>
                                        </c:if>

                                        <a
                                            href="fretes?acao=deletar&id=${f.id}"
                                            class="btn-small danger"
                                            title="Excluir frete"
                                            onclick="return confirm('Tem certeza que deseja excluir este frete?');"
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
                            <td colspan="7">
                                <div class="empty-state">
                                    <div class="empty-icon">
                                        <i class="fas fa-truck"></i>
                                    </div>

                                    <h3>Nenhum frete encontrado</h3>
                                    <p>Cadastre o primeiro frete para começar a acompanhar a operação logística.</p>

                                    <a href="fretes?acao=novo" class="btn-primary">
                                        <i class="fas fa-plus"></i>
                                        Novo Frete
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
            <p>Tente pesquisar por outro número de frete, remetente, destinatário ou status.</p>
        </div>

    </section>

</main>

<script src="${pageContext.request.contextPath}/js/funcoesFrete.js"></script>

</body>
</html>
