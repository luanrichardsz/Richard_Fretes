<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<%@ page import="br.com.model.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioAutenticado");
    if (usuario == null) {
        response.sendRedirect("login"); 
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Richard Fretes</title>
    <link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="/RichardFretes/css/styleMenu.css" />
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
            <a href="#" class="logo-btn active" title="Home"><i class="fas fa-home"></i></a>
            <a href="clientes" title="Clientes"><i class="fas fa-users"></i></a>
            <a href="motoristas" title="Motoristas"><i class="fas fa-id-card"></i></a>
            <a href="veiculos" title="Veículos"><i class="fas fa-truck"></i></a>
            <a href="fretes" title="Fretes"><i class="fas fa-route"></i></a>
            <a href="login" class="logout-link" title="Sair"><i class="fas fa-sign-out-alt"></i></a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="main-header">
            <div class="welcome-text">
                <h2>Olá, <span><%= usuario.getUsuario() %> !</span></h2>
                <p>Painel Administrativo -
                <%
                    if (usuario.isAdmin()) {
                        out.print("Richard Fretes");
                    } else if (usuario.getClienteId() != null) {
                        out.print("Sua Empresa");
                    } else {
                        out.print("Richard Fretes");
                    }
                %>
                </p>
            </div>
            <div class="header-brand">
                <img src="/RichardFretes/img/richardFretes01-removebg-preview.ico" alt="Icon da Richad Fretes">
            </div>
        </header>

        <section class="menu-grid">
            
            <a href="clientes" class="menu-card">
                <div class="card-icon"><i class="fas fa-users"></i></div>
                <div class="card-info">
                    <h3>Clientes</h3>
                    <p>Gerencie sua base de parceiros e tomadores de serviço.</p>
                </div>
                <div class="card-arrow"><i class="fas fa-chevron-right"></i></div>
            </a>

            <a href="motoristas" class="menu-card">
                <div class="card-icon"><i class="fas fa-user-tie"></i></div>
                <div class="card-info">
                    <h3>Motoristas</h3>
                    <p>Controle de CNH, exames e documentos dos condutores.</p>
                </div>
                <div class="card-arrow"><i class="fas fa-chevron-right"></i></div>
            </a>

            <a href="veiculos" class="menu-card">
                <div class="card-icon"><i class="fas fa-truck-moving"></i></div>
                <div class="card-info">
                    <h3>Veículos</h3>
                    <p>Cadastro de frota, placas, modelos e manutenções.</p>
                </div>
                <div class="card-arrow"><i class="fas fa-chevron-right"></i></div>
            </a>
        </section>
        <br>
        <section class="menu-grid">
            <a href="fretes" class="menu-card highlight">
                <div class="card-icon"><i class="fas fa-route"></i></div>
                <div class="card-info">
                    <h3>Operação de Fretes</h3>
                    <p>Gerencie e cadastre seus fretes.</p>
                </div>
                <div class="card-arrow"><i class="fas fa-chevron-right"></i></div>
            </a>

            <a class="menu-card">
                <div class="card-icon"><i class="fas fa-chart-pie"></i></div>
                <div class="card-info">
                    <h3>Relatórios</h3>
                    <p>Analise lucros, KM rodados e performance da frota.</p>
                </div>
                <div class="card-arrow"><i class="fas fa-chevron-right"></i></div>
            </a>

            <a class="menu-card">
                <div class="card-icon"><i class="fas fa-user-gear"></i></div>
                <div class="card-info">
                    <h3>Minha Conta</h3>
                    <p>Atualize seus dados, senha e preferências de sistema.</p>
                </div>
                <div class="card-arrow"><i class="fas fa-chevron-right"></i></div>
            </a>

        </section>
    </main>
</div>

</body>
</html>