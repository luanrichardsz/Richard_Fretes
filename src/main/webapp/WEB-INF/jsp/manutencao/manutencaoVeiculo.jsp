<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manutenções de Veículos</title>

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

    <c:url var="urlNovaManutencao" value="manutencoes">
        <c:param name="acao" value="novo" />
        <c:if test="${not empty veiculoSelecionado}">
            <c:param name="veiculoId" value="${veiculoSelecionado.id}" />
        </c:if>
    </c:url>

    <div class="page-heading">
        <div>
            <span>Manutenção de frota</span>
            <h1>Manutenções</h1>
            <p>
                <c:choose>
                    <c:when test="${not empty veiculoSelecionado}">
                        Histórico, alertas e agenda de manutenção do veículo ${veiculoSelecionado.placa}.
                    </c:when>
                    <c:otherwise>
                        Acompanhe manutenções preventivas e corretivas da frota com histórico e controle operacional.
                    </c:otherwise>
                </c:choose>
            </p>
        </div>

        <a href="${urlNovaManutencao}" class="btn-primary">
            <i class="fas fa-plus"></i>
            Nova Manutenção
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

    <c:if test="${not empty veiculoSelecionado}">
        <section class="card">
            <div class="table-header">
                <div>
                    <span class="section-label">Veículo em foco</span>
                    <h2>${veiculoSelecionado.placa} - ${veiculoSelecionado.tipo}</h2>
                </div>
                <a href="veiculos?acao=editar&id=${veiculoSelecionado.id}" class="btn-small">
                    <i class="fas fa-truck"></i>
                    Abrir Veículo
                </a>
            </div>
        </section>
    </c:if>

    <section class="summary-grid">
        <div class="summary-card">
            <div class="summary-icon">
                <i class="fas fa-screwdriver-wrench"></i>
            </div>
            <div>
                <span>Total de registros</span>
                <strong>${empty manutencoes ? 0 : manutencoes.size()}</strong>
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon green-icon">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div>
                <span>Concluídas</span>
                <strong>
                    <c:set var="totalConcluidas" value="0" />
                    <c:forEach items="${manutencoes}" var="m">
                        <c:if test="${m.status == 'CONCLUIDA'}">
                            <c:set var="totalConcluidas" value="${totalConcluidas + 1}" />
                        </c:if>
                    </c:forEach>
                    ${totalConcluidas}
                </strong>
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon red-icon">
                <i class="fas fa-triangle-exclamation"></i>
            </div>
            <div>
                <span>Pendentes</span>
                <strong>
                    <c:set var="totalPendentes" value="0" />
                    <c:forEach items="${manutencoes}" var="m">
                        <c:if test="${m.status == 'AGENDADA' || m.status == 'EM_ANDAMENTO'}">
                            <c:set var="totalPendentes" value="${totalPendentes + 1}" />
                        </c:if>
                    </c:forEach>
                    ${totalPendentes}
                </strong>
            </div>
        </div>
    </section>

    <section class="card toolbar-card">
        <div class="toolbar-row">
            <div class="filters">
                <div>
                    <span class="section-label">Relatorios</span>
                    <h2>Exportar manutencoes em PDF</h2>
                    <p>Gere o relatorio dos veiculos em manutencao com todos os status ou filtre a situacao desejada.</p>
                </div>
            </div>

            <div class="toolbar-actions report-actions">
                <a href="relatorios/manutencoes-veiculos" target="_blank" class="report-link" title="Abrir filtro do relatorio de manutencoes de veiculos">
                    <div class="report-link-icon">
                        <i class="fas fa-file-pdf"></i>
                    </div>

                    <div class="report-link-content">
                        <strong>Relatorio de manutencoes</strong>
                        <small>Abrir filtro e gerar PDF</small>
                    </div>

                    <i class="fas fa-arrow-up-right-from-square report-link-arrow"></i>
                </a>
            </div>
        </div>
    </section>

    <section class="card table-card">
        <div class="table-header">
            <div>
                <span class="section-label">Agenda</span>
                <h2>Manutenções registradas</h2>
            </div>
        </div>

        <table class="data-table professional-table">
            <thead>
            <tr>
                <th>Veículo</th>
                <th>Tipo</th>
                <th>Status</th>
                <th>Descrição</th>
                <th>Data prevista</th>
                <th class="actions-column">Ações</th>
            </tr>
            </thead>

            <tbody>
            <c:choose>
                <c:when test="${not empty manutencoes}">
                    <c:forEach items="${manutencoes}" var="m">
                        <tr>
                            <td>
                                <div class="entity-cell">
                                    <div class="entity-avatar">
                                        <i class="fas fa-truck"></i>
                                    </div>
                                    <div class="entity-info">
                                        <strong>${m.veiculo.placa}</strong>
                                        <span>${m.veiculo.tipo}</span>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="badge ${m.tipo == 'PREVENTIVA' ? 'blue' : 'orange'}">${m.tipo}</span>
                            </td>
                            <td>
                                <span class="badge ${m.status == 'CONCLUIDA' ? 'green' : m.status == 'EM_ANDAMENTO' ? 'orange' : m.status == 'CANCELADA' ? 'gray' : 'red'}">${m.status}</span>
                            </td>
                            <td>
                                <div class="stacked-info">
                                    <strong>${m.descricao}</strong>
                                    <c:if test="${not empty m.fornecedorOficina}">
                                        <span class="muted-line">${m.fornecedorOficina}</span>
                                    </c:if>
                                </div>
                            </td>
                            <td>
                                <div class="stacked-info">
                                    <strong>${m.dataPrevista}</strong>
                                    <c:if test="${not empty m.dataRealizacao}">
                                        <span class="muted-line">Realizada em ${m.dataRealizacao}</span>
                                    </c:if>
                                </div>
                            </td>
                            <td class="actions-column">
                                <div class="table-actions">
                                    <a href="manutencoes?acao=editar&id=${m.id}" class="btn-small">
                                        <i class="fas fa-pen"></i>
                                        Editar
                                    </a>
                                    <a href="manutencoes?acao=deletar&id=${m.id}" class="btn-small danger" onclick="return confirm('Tem certeza que deseja excluir esta manutenção?');">
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
                        <td colspan="6">
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-screwdriver-wrench"></i>
                                </div>
                                <h3>Nenhuma manutenção cadastrada</h3>
                                <p>Crie o primeiro registro para começar a acompanhar preventivas e corretivas da frota.</p>
                                <a href="${urlNovaManutencao}" class="btn-primary">
                                    <i class="fas fa-plus"></i>
                                    Nova Manutenção
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </section>

</main>

</body>
</html>
