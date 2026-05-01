<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Minha Conta</title>
    <link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="/RichardFretes/css/styleMenu.css" />
    <link rel="stylesheet" href="/RichardFretes/css/styleForm.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>

<div class="dashboard-wrapper">
    <aside class="sidebar">
        <div class="brand">
            <h1>R<span>F</span></h1>
        </div>
        <nav class="side-nav">
            <a href="/RichardFretes/menu" title="Home"><i class="fas fa-home"></i></a>
            <c:if test="${sessionScope.usuarioAutenticado.admin}">
                <a href="/RichardFretes/clientes" title="Clientes"><i class="fas fa-users"></i></a>
            </c:if>
            <a href="/RichardFretes/motoristas" title="Motoristas"><i class="fas fa-id-card"></i></a>
            <a href="/RichardFretes/enderecos" title="Endereços"><i class="fas fa-map-location-dot"></i></a>
            <a href="/RichardFretes/veiculos" title="Veículos"><i class="fas fa-truck"></i></a>
            <a href="/RichardFretes/fretes" title="Fretes"><i class="fas fa-route"></i></a>
            <a href="/RichardFretes/login" class="logout-link" title="Sair"><i class="fas fa-sign-out-alt"></i></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="main-header">
            <div class="welcome-text">
                <h2>Configurações da <span>Conta</span></h2>
                <p>Gerencie seu perfil e segurança no Richard Fretes</p>
            </div>
            <div class="header-brand">
                <img src="/RichardFretes/img/richardFretes01-removebg-preview.ico" alt="Icon da Richard Fretes">
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
                <form action="/RichardFretes/minhaConta" method="post">
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
                <form action="/RichardFretes/minhaConta" method="post">
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
