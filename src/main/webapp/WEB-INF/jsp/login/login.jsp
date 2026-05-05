<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Acesso ao Sistema</title>

    <link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
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

<script>
    const signUpButton = document.getElementById('signUp');
    const signInButton = document.getElementById('signIn');
    const mobileSignUpButton = document.getElementById('mobileSignUp');
    const mobileSignInButton = document.getElementById('mobileSignIn');
    const container = document.getElementById('container');
    const registerForm = document.getElementById('registerForm');
    const loginForm = document.getElementById('loginForm');
    const registerSuccess = document.getElementById('registerSuccess');
    const registerError = document.getElementById('registerError');
    const loginSuccess = document.getElementById('loginSuccess');
    const loginError = document.getElementById('loginError');

    function limparAlertas() {
        [registerSuccess, registerError, loginSuccess, loginError].forEach((alerta) => {
            if (alerta) {
                alerta.textContent = '';
                alerta.style.display = 'none';
            }
        });
    }

    function mostrarAlerta(elemento, mensagem) {
        if (!elemento) {
            return;
        }
        elemento.textContent = mensagem;
        elemento.style.display = 'block';
    }

    async function enviarParaApi(url, payload) {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            credentials: 'same-origin',
            body: JSON.stringify(payload)
        });

        const rawText = await response.text();
        let data;

        try {
            data = rawText ? JSON.parse(rawText) : {};
        } catch (error) {
            data = {
                mensagem: rawText || `Resposta invalida da API (HTTP ${response.status}).`
            };
        }

        return {
            ok: response.ok,
            status: response.status,
            data: data
        };
    }

    if (signUpButton) {
        signUpButton.addEventListener('click', () => {
            container.classList.add("right-panel-active");
            limparAlertas();
        });
    }

    if (signInButton) {
        signInButton.addEventListener('click', () => {
            container.classList.remove("right-panel-active");
            limparAlertas();
        });
    }

    if (mobileSignUpButton) {
        mobileSignUpButton.addEventListener('click', () => {
            container.classList.add("right-panel-active");
            limparAlertas();
        });
    }

    if (mobileSignInButton) {
        mobileSignInButton.addEventListener('click', () => {
            container.classList.remove("right-panel-active");
            limparAlertas();
        });
    }

    if (registerForm) {
        registerForm.addEventListener('submit', async (event) => {
            event.preventDefault();
            limparAlertas();

            const submitButton = registerForm.querySelector('button[type="submit"]');
            if (submitButton) {
                submitButton.disabled = true;
            }

            try {
                const resultado = await enviarParaApi('api/auth/register', {
                    usuario: document.getElementById('cadastroUsuario').value,
                    email: document.getElementById('cadastroEmail').value,
                    senha: document.getElementById('cadastroSenha').value
                });

                if (resultado.ok) {
                    mostrarAlerta(registerSuccess, resultado.data.mensagem || 'Conta criada com sucesso.');
                    registerForm.reset();
                    container.classList.remove("right-panel-active");
                } else {
                    mostrarAlerta(registerError, resultado.data.mensagem || `Nao foi possivel cadastrar (HTTP ${resultado.status}).`);
                }
            } catch (error) {
                mostrarAlerta(registerError, `Falha ao comunicar com a API de cadastro: ${error.message}`);
            } finally {
                if (submitButton) {
                    submitButton.disabled = false;
                }
            }
        });
    }

    if (loginForm) {
        loginForm.addEventListener('submit', async (event) => {
            event.preventDefault();
            limparAlertas();

            const submitButton = loginForm.querySelector('button[type="submit"]');
            if (submitButton) {
                submitButton.disabled = true;
            }

            try {
                const resultado = await enviarParaApi('api/auth/login', {
                    email: document.getElementById('loginEmail').value,
                    senha: document.getElementById('loginSenha').value
                });

                if (resultado.ok) {
                    mostrarAlerta(loginSuccess, resultado.data.mensagem || 'Login realizado com sucesso.');
                    window.location.href = 'menu';
                } else {
                    mostrarAlerta(loginError, resultado.data.mensagem || `Credenciais invalidas (HTTP ${resultado.status}).`);
                }
            } catch (error) {
                mostrarAlerta(loginError, `Falha ao comunicar com a API de login: ${error.message}`);
            } finally {
                if (submitButton) {
                    submitButton.disabled = false;
                }
            }
        });
    }
</script>

</body>
</html>
