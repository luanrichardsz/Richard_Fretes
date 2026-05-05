<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Menu</title>

    <link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="/RichardFretes/css/styleMenu.css" />

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>

<div class="dashboard-wrapper">

    <aside class="sidebar">
        <div class="brand">
            <div class="brand-mark">RF</div>
        </div>

        <nav class="side-nav">
            <a href="#" class="active" title="Início">
                <i class="fas fa-home"></i>
            </a>

            <c:if test="${sessionScope.usuarioAutenticado.admin}">
                <a href="clientes" title="Clientes">
                    <i class="fas fa-users"></i>
                </a>
            </c:if>

            <a href="motoristas" title="Motoristas">
                <i class="fas fa-id-card"></i>
            </a>

            <a href="enderecos" title="Endereços">
                <i class="fas fa-map-location-dot"></i>
            </a>

            <a href="veiculos" title="Veículos">
                <i class="fas fa-truck"></i>
            </a>

            <a href="fretes" title="Fretes">
                <i class="fas fa-route"></i>
            </a>

            <a href="logout" class="logout-link" title="Sair" aria-label="Sair">
                <i class="fas fa-right-from-bracket"></i>
            </a>
        </nav>
    </aside>

    <main class="main-content">

        <header class="main-header">
            <div class="welcome-text">
                <span class="page-tag">Painel Administrativo -                     
                    <c:choose>
                        <c:when test="${sessionScope.usuarioAutenticado.admin}">
                            Richard Fretes
                        </c:when>
                        <c:otherwise>
                            ${sessionScope.usuarioAutenticado.cliente.razaoSocial}
                        </c:otherwise>
                    </c:choose></span>

                <h2>Olá, <span>${sessionScope.usuarioAutenticado.usuario}!</span></h2>

                <p>

                </p>
            </div>

            <div class="header-brand">
                <img src="/RichardFretes/img/richardFretes01-removebg-preview.ico" alt="Ícone da Richard Fretes">
            </div>
        </header>

                <section class="dashboard-summary">
                    <div class="summary-content">
                        <span class="summary-label">Resumo da operação</span>

                        <h1>
                            Acompanhe os principais dados da sua empresa.
                        </h1>

                        <p>
                            Veja rapidamente a quantidade de fretes, motoristas e veículos vinculados à sua operação.
                        </p>
                    </div>

                    <div class="summary-stats">

                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-route"></i>
                            </div>

                            <div>
                                <strong>${empty fretes ? 0 : fn:length(fretes)}</strong>
                                <span>Fretes cadastrados</span>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-id-card"></i>
                            </div>

                            <div>
                                <strong>${empty motoristas ? 0 : fn:length(motoristas)}</strong>
                                <span>Motoristas</span>
                            </div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-truck-moving"></i>
                            </div>

                            <div>
                                <strong>${empty veiculos ? 0 : fn:length(veiculos)}</strong>
                                <span>Veículos</span>
                            </div>
                        </div>

                        <c:if test="${sessionScope.usuarioAutenticado.admin}">
                            <div class="stat-card">
                                <div class="stat-icon">
                                    <i class="fas fa-building"></i>
                                </div>

                                <div>
                                    <strong>${empty clientes ? 0 : fn:length(clientes)}</strong>
                                    <span>Clientes</span>
                                </div>
                            </div>
                        </c:if>

                    </div>
                </section>

        <section class="modules-layout">

            <div class="modules-column main-modules">
                <div class="modules-header">
                    <div>
                        <span>Operação da transportadora</span>
                        <h2>Central de trabalho</h2>
                    </div>

                    <a href="fretes" class="quick-action">
                        <i class="fas fa-plus"></i>
                        Novo Frete
                    </a>
                </div>

                <div class="operation-panel">

                    <a href="fretes" class="operation-item featured">
                        <div class="item-icon">
                            <i class="fas fa-route"></i>
                        </div>

                        <div class="item-content">
                            <span>Principal</span>
                            <h3>Operação de Fretes</h3>
                            <p>Cadastre fretes, acompanhe entregas e registre ocorrências.</p>
                        </div>

                        <div class="item-action">
                            <i class="fas fa-arrow-right"></i>
                        </div>
                    </a>

                    <div class="support-grid">

                        <a href="enderecos" class="operation-item compact">
                            <div class="item-icon">
                                <i class="fas fa-map-location-dot"></i>
                            </div>

                            <div class="item-content">
                                <span>Origem e destino</span>
                                <h3>Endereços</h3>
                                <p>
                                    ${sessionScope.usuarioAutenticado.admin ? 
                                    'Gerencie os endereços cadastrados no sistema.' : 
                                    'Organize os endereços da sua empresa.'}
                                </p>
                            </div>

                            <div class="item-action">
                                <i class="fas fa-arrow-right"></i>
                            </div>
                        </a>

                        <a href="motoristas" class="operation-item compact">
                            <div class="item-icon">
                                <i class="fas fa-user-tie"></i>
                            </div>

                            <div class="item-content">
                                <span>Equipe</span>
                                <h3>Motoristas</h3>
                                <p>Controle dados, CNH, vínculo e status dos condutores.</p>
                            </div>

                            <div class="item-action">
                                <i class="fas fa-arrow-right"></i>
                            </div>
                        </a>

                        <a href="veiculos" class="operation-item compact">
                            <div class="item-icon">
                                <i class="fas fa-truck-moving"></i>
                            </div>

                            <div class="item-content">
                                <span>Frota</span>
                                <h3>Veículos</h3>
                                <p>Cadastre placas, modelos, capacidade e status da frota.</p>
                            </div>

                            <div class="item-action">
                                <i class="fas fa-arrow-right"></i>
                            </div>
                        </a>

                    </div>
                </div>
            </div>

            <aside class="modules-column side-modules">

                <c:if test="${sessionScope.usuarioAutenticado.admin}">
                    <div class="admin-box">
                        <div class="admin-box-header">
                            <div>
                                <span>Área administrativa</span>
                                <h2>Administração</h2>
                            </div>
                        </div>

                        <a href="clientes" class="admin-link">
                            <div class="admin-link-icon">
                                <i class="fas fa-building"></i>
                            </div>

                            <div>
                                <h3>Clientes</h3>
                                <p>Cadastro e gestão das empresas do sistema.</p>
                            </div>

                            <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </c:if>

                <div class="account-box">
                    <div class="account-avatar">
                        <i class="fas fa-user"></i>
                    </div>

                    <div class="account-info">
                        <span>Usuário logado</span>
                        <h3>${sessionScope.usuarioAutenticado.usuario}</h3>
                        <p>Gerencie seus dados de acesso.</p>
                    </div>

                    <a href="minhaConta" class="account-button">
                        Minha Conta
                        <i class="fas fa-arrow-right"></i>
                    </a>
                </div>

            </aside>

        </section>

    </main>
</div>

<script src="js/funcoesMenu.js"></script>

</body>
</html>
