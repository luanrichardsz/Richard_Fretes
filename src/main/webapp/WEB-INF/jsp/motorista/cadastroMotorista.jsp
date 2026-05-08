<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>${not empty motorista.id ? 'Editar Motorista' : 'Novo Motorista'}</title>

    <link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="/RichardFretes/css/styleC.css" />

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>

<header class="top-header">
    <a href="menu" class="logo-btn" title="Voltar ao menu">
        <i class="fas fa-home"></i>
    </a>
</header>

<main class="container">

    <div class="page-heading">
        <div>
            <span>Cadastro de motorista</span>

            <h1>
                ${not empty motorista.id ? 'Editar Motorista' : 'Novo Motorista'}
            </h1>

            <p>
                Cadastre condutores, controle documentos, CNH, contato de emergência, vínculo profissional e dados de pagamento.
            </p>
        </div>
    </div>

    <section class="card">

        <c:if test="${not empty erro}">
            <div class="alert alert-error">
                <i class="fas fa-circle-exclamation"></i>
                ${erro}
            </div>
        </c:if>

        <form action="motoristas" method="post">

            <c:if test="${not empty motorista.id}">
                <input type="hidden" name="id" value="${motorista.id}" />
            </c:if>

            <c:if test="${sessionScope.usuarioAutenticado.admin}">
                <div class="form-section">

                    <div class="form-section-header">
                        <div class="form-section-icon">
                            <i class="fas fa-building"></i>
                        </div>

                        <div>
                            <h3>Vínculo do motorista</h3>
                            <p>Selecione a empresa responsável por este condutor.</p>
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group full">
                            <label>Empresa Selecionada <span class="required">*</span></label>

                            <select name="clienteId" required>
                                <option value="">Selecione uma empresa</option>

                                <c:forEach var="cliente" items="${clientes}">
                                    <option
                                        value="${cliente.id}"
                                        ${not empty motorista.clienteId and motorista.clienteId eq cliente.id ? 'selected' : ''}
                                    >
                                        ${cliente.razaoSocial}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                </div>
            </c:if>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-user-tie"></i>
                    </div>

                    <div>
                        <h3>Dados pessoais</h3>
                        <p>Informações principais de identificação e contato do motorista.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group full">
                        <label>Nome Completo <span class="required">*</span></label>

                        <input
                            type="text"
                            name="nomeCompleto"
                            value="${motorista.nomeCompleto}"
                            placeholder="Nome completo do motorista"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>CPF <span class="required">*</span></label>

                        <input
                            type="text"
                            id="cpf"
                            name="cpf"
                            maxlength="14"
                            inputmode="numeric"
                            value="${motorista.cpf}"
                            placeholder="000.000.000-00"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>RG <span class="required">*</span></label>

                        <input
                            type="text"
                            id="rg"
                            name="rg"
                            maxlength="12"
                            inputmode="numeric"
                            value="${motorista.rg}"
                            placeholder="Documento de identidade"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Data de Nascimento <span class="required">*</span></label>

                        <input
                            type="date"
                            id="dataNascimento"
                            name="dataNascimento"
                            max="${hoje}"
                            value="${motorista.dataNascimento}"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Telefone <span class="required">*</span></label>

                        <input
                            type="tel"
                            id="telefone"
                            name="telefone"
                            maxlength="15"
                            inputmode="numeric"
                            value="${motorista.telefone}"
                            placeholder="(81) 99999-9999"
                            required
                        />
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-phone-volume"></i>
                    </div>

                    <div>
                        <h3>Contato de emergência</h3>
                        <p>Dados opcionais para contato em situações operacionais ou emergenciais.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group full">
                        <label>Nome da Pessoa</label>

                        <input
                            type="text"
                            name="nomeEmergencia"
                            value="${motorista.nomeEmergencia}"
                            placeholder="Nome do contato de emergência"
                        />
                    </div>

                    <div class="form-group">
                        <label>Telefone</label>

                        <input
                            type="tel"
                            id="telefoneEmergencia"
                            name="telefoneEmergencia"
                            maxlength="15"
                            inputmode="numeric"
                            value="${motorista.telefoneEmergencia}"
                            placeholder="(81) 99999-9999"
                        />
                    </div>

                    <div class="form-group">
                        <label>Parentesco</label>

                        <input
                            type="text"
                            name="parentescoEmergencia"
                            value="${motorista.parentescoEmergencia}"
                            placeholder="Ex: Esposa, irmão, mãe..."
                        />
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-id-card"></i>
                    </div>

                    <div>
                        <h3>Carteira de habilitação</h3>
                        <p>Controle de CNH, categoria, validade e exame toxicológico.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group">
                        <label>Número CNH <span class="required">*</span></label>

                        <input
                            type="text"
                            id="numeroCnh"
                            name="numeroCnh"
                            maxlength="11"
                            inputmode="numeric"
                            value="${motorista.numeroCnh}"
                            placeholder="Somente números"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Categoria <span class="required">*</span></label>

                        <select name="categoriaCnh" required>
                            <option value="">Selecione</option>

                            <c:forEach var="cat" items="${categoriaCnhOptions}">
                                <option value="${cat}" ${motorista.categoriaCnh eq cat ? 'selected' : ''}>
                                    ${cat}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Validade CNH <span class="required">*</span></label>

                        <input
                            type="date"
                            name="validadeCnh"
                            value="${motorista.validadeCnh}"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Validade Toxicológico</label>

                        <input
                            type="date"
                            name="validadeToxicologico"
                            value="${motorista.validadeToxicologico}"
                        />
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-briefcase"></i>
                    </div>

                    <div>
                        <h3>Dados profissionais e financeiros</h3>
                        <p>Defina o vínculo do motorista, forma de pagamento e situação no sistema.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group">
                        <label>Tipo Vínculo <span class="required">*</span></label>

                        <select name="tipoVinculo" required>
                            <option value="">Selecione</option>

                            <c:forEach var="tipo" items="${tipoVinculoOptions}">
                                <option value="${tipo}" ${motorista.tipoVinculo eq tipo ? 'selected' : ''}>
                                    ${tipo}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Tipo PIX <span class="required">*</span></label>

                        <select id="tipoPix" name="tipoPix" required>
                            <option value="">Selecione</option>

                            <c:forEach var="tipo" items="${tipoPixOptions}">
                                <option value="${tipo}" ${motorista.tipoPix eq tipo ? 'selected' : ''}>
                                    ${tipo}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group full">
                        <label>Chave PIX <span class="required">*</span></label>

                        <input
                            type="text"
                            id="chavePix"
                            name="chavePix"
                            value="${motorista.chavePix}"
                            placeholder="Informe a chave PIX conforme o tipo selecionado"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Status <span class="required">*</span></label>

                        <select name="status" required>
                            <option value="">Selecione</option>

                            <c:forEach var="status" items="${statusMotoristaOptions}">
                                <option value="${status}" ${motorista.status eq status ? 'selected' : ''}>
                                    ${status}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                </div>

            </div>

            <div class="form-actions">
                <a href="motoristas" class="btn-small">
                    <i class="fas fa-arrow-left"></i>
                    Cancelar
                </a>

                <button type="submit" class="btn-primary">
                    <i class="fas fa-save"></i>
                    ${not empty motorista.id ? 'Atualizar Motorista' : 'Salvar Motorista'}
                </button>
            </div>

        </form>

    </section>

</main>

<script src="/RichardFretes/js/funcoesCadastroM.js"></script>

</body>
</html>