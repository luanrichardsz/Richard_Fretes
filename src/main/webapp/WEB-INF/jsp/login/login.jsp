<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Richard Fretes | Acesso ao Sistema</title>
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
                <input type="text" name="nome" placeholder="Nome Completo" required />
                <input type="email" name="email" placeholder="E-mail" required />
                <input type="password" name="senha" placeholder="Senha" required />
                <button type="submit" class="btn-main">Cadastrar</button>
            </form>
        </div>

        <div class="form-container sign-in-container">
            <form action="login" method="post">
                <h2>Login</h2>
                <p>Bem-vindo de volta!</p>
                
                <%-- Mensagem de erro dinâmica --%>
                <% String erro = (String) request.getAttribute("erro");
                   if (erro != null) { %>
                    <div class="error-msg"><%= erro %></div>
                <% } %>

                <input type="email" name="email" placeholder="E-mail" required />
                <input type="password" name="senha" placeholder="Senha" required />
                <!-- <a href="#" class="forgot-pass">Esqueceu a senha?</a> -->
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