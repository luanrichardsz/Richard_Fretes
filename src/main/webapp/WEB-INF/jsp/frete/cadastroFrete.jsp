<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>${not empty frete.id ? 'Editar Frete' : 'Novo Frete'}</title>

    <link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="/RichardFretes/css/styleC.css" />

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body class="frete-form-page">

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
            <span>Cadastro de frete</span>
            <h1>${not empty frete.id ? 'Editar Frete' : 'Novo Frete'}</h1>
            <p>
                Organize a emissão com mais clareza: rota, participantes, carga, tributação e prazo em seções separadas. Campos fiscais e códigos automáticos ficam somente para leitura.
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

        <form action="fretes" method="post">

            <c:if test="${not empty frete.id}">
                <input type="hidden" name="id" value="${frete.id}" />
            </c:if>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-file-invoice-dollar"></i>
                    </div>

                    <div>
                        <h3>Emissão e participantes</h3>
                        <p>Defina o frete, a empresa remetente e o destinatário da operação.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group">
                        <label>Número do Frete <span class="required">*</span></label>

                        <input type="hidden" name="numeroFrete" value="${frete.numeroFrete}" />
                        <input
                            type="text"
                            id="numeroFrete"
                            maxlength="20"
                            value="${frete.numeroFrete}"
                            class="readonly-field"
                            readonly
                        />
                        <small class="field-hint">Gerado automaticamente para manter a rastreabilidade do frete.</small>
                    </div>

                    <div class="form-group">
                        <label>Remetente <span class="required">*</span></label>

                        <c:choose>
                            <c:when test="${sessionScope.usuarioAutenticado.admin}">
                                <select name="remetenteId" required>
                                    <option value="">Selecione um cliente</option>

                                    <c:forEach var="cliente" items="${clientes}">
                                        <option value="${cliente.id}" ${not empty frete.remetenteId and frete.remetenteId eq cliente.id ? 'selected' : ''}>
                                            ${not empty cliente.nomeFantasia ? cliente.nomeFantasia : cliente.razaoSocial}
                                        </option>
                                    </c:forEach>
                                </select>
                                <small class="field-hint">Empresa responsável pela emissão do frete.</small>
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="remetenteId" value="${frete.remetenteId}" />
                                <input
                                    type="text"
                                    value="${not empty remetenteCliente.nomeFantasia ? remetenteCliente.nomeFantasia : remetenteCliente.razaoSocial}"
                                    class="readonly-field"
                                    readonly
                                />
                                <small class="field-hint">Remetente fixado conforme o cliente autenticado.</small>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="form-group full">
                        <label>Destinatário <span class="required">*</span></label>

                        <select id="destinatarioId" name="destinatarioId" required>
                            <option value="">Selecione um cliente</option>

                            <c:forEach var="cliente" items="${clientes}">
                                <option value="${cliente.id}" ${not empty frete.destinatarioId and frete.destinatarioId eq cliente.id ? 'selected' : ''}>
                                    ${not empty cliente.nomeFantasia ? cliente.nomeFantasia : cliente.razaoSocial}
                                </option>
                            </c:forEach>
                        </select>
                        <small class="field-hint">A seleção do destinatário libera apenas os endereços de entrega compatíveis.</small>
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-route"></i>
                    </div>

                    <div>
                        <h3>Rota e operação</h3>
                        <p>Associe origem, destino, motorista e veículo que executarão o transporte.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group">
                        <label>Endereço de Origem <span class="required">*</span></label>

                        <select id="enderecoOrigemId" name="enderecoOrigemId" required>
                            <option value="">Selecione um endereço</option>

                            <c:forEach var="endereco" items="${enderecosOrigem}">
                                <option
                                    value="${endereco.id}"
                                    data-cliente-id="${endereco.clienteId}"
                                    data-codigo-ibge="${endereco.codigoIbge}"
                                    data-uf="${endereco.uf}"
                                    data-municipio="${endereco.municipio}"
                                    ${not empty frete.enderecoOrigemId and frete.enderecoOrigemId eq endereco.id ? 'selected' : ''}
                                >
                                    ${endereco.logradouro}, ${endereco.numero} - ${endereco.municipio}/${endereco.uf}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Endereço de Destino <span class="required">*</span></label>

                        <select id="enderecoDestinoId" name="enderecoDestinoId" required>
                            <option value="">Selecione um endereço</option>

                            <c:forEach var="endereco" items="${enderecosDestino}">
                                <option
                                    value="${endereco.id}"
                                    data-cliente-id="${endereco.clienteId}"
                                    data-codigo-ibge="${endereco.codigoIbge}"
                                    data-uf="${endereco.uf}"
                                    data-municipio="${endereco.municipio}"
                                    ${not empty frete.enderecoDestinoId and frete.enderecoDestinoId eq endereco.id ? 'selected' : ''}
                                >
                                    ${endereco.logradouro}, ${endereco.numero} - ${endereco.municipio}/${endereco.uf}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Motorista <span class="required">*</span></label>

                        <select name="motoristaId" required>
                            <option value="">Selecione um motorista</option>

                            <c:forEach var="motorista" items="${motoristas}">
                                <option value="${motorista.id}" ${not empty frete.motoristaId and frete.motoristaId eq motorista.id ? 'selected' : ''}>
                                    ${motorista.nomeCompleto}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Veículo <span class="required">*</span></label>

                        <select name="veiculoId" required>
                            <option value="">Selecione um veículo</option>

                            <c:forEach var="veiculo" items="${veiculos}">
                                <option value="${veiculo.id}" ${not empty frete.veiculoId and frete.veiculoId eq veiculo.id ? 'selected' : ''}>
                                    ${veiculo.placa} - ${veiculo.tipo}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-boxes-stacked"></i>
                    </div>

                    <div>
                        <h3>Documento e carga</h3>
                        <p>Informe o documento fiscal principal e os dados físicos da carga transportada.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group full">
                        <label>Chave NFe</label>

                        <input
                            type="text"
                            id="chaveNfe"
                            name="chaveNfe"
                            maxlength="44"
                            inputmode="numeric"
                            value="${frete.chaveNfe}"
                            placeholder="Informe os 44 dígitos da chave, se disponível"
                        />
                    </div>

                    <div class="form-group full">
                        <label>Natureza da Carga <span class="required">*</span></label>

                        <input
                            type="text"
                            name="naturezaCarga"
                            value="${frete.naturezaCarga}"
                            placeholder="Ex: eletrodomésticos, alimentos, insumos industriais"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Peso Bruto (kg) <span class="required">*</span></label>

                        <input
                            type="number"
                            step="0.01"
                            min="0.01"
                            name="pesoBruto"
                            value="${frete.pesoBruto}"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Volumes <span class="required">*</span></label>

                        <input
                            type="number"
                            min="1"
                            name="volumes"
                            value="${frete.volumes}"
                            required
                        />
                    </div>

                    <div class="form-group full">
                        <label>Distância (km) <span class="required">*</span></label>

                        <input
                            type="number"
                            step="0.01"
                            min="0.01"
                            name="distanciaKm"
                            value="${frete.distanciaKm}"
                            placeholder="Informe a distância total estimada do trajeto"
                            required
                        />
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-calculator"></i>
                    </div>

                    <div>
                        <h3>Tributação e faturamento</h3>
                        <p>Informe os valores manuais e acompanhe os campos calculados automaticamente pelo sistema.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group">
                        <label>Valor do Frete Bruto <span class="required">*</span></label>

                        <input
                            type="number"
                            step="0.01"
                            min="0.01"
                            id="valorFreteBruto"
                            name="valorFreteBruto"
                            value="${frete.valorFreteBruto}"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Valor do Pedágio</label>

                        <input
                            type="number"
                            step="0.01"
                            min="0"
                            id="valorPedagio"
                            name="valorPedagio"
                            value="${frete.valorPedagio}"
                        />
                    </div>

                    <div class="form-group">
                        <label>Alíquota de ICMS (%)</label>

                        <input
                            type="number"
                            step="0.01"
                            min="0"
                            id="aliquotaIcms"
                            name="aliquotaIcms"
                            value="${frete.aliquotaIcms}"
                            class="readonly-field"
                            readonly
                        />
                        <small class="field-hint">Calculada conforme origem e destino selecionados.</small>
                    </div>

                    <div class="form-group">
                        <label>Valor do ICMS</label>

                        <input
                            type="number"
                            step="0.01"
                            min="0"
                            id="valorIcms"
                            name="valorIcms"
                            value="${frete.valorIcms}"
                            class="readonly-field"
                            readonly
                        />
                        <small class="field-hint">Atualizado automaticamente a partir do valor bruto e da alíquota.</small>
                    </div>

                    <div class="form-group full">
                        <label>Valor Total <span class="required">*</span></label>

                        <input
                            type="number"
                            step="0.01"
                            min="0.01"
                            id="valorTotal"
                            name="valorTotal"
                            value="${frete.valorTotal}"
                            class="readonly-field"
                            readonly
                            required
                        />
                        <small class="field-hint">Soma automática do frete bruto, pedágio e ICMS.</small>
                    </div>

                </div>

            </div>

            <div class="form-section">

                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>

                    <div>
                        <h3>Prazo e códigos fiscais</h3>
                        <p>Defina a previsão de entrega e confira os códigos IBGE vinculados aos endereços selecionados.</p>
                    </div>
                </div>

                <div class="form-grid">

                    <div class="form-group">
                        <label>Previsão de Entrega <span class="required">*</span></label>

                        <input
                            type="date"
                            id="previsaoEntrega"
                            name="previsaoEntrega"
                            min="${hoje}"
                            value="${frete.previsaoEntrega}"
                            required
                        />
                    </div>

                    <div class="form-group">
                        <label>Origem IBGE</label>

                        <input
                            type="text"
                            id="origemIbge"
                            name="origemIbge"
                            maxlength="7"
                            inputmode="numeric"
                            value="${frete.origemIbge}"
                            class="readonly-field"
                            readonly
                        />
                        <small class="field-hint">Preenchido automaticamente conforme o endereço de origem.</small>
                    </div>

                    <div class="form-group">
                        <label>Destino IBGE</label>

                        <input
                            type="text"
                            id="destinoIbge"
                            name="destinoIbge"
                            maxlength="7"
                            inputmode="numeric"
                            value="${frete.destinoIbge}"
                            class="readonly-field"
                            readonly
                        />
                        <small class="field-hint">Preenchido automaticamente conforme o endereço de destino.</small>
                    </div>

                </div>

            </div>

            <div class="form-actions">
                <a href="fretes" class="btn-small">
                    <i class="fas fa-arrow-left"></i>
                    Cancelar
                </a>

                <button type="submit" class="btn-primary">
                    <i class="fas fa-save"></i>
                    ${not empty frete.id ? 'Atualizar Frete' : 'Salvar Frete'}
                </button>
            </div>

        </form>

    </section>

</main>

<script src="/RichardFretes/js/funcoesCadastroF.js"></script>

</body>
</html>
