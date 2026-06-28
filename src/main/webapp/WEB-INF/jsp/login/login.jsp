<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Acesso ao Sistema</title>

    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="css/styleLogin.css" />

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
</head>

<body>

<div class="login-page">

    <div class="route-map">
        <span class="map-dot dot-1"></span>
        <span class="map-dot dot-2"></span>
        <span class="map-dot dot-3"></span>
        <span class="map-line line-1"></span>
        <span class="map-line line-2"></span>
    </div>

    <div class="road-perspective">
        <div class="road"></div>
        <div class="road-center-line"></div>
    </div>

    <div class="floating-card card-truck">
        <span class="card-icon">🚚</span>
        <div>
            <strong>Fretes</strong>
            <small>Controle operacional</small>
        </div>
    </div>

    <div class="floating-card card-route">
        <span class="card-icon">📍</span>
        <div>
            <strong>Rotas</strong>
            <small>Entregas monitoradas</small>
        </div>
    </div>

    <div class="floating-card card-fleet">
        <span class="card-icon">⚙️</span>
        <div>
            <strong>Frota</strong>
            <small>Veículos e motoristas</small>
        </div>
    </div>

    <header class="brand-top">
        <div class="brand-mark">RF</div>
        <div>
            <h1>Richard <span>Fretes</span></h1>
            <p>Sistema de gestão para transportadoras</p>
        </div>
    </header>

    <main class="auth-area">

        <section class="container" id="container">

            <div class="form-container sign-up-container">
                <form id="registerForm" autocomplete="off">
                    <div class="form-header">
                        <span class="eyebrow">Nova operação</span>
                        <h2>Criar Conta</h2>
                        <p>Cadastre seu acesso para iniciar a gestão dos fretes.</p>
                    </div>

                    <div class="alert success-msg api-alert" id="registerSuccess"></div>
                    <div class="alert error-msg api-alert" id="registerError"></div>

                    <div class="input-group">
                        <label for="cadastroUsuario">Nome de Usuário</label>
                        <input
                            id="cadastroUsuario"
                            type="text"
                            name="usuario"
                            placeholder="Ex: richard.transportes"
                            required
                        />
                    </div>

                    <div class="input-group">
                        <label for="cadastroEmail">E-mail</label>
                        <input
                            id="cadastroEmail"
                            type="email"
                            name="email"
                            placeholder="empresa@email.com"
                            required
                        />
                    </div>

                    <div class="input-group">
                        <label for="cadastroSenha">Senha</label>
                        <input
                            id="cadastroSenha"
                            type="password"
                            name="senha"
                            placeholder="Crie sua senha"
                            required
                        />
                    </div>

                    <button type="submit" class="btn-main">Cadastrar</button>

                    <button type="button" class="mobile-switch" id="mobileSignIn">
                        Já tenho acesso
                    </button>
                </form>
            </div>

            <div class="form-container sign-in-container">
                <form id="loginForm" autocomplete="off">
                    <div class="form-header">
                        <span class="eyebrow">Central de fretes</span>
                        <h2>Entrar no Sistema</h2>
                        <p>Acesse sua operação de transporte e acompanhe seus fretes.</p>
                    </div>

                    <div class="alert success-msg api-alert" id="loginSuccess"></div>
                    <div class="alert error-msg api-alert" id="loginError"></div>

                    <div class="input-group">
                        <label for="loginEmail">E-mail</label>
                        <input
                            id="loginEmail"
                            type="email"
                            name="email"
                            placeholder="richard.fretes@email.com"
                            required
                        />
                    </div>

                    <div class="input-group">
                        <label for="loginSenha">Senha</label>
                        <input
                            id="loginSenha"
                            type="password"
                            name="senha"
                            placeholder="Digite sua senha"
                            required
                        />
                    </div>

                    <button type="submit" class="btn-main">Entrar</button>

                    <button type="button" class="mobile-switch" id="mobileSignUp">
                        Criar nova conta
                    </button>
                </form>
            </div>

            <div class="overlay-container">
                <div class="overlay">

                    <div class="overlay-panel overlay-left">
                        <div class="overlay-content">
                            <span class="panel-tag">Acesso existente</span>
                            <h2>Sua operação já está em rota?</h2>
                            <p>
                                Entre para continuar acompanhando fretes,
                                clientes, veículos e ocorrências.
                            </p>
                            <button type="button" class="btn-ghost" id="signIn">
                                Ir para Login
                            </button>
                        </div>
                    </div>

                    <div class="overlay-panel overlay-right">
                        <div class="overlay-content">
                            <span class="panel-tag">Primeira viagem</span>
                            <h2>Comece sua central de fretes</h2>
                            <p>
                                Crie sua conta e organize sua transportadora
                                com mais controle e agilidade.
                            </p>
                            <button type="button" class="btn-ghost" id="signUp">
                                Criar Conta
                            </button>
                        </div>
                    </div>

                </div>
            </div>

        </section>
    </main>
</div>

<script src="${pageContext.request.contextPath}/js/funcoesLogin.js"></script>

</body>
</html>
