<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>${not empty veiculo.id ? 'Editar Veículo' : 'Novo Veículo'}</title>

    <link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="/RichardFretes/css/styleC.css" />

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body>

<header class="top-header">
    <a href="menu" class="logo-btn" title="Voltar" onclick="if (window.history.length > 1) { window.history.back(); return false; }">
        <i class="fas fa-arrow-left"></i>
    </a>
    <a href="menu" class="logo-btn" title="Voltar ao menu">
        <i class="fas fa-home"></i>
    </a>
</header>

<main class="container">

    <div class="page-heading">
        <div>
            <span>Cadastro de veículo</span>

            <h1>
                ${not empty veiculo.id ? 'Editar Veículo' : 'Novo Veículo'}
            </h1>

            <p>
                Cadastre os veículos da frota, controle documentação, capacidade de carga, motorista vinculado e situação operacional.
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

        <form action="veiculos" method="post">

            <c:if test="${not empty veiculo.id}">
                <input type="hidden" name="id" value="${veiculo.id}" />
            </c:if>

            <c:if test="${sessionScope.usuarioAutenticado.admin}">
                <div class="form-section">

                    <div class="form-section-header">
                        <div class="form-section-icon">
                            <i class="fas fa-building"></i>
                        </div>

                        <div>
                            <h3>Vínculo do veículo</h3>
                            <p>Selecione a empresa responsável por este veículo.</p>
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
                                        ${not empty veiculo.clienteId and veiculo.clienteId eq cliente.id ? 'selected' : ''}
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
                        <i class="fas fa-id-card"></i>
                    </div>

                    <div>
                        <h3>Identificação</h3>
                        <p>Dados oficiais de identificação e registro do veículo.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group">
                        <label>Placa <span class="required">*</span></label>

                        <input
                            type="text"
                            id="placa"
                            name="placa"
                            value="${veiculo.placa}"
                            maxlength="8"
                            placeholder="ABC1D23"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>RENAVAM <span class="required">*</span></label>

                        <input
                            type="text"
                            id="renavam"
                            name="renavam"
                            maxlength="11"
                            inputmode="numeric"
                            value="${veiculo.renavam}"
                            placeholder="Somente números"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>RNTRC</label>

                        <input
                            type="text"
                            id="rntrc"
                            name="rntrc"
                            maxlength="8"
                            inputmode="numeric"
                            value="${veiculo.rntrc}"
                            placeholder="Registro ANTT"
                        />
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-truck-moving"></i>
                    </div>

                    <div>
                        <h3>Características do veículo</h3>
                        <p>Informações estruturais usadas para classificar a frota.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group">
                        <label>Ano Fabricação <span class="required">*</span></label>

                        <input
                            type="number"
                            name="anoFabricacao"
                            min="1950"
                            max="2100"
                            value="${veiculo.anoFabricacao}"
                            placeholder="Ex: 2020"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Ano Modelo <span class="required">*</span></label>

                        <input
                            type="number"
                            name="anoModelo"
                            min="1950"
                            max="2100"
                            value="${veiculo.anoModelo}"
                            placeholder="Ex: 2021"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Combustível <span class="required">*</span></label>

                        <select name="combustivel" required>
                            <option value="">Selecione</option>
                            <option value="Diesel" ${veiculo.combustivel eq 'Diesel' ? 'selected' : ''}>Diesel</option>
                            <option value="Gasolina" ${veiculo.combustivel eq 'Gasolina' ? 'selected' : ''}>Gasolina</option>
                            <option value="Etanol" ${veiculo.combustivel eq 'Etanol' ? 'selected' : ''}>Etanol</option>
                            <option value="GNV" ${veiculo.combustivel eq 'GNV' ? 'selected' : ''}>GNV</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Tipo <span class="required">*</span></label>

                        <input
                            type="text"
                            name="tipo"
                            value="${veiculo.tipo}"
                            placeholder="Ex: Caminhão, Carreta, Van..."
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Tipo Outros</label>

                        <input
                            type="text"
                            name="tipoOutros"
                            value="${veiculo.tipoOutros}"
                            placeholder="Detalhe o tipo, se necessário"
                        />
                    </div>

                    <div class="form-group">
                        <label>Quantidade de Eixos <span class="required">*</span></label>

                        <input
                            type="number"
                            name="quantidadeEixos"
                            min="1"
                            value="${veiculo.quantidadeEixos}"
                            placeholder="Ex: 2"
                            required
                        />
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-weight-hanging"></i>
                    </div>

                    <div>
                        <h3>Capacidade e peso</h3>
                        <p>Dados usados para cálculo de carga, operação e compatibilidade com fretes.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group">
                        <label>Tara (kg) <span class="required">*</span></label>

                        <input
                            type="number"
                            name="taraKg"
                            min="0"
                            step="1"
                            value="${veiculo.taraKg}"
                            placeholder="Peso do veículo vazio"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Capacidade de Carga (kg) <span class="required">*</span></label>

                        <input
                            type="number"
                            name="capacidadeCargaKg"
                            min="0"
                            step="1"
                            value="${veiculo.capacidadeCargaKg}"
                            placeholder="Carga máxima permitida"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Volume (m³)</label>

                        <input
                            type="number"
                            name="volumeM3"
                            min="0"
                            step="1"
                            value="${veiculo.volumeM3}"
                            placeholder="Ex: 45"
                        />
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-clipboard-check"></i>
                    </div>

                    <div>
                        <h3>Informações operacionais</h3>
                        <p>Controle de disponibilidade, seguro, motorista e pendências do veículo.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group">
                        <label>Status <span class="required">*</span></label>

                        <select name="status" required>
                            <option value="">Selecione</option>

                            <c:forEach var="status" items="${statusVeiculoOptions}">
                                <option value="${status}" ${veiculo.status eq status ? 'selected' : ''}>
                                    ${status}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Motorista</label>

                        <select name="motoristaId">
                            <option value="">Selecione um motorista</option>

                            <c:forEach var="motorista" items="${motoristas}">
                                <option
                                    value="${motorista.id}"
                                    ${not empty veiculo.motoristaId and veiculo.motoristaId eq motorista.id ? 'selected' : ''}
                                >
                                    ${motorista.nomeCompleto}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Seguro Validade</label>

                        <input
                            type="date"
                            name="seguroValidade"
                            value="${veiculo.seguroValidade}"
                        />
                    </div>

                    <div class="form-group full">
                        <label class="check-card">
                            <input
                                type="checkbox"
                                name="manutencaoPendente"
                                value="true"
                                ${veiculo.manutencaoPendente ? 'checked' : ''}
                            />

                            <span>
                                <strong>Manutenção pendente</strong>
                                <small>Marque esta opção caso o veículo não esteja liberado para operação.</small>
                            </span>
                        </label>
                    </div>

                </div>

            </div>

            <div class="form-actions">
                <a href="veiculos" class="btn-small">
                    <i class="fas fa-arrow-left"></i>
                    Cancelar
                </a>

                <button type="submit" class="btn-primary">
                    <i class="fas fa-save"></i>
                    ${not empty veiculo.id ? 'Atualizar Veículo' : 'Salvar Veículo'}
                </button>
            </div>

        </form>

    </section>

</main>

<script src="/RichardFretes/js/funcoesCadastroV.js"></script>

</body>
</html>
