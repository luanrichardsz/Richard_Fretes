<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Clientes</title>

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
            <span>Gestão comercial</span>
            <h1>Clientes</h1>
            <p>
                Consulte, cadastre e gerencie as empresas vinculadas às operações de frete.
            </p>
        </div>

        <a href="clientes?acao=novo" class="btn-primary">
            <i class="fas fa-plus"></i>
            Novo Cliente
        </a>
    </div>

    <section class="summary-grid">

        <div class="summary-card">
            <div class="summary-icon">
                <i class="fas fa-building"></i>
            </div>

            <div>
                <span>Total de clientes</span>
                <strong>${empty clientes ? 0 : clientes.size()}</strong>
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon green-icon">
                <i class="fas fa-circle-check"></i>
            </div>

            <div>
                <span>Clientes ativos</span>
                <strong id="totalAtivos">0</strong>
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon red-icon">
                <i class="fas fa-circle-xmark"></i>
            </div>

            <div>
                <span>Clientes inativos</span>
                <strong id="totalInativos">0</strong>
            </div>
        </div>

    </section>

    <section class="card toolbar-card">

        <div class="toolbar-row">

            <div class="filters">

                <div class="filter-field">
                    <i class="fas fa-search"></i>
                    <input type="text" id="buscaCliente" placeholder="Buscar por razão social, CNPJ, email ou telefone" />
                </div>

                <select id="filtroStatus">
                    <option value="">Todos os status</option>
                    <option value="ativo">Ativo</option>
                    <option value="inativo">Inativo</option>
                </select>

            </div>

        </div>

    </section>

    <section class="card table-card">

        <div class="table-header">
            <div>
                <span class="section-label">Registros</span>
                <h2>Clientes cadastrados</h2>
            </div>
        </div>

        <table class="data-table professional-table">
            <thead>
                <tr>
                    <th>Cliente</th>
                    <th>Documento</th>
                    <th>Contato</th>
                    <th>Status</th>
                    <th class="actions-column">Ações</th>
                </tr>
            </thead>

            <tbody id="clientesTableBody">

                <c:choose>
                    <c:when test="${not empty clientes}">

                        <c:forEach items="${clientes}" var="c">
                            <tr
                                class="cliente-row"
                                data-status="${c.ativo ? 'ativo' : 'inativo'}"
                                data-search="${c.razaoSocial} ${c.nomeFantasia} ${c.documento} ${c.email} ${c.telefone}"
                            >

                                <td>
                                    <div class="entity-cell">
                                        <div class="entity-avatar">
                                            <i class="fas fa-building"></i>
                                        </div>

                                        <div class="entity-info">
                                            <strong>${c.razaoSocial}</strong>

                                            <c:choose>
                                                <c:when test="${not empty c.nomeFantasia}">
                                                    <span>${c.nomeFantasia}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span>Nome fantasia não informado</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </td>

                                <td>
                                    <div class="stacked-info">
                                        <small>CNPJ</small>
                                        <strong class="mask-cnpj">${c.documento}</strong>
                                    </div>
                                </td>

                                <td>
                                    <div class="contact-cell">
                                        <div>
                                            <i class="fas fa-envelope"></i>
                                            <span>${c.email}</span>
                                        </div>

                                        <div>
                                            <i class="fas fa-phone"></i>
                                            <span class="mask-phone">${c.telefone}</span>
                                        </div>
                                    </div>
                                </td>

                                <td>
                                    <span class="badge ${c.ativo ? 'green' : 'red'} status-badge">
                                        <i class="fas ${c.ativo ? 'fa-circle-check' : 'fa-circle-xmark'}"></i>
                                        ${c.ativo ? 'Ativo' : 'Inativo'}
                                    </span>
                                </td>

                                <td>
                                    <div class="table-actions">

                                        <a href="clientes?acao=editar&id=${c.id}" class="btn-small" title="Editar cliente">
                                            <i class="fas fa-pen"></i>
                                            Editar
                                        </a>

                                        <a
                                            href="clientes?acao=deletar&id=${c.id}"
                                            class="btn-small danger"
                                            title="Excluir cliente"
                                            onclick="return confirm('Tem certeza que deseja excluir este cliente?');"
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
                            <td colspan="5">
                                <div class="empty-state">
                                    <div class="empty-icon">
                                        <i class="fas fa-building-circle-xmark"></i>
                                    </div>

                                    <h3>Nenhum cliente encontrado</h3>
                                    <p>Cadastre o primeiro cliente para iniciar a gestão das operações.</p>

                                    <a href="clientes?acao=novo" class="btn-primary">
                                        <i class="fas fa-plus"></i>
                                        Novo Cliente
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
            <p>Tente pesquisar por outro nome, documento, email ou telefone.</p>
        </div>

    </section>

</main>

<script src="/RichardFretes/js/funcoesCliente.js"></script>

</body>
</html>
