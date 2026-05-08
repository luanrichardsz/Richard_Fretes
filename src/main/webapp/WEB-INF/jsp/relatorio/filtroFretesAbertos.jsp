<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Relatório de Fretes em Aberto</title>

    <link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="/RichardFretes/css/styleC.css" />

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>

<header class="top-header">
    <a href="${pageContext.request.contextPath}/menu" class="logo-btn" title="Voltar" onclick="if (window.history.length > 1) { window.history.back(); return false; }">
        <i class="fas fa-arrow-left"></i>
    </a>
    <a href="${pageContext.request.contextPath}/menu" class="logo-btn" title="Voltar ao menu">
        <i class="fas fa-home"></i>
    </a>
</header>

<main class="container">

    <div class="page-heading">
        <div>
            <span>Relatórios</span>
            <h1>Fretes em aberto</h1>
            <p>Escolha se deseja gerar o PDF com todos os clientes ou limitar o relatário para uma empresa específica.</p>
        </div>
    </div>

    <section class="card">

        <form method="get" action="${pageContext.request.contextPath}/relatorios/fretes-abertos" target="_blank">
            <input type="hidden" name="gerar" value="true">

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-file-lines"></i>
                    </div>

                    <div>
                        <h3>Filtro do relatório</h3>
                        <p>Administradores podem emitir o relatório completo ou selecionar apenas um cliente.</p>
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group full">
                        <label for="clienteId">Cliente</label>
                        <select id="clienteId" name="clienteId">
                            <option value="">Todos os clientes</option>
                            <c:forEach var="cliente" items="${clientes}">
                                <option value="${cliente.id}">
                                    ${not empty cliente.nomeFantasia ? cliente.nomeFantasia : cliente.razaoSocial}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

            </div>

            <div class="form-actions">
                <button type="submit" class="btn-primary">
                    <i class="fas fa-file-pdf"></i>
                    Gerar PDF
                </button>
            </div>
        </form>

    </section>

</main>

</body>
</html>
