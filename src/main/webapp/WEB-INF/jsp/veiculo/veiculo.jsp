<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Veículos</title>

    <link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="/RichardFretes/css/styleC.css" />

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body class="veiculo-page">

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
            <span>Gestão de frota</span>
            <h1>Veículos</h1>
            <p>
                Consulte, cadastre e acompanhe os veículos disponíveis para as operações de transporte.
            </p>
        </div>

        <a href="veiculos?acao=novo" class="btn-primary">
            <i class="fas fa-plus"></i>
            Novo Veículo
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
                <i class="fas fa-truck-moving"></i>
            </div>

            <div>
                <span>Total de veículos</span>
                <strong>${empty veiculos ? 0 : veiculos.size()}</strong>
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon green-icon">
                <i class="fas fa-circle-check"></i>
            </div>

            <div>
                <span>Disponíveis</span>
                <strong id="totalDisponiveis">0</strong>
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon red-icon">
                <i class="fas fa-screwdriver-wrench"></i>
            </div>

            <div>
                <span>Manutenção</span>
                <strong id="totalManutencao">0</strong>
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
                        id="buscaVeiculo"
                        placeholder="Buscar por placa, tipo, combustível ou motorista"
                    />
                </div>

                <select id="filtroStatus">
                    <option value="">Todos os status</option>
                    <option value="DISPONIVEL">Disponível</option>
                    <option value="EM_VIAGEM">Em viagem</option>
                    <option value="EM_MANUTENCAO">Em manutenção</option>
                    <option value="INATIVO">Inativo</option>
                </select>

            </div>
        </div>

    </section>

    <section class="card table-card">

        <div class="table-header">
            <div>
                <span class="section-label">Registros</span>
                <h2>Veículos cadastrados</h2>
            </div>
        </div>

        <table class="data-table professional-table">
            <c:choose>
                <c:when test="${sessionScope.usuarioAutenticado.admin}">
                    <colgroup>
                        <col style="width: 18%;">
                        <col style="width: 18%;">
                        <col style="width: 15%;">
                        <col style="width: 11%;">
                        <col style="width: 15%;">
                        <col style="width: 13%;">
                        <col style="width: 10%;">
                    </colgroup>
                </c:when>
                <c:otherwise>
                    <colgroup>
                        <col style="width: 24%;">
                        <col style="width: 18%;">
                        <col style="width: 14%;">
                        <col style="width: 18%;">
                        <col style="width: 14%;">
                        <col style="width: 12%;">
                    </colgroup>
                </c:otherwise>
            </c:choose>

            <thead>
                <tr>
                    <c:if test="${sessionScope.usuarioAutenticado.admin}">
                        <th>Cliente</th>
                    </c:if>

                    <th>Veículo</th>
                    <th>Características</th>
                    <th>Capacidade</th>
                    <th>Operação</th>
                    <th class="status-column">Status</th>
                    <th class="actions-column">Ações</th>
                </tr>
            </thead>

            <tbody id="veiculosTableBody">

                <c:choose>
                    <c:when test="${not empty veiculos}">

                        <c:forEach items="${veiculos}" var="v">
                            <tr
                                class="veiculo-row"
                                data-status="${v.status}"
                                data-manutencao="${v.manutencaoPendente ? 'sim' : 'nao'}"
                                data-search="${v.placa} ${v.tipo} ${v.tipoOutros} ${v.combustivel} ${v.anoModelo} ${v.status} ${v.motorista.nomeCompleto} ${v.cliente.razaoSocial}"
                            >

                                <c:if test="${sessionScope.usuarioAutenticado.admin}">
                                    <td>
                                        <div class="entity-cell">
                                            <div class="entity-avatar">
                                                <i class="fas fa-building"></i>
                                            </div>

                                            <div class="entity-info">
                                                <strong>
                                                    <c:choose>
                                                        <c:when test="${not empty v.cliente.razaoSocial}">
                                                            ${v.cliente.razaoSocial}
                                                        </c:when>
                                                        <c:otherwise>
                                                            Sem cliente
                                                        </c:otherwise>
                                                    </c:choose>
                                                </strong>
                                                <span>Empresa vinculada</span>
                                            </div>
                                        </div>
                                    </td>
                                </c:if>

                                <td class="vehicle-main-cell">
                                    <div class="entity-cell">
                                        <div class="entity-avatar">
                                            <i class="fas fa-truck"></i>
                                        </div>
                                        <div class="entity-info">
                                            <span class="entity-label">Placa</span>
                                            <strong class="mask-placa">${v.placa}</strong>
                                            <span>
                                                RENAVAM
                                                <c:choose>
                                                    <c:when test="${not empty v.renavam}">
                                                        ${v.renavam}
                                                    </c:when>
                                                    <c:otherwise>
                                                        não informado
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>
                                </td>

                                <td>
                                    <div class="stacked-info">
                                        <small>Tipo / Ano</small>
                                        <strong>
                                            <c:choose>
                                                <c:when test="${not empty v.tipo}">
                                                    ${v.tipo}
                                                </c:when>
                                                <c:otherwise>
                                                    Não informado
                                                </c:otherwise>
                                            </c:choose>
                                        </strong>

                                        <span class="muted-line">
                                            ${v.anoFabricacao} / ${v.anoModelo}
                                            <c:if test="${not empty v.combustivel}">
                                                • ${v.combustivel}
                                            </c:if>
                                        </span>
                                    </div>
                                </td>

                                <td>
                                    <div class="stacked-info">
                                        <small>Carga máxima</small>
                                        <strong>
                                            <span class="mask-kg">${v.capacidadeCargaKg}</span> kg
                                        </strong>

                                        <span class="muted-line">
                                            Tara:
                                            <c:choose>
                                                <c:when test="${not empty v.taraKg}">
                                                    <span class="mask-kg">${v.taraKg}</span> kg
                                                </c:when>
                                                <c:otherwise>
                                                    não informada
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </td>

                                <td>
                                    <div class="stacked-info">
                                        <small>Motorista</small>

                                        <strong>
                                            <c:choose>
                                                <c:when test="${not empty v.motorista.nomeCompleto}">
                                                    ${v.motorista.nomeCompleto}
                                                </c:when>
                                                <c:otherwise>
                                                    Sem motorista
                                                </c:otherwise>
                                            </c:choose>
                                        </strong>

                                        <span class="muted-line">
                                            Seguro:
                                            <c:choose>
                                                <c:when test="${not empty v.seguroValidade}">
                                                    ${v.seguroValidade}
                                                </c:when>
                                                <c:otherwise>
                                                    não informado
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </td>

                                <td class="status-column">
                                    <div class="status-stack">

                                        <span class="badge status-badge ${v.status == 'DISPONIVEL' ? 'green' : v.status == 'EM_VIAGEM' ? 'blue' : v.status == 'EM_MANUTENCAO' ? 'orange' : 'gray'}">
                                            <i class="fas ${v.status == 'DISPONIVEL' ? 'fa-circle-check' : v.status == 'EM_VIAGEM' ? 'fa-route' : v.status == 'EM_MANUTENCAO' ? 'fa-screwdriver-wrench' : 'fa-circle-minus'}"></i>
                                            ${v.status}
                                        </span>

                                        <c:if test="${v.manutencaoPendente}">
                                            <span class="badge red status-badge">
                                                <i class="fas fa-triangle-exclamation"></i>
                                                Manutenção pendente
                                            </span>
                                        </c:if>

                                    </div>
                                </td>

                                <td class="actions-column">
                                    <div class="table-actions">

                                        <a href="veiculos?acao=editar&id=${v.id}" class="btn-small" title="Editar veículo">
                                            <i class="fas fa-pen"></i>
                                            Editar
                                        </a>

                                        <a
                                            href="veiculos?acao=deletar&id=${v.id}"
                                            class="btn-small danger"
                                            title="Excluir veículo"
                                            onclick="return confirm('Tem certeza que deseja excluir este veículo?');"
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
                            <td colspan="${sessionScope.usuarioAutenticado.admin ? 7 : 6}">
                                <div class="empty-state">
                                    <div class="empty-icon">
                                        <i class="fas fa-truck-moving"></i>
                                    </div>

                                    <h3>Nenhum veículo cadastrado</h3>
                                    <p>Cadastre o primeiro veículo para iniciar o controle da frota.</p>

                                    <a href="veiculos?acao=novo" class="btn-primary">
                                        <i class="fas fa-plus"></i>
                                        Novo Veículo
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
            <p>Tente pesquisar por outra placa, tipo, combustível, motorista ou status.</p>
        </div>

    </section>

</main>

<script src="/RichardFretes/js/funcoesVeiculo.js"></script>

</body>
</html>
