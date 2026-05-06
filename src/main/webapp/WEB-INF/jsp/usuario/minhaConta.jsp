<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Minha Conta</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleForm.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styleMenu.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

<div class="app-shell">
    <aside class="sidebar">
        <div class="brand-area">
            <div class="brand-symbol">
                <img src="${pageContext.request.contextPath}/img/richardLogo.png" alt="Richard Fretes" class="brand-logo">
            </div>
            <div class="brand-text">
                <strong>Richard</strong>
                <span>Fretes</span>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/menu" class="nav-item" title="Home">
                <i class="fas fa-table-cells-large"></i>
                <span>Dashboard</span>
            </a>
            <c:if test="${sessionScope.usuarioAutenticado.admin}">
                <a href="${pageContext.request.contextPath}/clientes" class="nav-item" title="Clientes">
                    <i class="fas fa-building"></i>
                    <span>Clientes</span>
                </a>
            </c:if>
            <a href="${pageContext.request.contextPath}/motoristas" class="nav-item" title="Motoristas">
                <i class="fas fa-id-card"></i>
                <span>Motoristas</span>
            </a>
            <a href="${pageContext.request.contextPath}/enderecos" class="nav-item" title="Endereços">
                <i class="fas fa-location-dot"></i>
                <span>Endereços</span>
            </a>
            <a href="${pageContext.request.contextPath}/veiculos" class="nav-item" title="Veículos">
                <i class="fas fa-truck-moving"></i>
                <span>Veículos</span>
            </a>
            <a href="${pageContext.request.contextPath}/fretes" class="nav-item" title="Fretes">
                <i class="fas fa-route"></i>
                <span>Fretes</span>
            </a>
        </nav>

        <div class="sidebar-user">
            <div class="user-avatar">
                <i class="fas fa-user"></i>
            </div>

            <div class="user-meta">
                <span>Usuário logado</span>
                <strong>${sessionScope.usuarioAutenticado.usuario}</strong>
                <small>${sessionScope.usuarioAutenticado.admin ? 'Administrador' : 'Cliente'}</small>
            </div>

            <div class="user-actions">
                <a href="${pageContext.request.contextPath}/minhaConta" title="Minha Conta">
                    <i class="fas fa-gear"></i>
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="logout-action" title="Sair">
                    <i class="fas fa-right-from-bracket"></i>
                </a>
            </div>
        </div>
    </aside>

    <main class="main-area">
        <header class="topbar">
            <div>
                <span class="eyebrow">Minha conta</span>
                <h1>Configurações da conta</h1>
                <p>Gerencie seu perfil e segurança no Richard Fretes</p>
            </div>
        </header>

        <c:if test="${not empty erro}">
            <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${erro}</div>
        </c:if>

        <c:if test="${not empty sucesso}">
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> Dados atualizados com sucesso!</div>
        </c:if>

        <div class="account-container">
            <section class="account-card">
                <form action="${pageContext.request.contextPath}/minhaConta" method="post">
                    <input type="hidden" name="acao" value="atualizarPerfil">
                    <div class="card-header">
                        <h3><i class="fas fa-user"></i> Informações Pessoais</h3>
                    </div>
                    <div class="form-grid">
                        <div class="input-group">
                            <label>Nome de Usuário</label>
                            <input type="text" name="usuario" value="${sessionScope.usuarioAutenticado.usuario}" required>
                        </div>
                        <div class="input-group">
                            <label>E-mail (Login)</label>
                            <input type="email" name="email" value="${sessionScope.usuarioAutenticado.email}" required>
                        </div>
                        <div class="input-group">
                            <label>Tipo de Conta</label>
                            <input type="text" value="${sessionScope.usuarioAutenticado.admin ? 'Administrador' : 'Responsável Empresa'}" disabled class="input-disabled">
                        </div>
                    </div>
                    <button type="submit" class="btn-save">Salvar Alterações</button>
                </form>
            </section>

            <section class="account-card">
                <form action="${pageContext.request.contextPath}/minhaConta" method="post">
                    <input type="hidden" name="acao" value="alterarSenha">
                    <div class="card-header">
                        <h3><i class="fas fa-shield-alt"></i> Segurança</h3>
                    </div>
                    <div class="form-grid">
                        <div class="input-group">
                            <label>Senha Atual</label>
                            <input type="password" name="senhaAtual" placeholder="••••••••" required>
                        </div>
                        <div class="input-group">
                            <label>Nova Senha</label>
                            <input type="password" name="novaSenha" placeholder="Mínimo 6 caracteres" required>
                        </div>
                        <div class="input-group">
                            <label>Confirmar Nova Senha</label>
                            <input type="password" name="confirmarSenha" placeholder="••••••••" required>
                        </div>
                    </div>
                    <button type="submit" class="btn-save btn-outline">Atualizar Senha</button>
                </form>
            </section>
        </div>
    </main>
</div>

</body>
</html>
