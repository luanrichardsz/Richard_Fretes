<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Motoristas</title>

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
            <span>Gestão de equipe</span>
            <h1>Motoristas</h1>
            <p>
                Consulte, cadastre e acompanhe condutores, documentos, CNH, telefone, vínculo e situação operacional.
            </p>
        </div>

        <a href="motoristas?acao=novo" class="btn-primary">
            <i class="fas fa-plus"></i>
            Novo Motorista
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
                <i class="fas fa-id-card"></i>
            </div>

            <div>
                <span>Total de motoristas</span>
                <strong>${empty motoristas ? 0 : motoristas.size()}</strong>
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon green-icon">
                <i class="fas fa-circle-check"></i>
            </div>

            <div>
                <span>Motoristas ativos</span>
                <strong id="totalAtivos">0</strong>
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon red-icon">
                <i class="fas fa-triangle-exclamation"></i>
            </div>

            <div>
                <span>CNH vencida</span>
                <strong id="totalCnhVencida">0</strong>
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
                        id="buscaMotorista"
                        placeholder="Buscar por nome, CPF, CNH, telefone ou categoria"
                    />
                </div>

                <select id="filtroStatus">
                    <option value="">Todos os status</option>
                    <option value="ATIVO">Ativo</option>
                    <option value="INATIVO">Inativo</option>
                    <option value="SUSPENSO">Suspenso</option>
                </select>

                <select id="filtroCnh">
                    <option value="">Todas as CNHs</option>
                    <option value="vencida">CNH vencida</option>
                    <option value="regular">CNH regular</option>
                </select>

            </div>
        </div>

    </section>

    <section class="card table-card">

        <div class="table-header">
            <div>
                <span class="section-label">Registros</span>
                <h2>Motoristas cadastrados</h2>
            </div>
        </div>

        <table class="data-table professional-table">
            <thead>
                <tr>
                    <th>Motorista</th>
                    <th>Documentos</th>
                    <th>CNH</th>
                    <th>Contato</th>
                    <th>Status</th>
                    <th class="actions-column">Ações</th>
                </tr>
            </thead>

            <tbody id="motoristasTableBody">

                <c:choose>
                    <c:when test="${not empty motoristas}">

                        <c:forEach items="${motoristas}" var="m">
                            <tr
                                class="motorista-row"
                                data-status="${m.status}"
                                data-cnh="${m.cnhVencida ? 'vencida' : 'regular'}"
                                data-search="${m.nomeCompleto} ${m.cpf} ${m.rg} ${m.numeroCnh} ${m.categoriaCnh} ${m.telefone} ${m.status}"
                            >

                                <td>
                                    <div class="entity-cell">
                                        <div class="entity-avatar">
                                            <i class="fas fa-user-tie"></i>
                                        </div>

                                        <div class="entity-info">
                                            <strong>${m.nomeCompleto}</strong>

                                            <span>
                                                <c:choose>
                                                    <c:when test="${not empty m.tipoVinculo}">
                                                        ${m.tipoVinculo}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Vínculo não informado
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>
                                </td>

                                <td>
                                    <div class="stacked-info">
                                        <small>CPF</small>
                                        <strong class="mask-cpf">${m.cpf}</strong>

                                        <span class="muted-line">
                                            RG:
                                            <c:choose>
                                                <c:when test="${not empty m.rg}">
                                                    ${m.rg}
                                                </c:when>
                                                <c:otherwise>
                                                    não informado
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </td>

                                <td>
                                    <div class="stacked-info">
                                        <small>CNH / Categoria</small>
                                        <strong>${m.numeroCnh}</strong>

                                        <span class="muted-line">
                                            Categoria ${m.categoriaCnh}
                                        </span>

                                        <div style="margin-top: 8px;">
                                            <span class="badge ${m.cnhVencida ? 'red' : 'green'} status-badge">
                                                <i class="fas ${m.cnhVencida ? 'fa-triangle-exclamation' : 'fa-circle-check'}"></i>
                                                ${m.cnhVencida ? 'CNH vencida' : 'CNH regular'}
                                            </span>
                                        </div>
                                    </div>
                                </td>

                                <td>
                                    <div class="contact-cell">
                                        <div>
                                            <i class="fas fa-phone"></i>
                                            <span class="mask-phone">${m.telefone}</span>
                                        </div>

                                        <div>
                                            <i class="fas fa-calendar"></i>
                                            <span>
                                                Nasc.:
                                                <c:choose>
                                                    <c:when test="${not empty m.dataNascimento}">
                                                        ${m.dataNascimento}
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
                                    <div class="status-stack">

                                        <span class="badge status-badge ${m.status == 'ATIVO' ? 'green' : m.status == 'SUSPENSO' ? 'red' : 'gray'}">
                                            <i class="fas ${m.status == 'ATIVO' ? 'fa-circle-check' : m.status == 'SUSPENSO' ? 'fa-ban' : 'fa-circle-minus'}"></i>
                                            ${m.status}
                                        </span>

                                        <c:if test="${m.cnhVencida}">
                                            <span class="badge red status-badge">
                                                <i class="fas fa-id-card"></i>
                                                Bloqueio documental
                                            </span>
                                        </c:if>

                                    </div>
                                </td>

                                <td>
                                    <div class="table-actions">

                                        <a href="motoristas?acao=editar&id=${m.id}" class="btn-small" title="Editar motorista">
                                            <i class="fas fa-pen"></i>
                                            Editar
                                        </a>

                                        <a
                                            href="motoristas?acao=deletar&id=${m.id}"
                                            class="btn-small danger"
                                            title="Excluir motorista"
                                            onclick="return confirm('Tem certeza que deseja excluir este motorista?');"
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
                            <td colspan="6">
                                <div class="empty-state">
                                    <div class="empty-icon">
                                        <i class="fas fa-user-tie"></i>
                                    </div>

                                    <h3>Nenhum motorista cadastrado</h3>
                                    <p>Cadastre o primeiro motorista para iniciar o controle da equipe de transporte.</p>

                                    <a href="motoristas?acao=novo" class="btn-primary">
                                        <i class="fas fa-plus"></i>
                                        Novo Motorista
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
            <p>Tente pesquisar por outro nome, CPF, CNH, telefone, categoria ou status.</p>
        </div>

    </section>

</main>

<script src="funcoesMotorista.js"></script>

</body>
</html>
