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
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&display=swap" rel="stylesheet">
</head>
<body>

<div class="main-wrapper">
    <header class="brand-header">
        <h1>Richard <span>Fretes</span></h1>
    </header>

    <div class="container" id="container">
        <div class="form-container sign-up-container">
            <form action="login" method="post">
                <h2>Criar Conta</h2>
                <p>Junte-se à maior rede de fretes</p>

                <c:if test="${not empty sucesso}">
                    <div class="success-msg" style="background-color: #4CAF50; color: white; padding: 10px; border-radius: 4px; margin-bottom: 10px;">${sucesso}</div>
                </c:if>

                <c:if test="${not empty erro}">
                    <div class="error-msg">${erro}</div>
                </c:if>

                <input type="text" name="usuario" placeholder="Nome de Usuário" required />
                <input type="email" name="email" placeholder="E-mail" required />
                <input type="password" name="senha" placeholder="Senha" required />
                <button type="submit" class="btn-main">Cadastrar</button>
            </form>
        </div>

        <div class="form-container sign-in-container">
            <form action="login" method="post">
                <h2>Login</h2>
                <p>Bem-vindo de volta!</p>

                <c:if test="${not empty sucesso}">
                    <div class="success-msg" style="background-color: #4CAF50; color: white; padding: 10px; border-radius: 4px; margin-bottom: 10px;">${sucesso}</div>
                </c:if>

                <c:if test="${not empty erro}">
                    <div class="error-msg">${erro}</div>
                </c:if>

                <input type="email" name="email" placeholder="E-mail" required />
                <input type="password" name="senha" placeholder="Senha" required />
                <button type="submit" class="btn-main">Entrar</button>
            </form>
        </div>

        <div class="overlay-container">
            <div class="overlay">
                <div class="overlay-panel overlay-left">
                    <h2>Já tem conta?</h2>
                    <p>Faça o login para gerenciar seus fretes agora mesmo.</p>
                    <button class="btn-ghost" id="signIn">Ir para Login</button>
                </div>
                <div class="overlay-panel overlay-right">
                    <h2>Novo por aqui?</h2>
                    <p>Cadastre-se e comece a faturar com Richard Fretes.</p>
                    <button class="btn-ghost" id="signUp">Criar Conta</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const signUpButton = document.getElementById('signUp');
    const signInButton = document.getElementById('signIn');
    const container = document.getElementById('container');

    signUpButton.addEventListener('click', () => {
        container.classList.add("right-panel-active");
    });

    signInButton.addEventListener('click', () => {
        container.classList.remove("right-panel-active");
    });
</script>

</body>
</html>
