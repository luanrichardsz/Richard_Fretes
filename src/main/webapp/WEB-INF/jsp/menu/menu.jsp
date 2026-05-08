<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Painel</title>

    <link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="/RichardFretes/css/styleMenu.css" />

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>

<div class="app-shell">

    <aside class="sidebar">

        <div class="brand-area">
            <div class="brand-symbol">
                <img src="/RichardFretes/img/richardLogo.png" alt="Richard Fretes" class="brand-logo">
            </div>

            <div class="brand-text">
                <strong>Richard</strong>
                <span>Fretes</span>
            </div>
        </div>

        <nav class="sidebar-nav">

            <a href="#" class="nav-item active">
                <i class="fas fa-table-cells-large"></i>
                <span>Dashboard</span>
            </a>

            <a href="fretes" class="nav-item">
                <i class="fas fa-route"></i>
                <span>Fretes</span>
            </a>

            <a href="motoristas" class="nav-item">
                <i class="fas fa-id-card"></i>
                <span>Motoristas</span>
            </a>

            <a href="veiculos" class="nav-item">
                <i class="fas fa-truck-moving"></i>
                <span>Veículos</span>
            </a>

            <a href="enderecos" class="nav-item">
                <i class="fas fa-location-dot"></i>
                <span>Endereços</span>
            </a>

            <c:if test="${sessionScope.usuarioAutenticado.admin}">
                <a href="clientes" class="nav-item">
                    <i class="fas fa-building"></i>
                    <span>Clientes</span>
                </a>
            </c:if>

        </nav>

        <div class="sidebar-user">

            <div class="user-avatar">
                <i class="fas fa-user"></i>
            </div>

            <div class="user-meta">
                <span>Usuário logado</span>
                <strong>${sessionScope.usuarioAutenticado.usuario}</strong>

                <small>
                    <c:choose>
                        <c:when test="${sessionScope.usuarioAutenticado.admin}">
                            Administrador
                        </c:when>
                        <c:otherwise>
                            Cliente
                        </c:otherwise>
                    </c:choose>
                </small>
            </div>

            <div class="user-actions">
                <a href="minhaConta" title="Minha Conta">
                    <i class="fas fa-gear"></i>
                </a>

                <a href="logout" title="Sair" class="logout-action">
                    <i class="fas fa-right-from-bracket"></i>
                </a>
            </div>

        </div>

    </aside>

    <main class="main-area">

        <header class="topbar">

            <div>
                <span class="eyebrow">
                    <c:choose>
                        <c:when test="${sessionScope.usuarioAutenticado.admin}">
                            Painel administrativo
                        </c:when>
                        <c:otherwise>
                            Painel do cliente
                        </c:otherwise>
                    </c:choose>
                </span>

                <h1>Visão geral da operação</h1>

                <p>
                    <c:choose>
                        <c:when test="${sessionScope.usuarioAutenticado.admin}">
                            Controle os principais módulos da Richard Fretes em uma central objetiva.
                        </c:when>
                        <c:otherwise>
                            Acompanhe os dados vinculados à sua empresa.
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>

        </header>

        <section class="hero-grid">

            <div class="operation-hero">

                <div class="hero-content">
                    <span class="section-label">Operação principal</span>

                    <h2>Fretes no centro da gestão.</h2>

                    <p>
                        Cadastre viagens, vincule remetente, destinatário, motorista, veículo e acompanhe o fluxo operacional do transporte.
                    </p>

                    <div class="hero-actions">
                        <a href="fretes" class="btn-primary">
                            <i class="fas fa-plus"></i>
                            Novo frete
                        </a>

                        <a href="fretes" class="btn-secondary">
                            Ver fretes
                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>

                <div class="hero-metric">
                    <span>Total de fretes</span>
                    <strong>${empty fretes ? 0 : fn:length(fretes)}</strong>
                    <small>Registros cadastrados</small>
                </div>

            </div>

            <aside class="client-panel">

                <span class="section-label">
                    <c:choose>
                        <c:when test="${sessionScope.usuarioAutenticado.admin}">
                            Visão administrativa
                        </c:when>
                        <c:otherwise>
                            Dados do cliente
                        </c:otherwise>
                    </c:choose>
                </span>

                <c:choose>

                    <c:when test="${sessionScope.usuarioAutenticado.admin}">

                        <div class="client-panel-header">
                            <div class="client-panel-icon">
                                <i class="fas fa-building"></i>
                            </div>

                            <div>
                                <h3>Gestão de clientes</h3>
                                <p>Administre empresas, usuários e operações vinculadas ao sistema.</p>
                            </div>
                        </div>

                        <div class="client-panel-list">

                            <div class="client-info-row">
                                <small>Clientes cadastrados</small>
                                <strong>${empty clientes ? 0 : fn:length(clientes)}</strong>
                            </div>

                            <div class="client-info-row">
                                <small>Fretes no sistema</small>
                                <strong>${empty fretes ? 0 : fn:length(fretes)}</strong>
                            </div>

                            <div class="client-info-row">
                                <small>Motoristas cadastrados</small>
                                <strong>${empty motoristas ? 0 : fn:length(motoristas)}</strong>
                            </div>

                        </div>

                        <a href="clientes" class="client-panel-action">
                            Gerenciar clientes
                            <i class="fas fa-arrow-right"></i>
                        </a>

                    </c:when>

                    <c:otherwise>

                        <div class="client-panel-header">
                            <div class="client-panel-icon">
                                <i class="fas fa-id-card"></i>
                            </div>

                            <div>
                                <h3>${sessionScope.usuarioAutenticado.cliente.razaoSocial}</h3>
                                <p>Informações principais da empresa vinculada ao seu acesso.</p>
                            </div>
                        </div>

                        <div class="client-panel-list">

                            <div class="client-info-row">
                                <small>Documento</small>
                                <strong>${sessionScope.usuarioAutenticado.cliente.documento}</strong>
                            </div>

                            <div class="client-info-row">
                                <small>Inscrição Estadual</small>
                                <strong>${sessionScope.usuarioAutenticado.cliente.inscricaoEstadual}</strong>
                            </div>

                            <div class="client-info-row">
                                <small>E-mail</small>
                                <strong>${sessionScope.usuarioAutenticado.cliente.email}</strong>
                            </div>

                            <div class="client-info-row">
                                <small>Telefone</small>
                                <strong>${sessionScope.usuarioAutenticado.cliente.telefone}</strong>
                            </div>

                        </div>

                        <a href="minhaConta" class="client-panel-action">
                            Ver minha conta
                            <i class="fas fa-arrow-right"></i>
                        </a>

                    </c:otherwise>

                </c:choose>

            </aside>

        </section>

        <section class="insights-section">

            <div class="section-header">
                <div>
                    <span class="section-label">Resumo</span>
                    <h2>Indicadores principais</h2>
                </div>

                <div class="slide-controls">
                    <button type="button" class="slide-btn" id="prevSlide">
                        <i class="fas fa-arrow-left"></i>
                    </button>

                    <button type="button" class="slide-btn" id="nextSlide">
                        <i class="fas fa-arrow-right"></i>
                    </button>
                </div>
            </div>

            <div class="slides-shell">
                <div class="slides-track" id="slidesTrack">

                    <article class="insight-slide">
                        <div class="slide-icon">
                            <i class="fas fa-route"></i>
                        </div>

                        <div class="slide-info">
                            <span>Fretes</span>
                            <strong>${empty fretes ? 0 : fn:length(fretes)}</strong>
                            <p>Total de operações cadastradas.</p>
                        </div>
                    </article>

                    <article class="insight-slide">
                        <div class="slide-icon">
                            <i class="fas fa-id-card"></i>
                        </div>

                        <div class="slide-info">
                            <span>Motoristas</span>
                            <strong>${empty motoristas ? 0 : fn:length(motoristas)}</strong>
                            <p>Condutores registrados na operação.</p>
                        </div>
                    </article>

                    <article class="insight-slide">
                        <div class="slide-icon">
                            <i class="fas fa-truck-moving"></i>
                        </div>

                        <div class="slide-info">
                            <span>Veículos</span>
                            <strong>${empty veiculos ? 0 : fn:length(veiculos)}</strong>
                            <p>Frota cadastrada no sistema.</p>
                        </div>
                    </article>

                    <c:choose>
                        <c:when test="${sessionScope.usuarioAutenticado.admin}">
                            <article class="insight-slide">
                                <div class="slide-icon">
                                    <i class="fas fa-building"></i>
                                </div>

                                <div class="slide-info">
                                    <span>Clientes</span>
                                    <strong>${empty clientes ? 0 : fn:length(clientes)}</strong>
                                    <p>Empresas cadastradas na plataforma.</p>
                                </div>
                            </article>
                        </c:when>

                        <c:otherwise>
                            <article class="insight-slide client-slide">
                                <div class="slide-icon">
                                    <i class="fas fa-id-card"></i>
                                </div>

                                <div class="client-slide-content">
                                    <div class="client-main">
                                        <span>Cliente vinculado</span>
                                        <strong>${sessionScope.usuarioAutenticado.cliente.razaoSocial}</strong>
                                    </div>

                                    <div class="client-data-grid">
                                        <div>
                                            <small>Documento</small>
                                            <p>${sessionScope.usuarioAutenticado.cliente.documento}</p>
                                        </div>

                                        <div>
                                            <small>Inscrição Estadual</small>
                                            <p>${sessionScope.usuarioAutenticado.cliente.inscricaoEstadual}</p>
                                        </div>

                                        <div>
                                            <small>E-mail</small>
                                            <p>${sessionScope.usuarioAutenticado.cliente.email}</p>
                                        </div>

                                        <div>
                                            <small>Telefone</small>
                                            <p>${sessionScope.usuarioAutenticado.cliente.telefone}</p>
                                        </div>
                                    </div>
                                </div>
                            </article>
                        </c:otherwise>
                    </c:choose>

                </div>
            </div>

            <div class="slide-dots" id="slideDots"></div>

        </section>

        <section class="modules-section">

            <div class="section-header">
                <div>
                    <span class="section-label">Módulos</span>
                    <h2>Central de trabalho</h2>
                </div>
            </div>

            <div class="module-grid">

                <a href="fretes" class="module-card main-module">
                    <div class="module-icon">
                        <i class="fas fa-route"></i>
                    </div>

                    <div>
                        <span>Principal</span>
                        <h3>Operação de Fretes</h3>
                        <p>Cadastro e acompanhamento das movimentações de transporte.</p>
                    </div>

                    <i class="fas fa-arrow-right module-arrow"></i>
                </a>

                <a href="motoristas" class="module-card">
                    <div class="module-icon">
                        <i class="fas fa-user-tie"></i>
                    </div>

                    <div>
                        <span>Equipe</span>
                        <h3>Motoristas</h3>
                        <p>Controle de dados, CNH, vínculo e status dos condutores.</p>
                    </div>

                    <i class="fas fa-arrow-right module-arrow"></i>
                </a>

                <a href="veiculos" class="module-card">
                    <div class="module-icon">
                        <i class="fas fa-truck"></i>
                    </div>

                    <div>
                        <span>Frota</span>
                        <h3>Veículos</h3>
                        <p>Gerencie placas, modelos, capacidades e disponibilidade.</p>
                    </div>

                    <i class="fas fa-arrow-right module-arrow"></i>
                </a>

                <a href="enderecos" class="module-card">
                    <div class="module-icon">
                        <i class="fas fa-map-location-dot"></i>
                    </div>

                    <div>
                        <span>Rotas</span>
                        <h3>Endereços</h3>
                        <p>Organize origens, destinos e locais vinculados aos clientes.</p>
                    </div>

                    <i class="fas fa-arrow-right module-arrow"></i>
                </a>

                <c:if test="${sessionScope.usuarioAutenticado.admin}">
                    <a href="clientes" class="module-card admin-module">
                        <div class="module-icon">
                            <i class="fas fa-building"></i>
                        </div>

                        <div>
                            <span>Administração</span>
                            <h3>Clientes</h3>
                            <p>Cadastro e gestão das empresas atendidas pelo sistema.</p>
                        </div>

                        <i class="fas fa-arrow-right module-arrow"></i>
                    </a>
                </c:if>

                <a href="minhaConta" class="module-card account-module">
                    <div class="module-icon">
                        <i class="fas fa-user-gear"></i>
                    </div>

                    <div>
                        <span>Conta</span>
                        <h3>Minha Conta</h3>
                        <p>Visualize e gerencie seus dados de acesso.</p>
                    </div>

                    <i class="fas fa-arrow-right module-arrow"></i>
                </a>

            </div>

        </section>

    </main>

</div>

<script src="/RichardFretes/js/funcoesMenu.js"></script>

</body>
</html>
