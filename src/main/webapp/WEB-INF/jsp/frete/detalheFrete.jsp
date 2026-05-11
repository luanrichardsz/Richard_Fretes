<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Detalhes do Frete</title>

    <link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="/RichardFretes/css/styleC.css" />
    <link rel="stylesheet" href="/RichardFretes/css/styleDetalheFrete.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>

<body class="frete-detail-page">

<header class="top-header">
    <a href="menu" class="logo-btn" title="Voltar" onclick="if (window.history.length > 1) { window.history.back(); return false; }">
        <i class="fas fa-arrow-left"></i>
    </a>
    <a href="menu" class="logo-btn" title="Voltar ao menu">
        <i class="fas fa-home"></i>
    </a>
</header>

<main class="container">

    <c:set
        var="statusClass"
        value="${frete.status == 'ENTREGUE' ? 'green' :
            frete.status == 'EM_TRANSITO' ? 'blue' :
            frete.status == 'SAIDA_CONFIRMADA' ? 'orange' :
            frete.status == 'EMITIDO' ? 'gray' : 'red'}"
    />
    <c:set
        var="statusIcon"
        value="${frete.status == 'ENTREGUE' ? 'fa-circle-check' :
            frete.status == 'EM_TRANSITO' ? 'fa-route' :
            frete.status == 'SAIDA_CONFIRMADA' ? 'fa-truck' :
            frete.status == 'EMITIDO' ? 'fa-file-signature' :
            frete.status == 'CANCELADO' ? 'fa-ban' : 'fa-triangle-exclamation'}"
    />
    <c:set
        var="statusLabel"
        value="${frete.status == 'ENTREGUE' ? 'Entregue' :
            frete.status == 'EM_TRANSITO' ? 'Em trânsito' :
            frete.status == 'SAIDA_CONFIRMADA' ? 'Saída confirmada' :
            frete.status == 'EMITIDO' ? 'Emitido' :
            frete.status == 'NAO_ENTREGUE' ? 'Não entregue' : 'Cancelado'}"
    />

    <div class="page-heading detail-heading">
        <div>
            <span>Operação em detalhes</span>
            <h1>Frete ${frete.numeroFrete}</h1>
            <p>
                Visualize participantes, rota, progresso da viagem, histórico operacional e ações disponíveis para a etapa atual do frete.
            </p>
        </div>

        <div class="detail-heading-actions">
            <span class="badge status-badge ${statusClass}">
                <i class="fas ${statusIcon}"></i>
                ${statusLabel}
            </span>

            <a href="fretes" class="btn-small">
                <i class="fas fa-arrow-left"></i>
                Voltar
            </a>

            <c:if test="${frete.status == 'EMITIDO'}">
                <a href="fretes?acao=editar&id=${frete.id}" class="btn-primary">
                    <i class="fas fa-pen"></i>
                    Editar Frete
                </a>
            </c:if>
        </div>
    </div>

    <c:if test="${not empty erro}">
        <section class="card">
            <div class="alert alert-error">
                <i class="fas fa-circle-exclamation"></i>
                ${erro}
            </div>
        </section>
    </c:if>

    <section class="summary-grid detail-summary-grid">

        <div class="summary-card">
            <div class="summary-icon">
                <i class="fas fa-money-bill-wave"></i>
            </div>

            <div>
                <span>Valor total</span>
                <strong>R$ <fmt:formatNumber value="${frete.valorTotal}" minFractionDigits="2" maxFractionDigits="2"/></strong>
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon green-icon">
                <i class="fas fa-calendar-check"></i>
            </div>

            <div>
                <span>Previsão</span>
                <strong class="summary-date mask-date" data-iso="${frete.previsaoEntrega}">${frete.previsaoEntrega}</strong>
            </div>
        </div>

        <div class="summary-card">
            <div class="summary-icon red-icon">
                <i class="fas fa-file-lines"></i>
            </div>

            <div>
                <span>Ocorrências</span>
                <strong>${empty ocorrencias ? 0 : ocorrencias.size()}</strong>
            </div>
        </div>

    </section>

    <section class="card detail-card">
        <div class="table-header detail-section-header">
            <div>
                <span class="section-label">Resumo</span>
                <h2>Visão geral da operação</h2>
                <p class="section-copy">Os dados foram separados por contexto para facilitar a leitura operacional.</p>
            </div>
        </div>

        <div class="overview-layout">
            <div class="overview-group">
                <div class="overview-group-header">
                    <div class="overview-group-icon">
                        <i class="fas fa-users"></i>
                    </div>

                    <div>
                        <h3>Participantes da operação</h3>
                        <p>Quem emite, recebe e executa o transporte.</p>
                    </div>
                </div>

                <div class="detail-grid compact-grid">
                    <div class="detail-item emphasis-card">
                        <small>Remetente</small>
                        <strong>${not empty remetente.nomeFantasia ? remetente.nomeFantasia : remetente.razaoSocial}</strong>
                        <span>Empresa responsável pela emissão</span>
                    </div>

                    <div class="detail-item emphasis-card">
                        <small>Destinatário</small>
                        <strong>${not empty destinatario.nomeFantasia ? destinatario.nomeFantasia : destinatario.razaoSocial}</strong>
                        <span>Cliente que receberá a carga</span>
                    </div>

                    <div class="detail-item">
                        <small>Motorista</small>
                        <strong>${motorista.nomeCompleto}</strong>
                        <span>Condutor vinculado à viagem</span>
                    </div>

                    <div class="detail-item">
                        <small>Veículo</small>
                        <strong>${veiculo.placa} - ${veiculo.tipo}</strong>
                        <span>Unidade operacional selecionada</span>
                    </div>
                </div>
            </div>

            <div class="overview-group">
                <div class="overview-group-header">
                    <div class="overview-group-icon">
                        <i class="fas fa-boxes"></i>
                    </div>

                    <div>
                        <h3>Carga e informação comercial</h3>
                        <p>O que está sendo transportado e o valor financeiro da operação.</p>
                    </div>
                </div>

                <div class="detail-grid compact-grid">
                    <div class="detail-item">
                        <small>Natureza da carga</small>
                        <strong>${frete.naturezaCarga}</strong>
                        <span>Descrição principal da mercadoria</span>
                    </div>

                    <div class="detail-item">
                        <small>Peso bruto</small>
                        <strong>${frete.pesoBruto} kg</strong>
                        <span>Carga total informada no frete</span>
                    </div>

                    <div class="detail-item">
                        <small>Valor total</small>
                        <strong>R$ <fmt:formatNumber value="${frete.valorTotal}" minFractionDigits="2" maxFractionDigits="2"/></strong>
                        <span>Montante final registrado para o frete</span>
                    </div>

                    <div class="detail-item">
                        <small>Última ocorrência</small>
                        <strong>${not empty ultimaOcorrencia ? ultimaOcorrencia.tipo : 'Nenhuma registrada'}</strong>
                        <span>A atualização mais recente da operação</span>
                    </div>
                </div>
            </div>

            <div class="overview-group">
                <div class="overview-group-header">
                    <div class="overview-group-icon">
                        <i class="fas fa-clock"></i>
                    </div>

                    <div>
                        <h3>Acompanhamento temporal</h3>
                        <p>Marcos de emissão, saída, entrega e fechamento operacional.</p>
                    </div>
                </div>

                <div class="detail-grid compact-grid">
                    <div class="detail-item">
                        <small>Emissão</small>
                        <strong class="mask-datetime" data-iso="${frete.dataEmissao}">${frete.dataEmissao}</strong>
                        <span>Momento em que o frete foi criado</span>
                    </div>

                    <div class="detail-item">
                        <small>Saída</small>
                        <strong class="mask-datetime" data-iso="${frete.dataSaida}">
                            ${not empty frete.dataSaida ? frete.dataSaida : 'Aguardando confirmação'}
                        </strong>
                        <span>Confirmação de início efetivo da viagem</span>
                    </div>

                    <div class="detail-item">
                        <small>Entrega</small>
                        <strong class="mask-datetime" data-iso="${frete.dataEntrega}">
                            ${not empty frete.dataEntrega ? frete.dataEntrega : 'Ainda não finalizado'}
                        </strong>
                        <span>Fechamento operacional da entrega</span>
                    </div>

                    <div class="detail-item">
                        <small>Previsão de entrega</small>
                        <strong class="mask-date" data-iso="${frete.previsaoEntrega}">${frete.previsaoEntrega}</strong>
                        <span>Prazo previsto para conclusão da viagem</span>
                    </div>
                </div>
            </div>

            <c:if test="${not empty frete.motivoFalha}">
                <div class="detail-item full-width danger-surface">
                    <small>Motivo da não entrega</small>
                    <strong>${frete.motivoFalha}</strong>
                    <span>Informação registrada no encerramento sem entrega</span>
                </div>
            </c:if>
        </div>
    </section>

    <section class="card detail-card">
        <div class="table-header detail-section-header">
            <div>
                <span class="section-label">Rota</span>
                <h2>Origem, destino e códigos fiscais</h2>
            </div>
        </div>

        <div class="route-grid">
            <div class="route-card">
                <div class="route-card-icon">
                    <i class="fas fa-location-dot"></i>
                </div>

                <div>
                    <small>Origem</small>
                    <strong>${enderecoOrigem.logradouro}, ${enderecoOrigem.numero}</strong>
                    <span>${enderecoOrigem.municipio}/${enderecoOrigem.uf}</span>
                    <em>IBGE ${frete.origemIbge}</em>
                </div>
            </div>

            <div class="route-card">
                <div class="route-card-icon destination-icon">
                    <i class="fas fa-flag-checkered"></i>
                </div>

                <div>
                    <small>Destino</small>
                    <strong>${enderecoDestino.logradouro}, ${enderecoDestino.numero}</strong>
                    <span>${enderecoDestino.municipio}/${enderecoDestino.uf}</span>
                    <em>IBGE ${frete.destinoIbge}</em>
                </div>
            </div>
        </div>
    </section>

    <section class="card detail-card">
        <div class="table-header detail-section-header">
            <div>
                <span class="section-label">Jornada</span>
                <h2>Etapas do frete</h2>
            </div>
        </div>

        <div class="timeline">
            <div class="timeline-step ${frete.status == 'EMITIDO' ? 'active' : frete.status != 'EMITIDO' ? 'done' : ''}">
                <strong>1. Emitido</strong>
                <span>Frete criado e pronto para acompanhamento operacional.</span>
            </div>

            <div class="timeline-step ${frete.status == 'SAIDA_CONFIRMADA' ? 'active' : frete.status == 'EM_TRANSITO' || frete.status == 'ENTREGUE' || frete.status == 'NAO_ENTREGUE' ? 'done' : ''}">
                <strong>2. Saída confirmada</strong>
                <span class="mask-datetime" data-iso="${frete.dataSaida}">
                    ${not empty frete.dataSaida ? frete.dataSaida : 'Saída ainda não confirmada.'}
                </span>
            </div>

            <div class="timeline-step ${frete.status == 'EM_TRANSITO' ? 'active' : frete.status == 'ENTREGUE' || frete.status == 'NAO_ENTREGUE' ? 'done' : ''}">
                <strong>3. Em trânsito</strong>
                <span>Viagem em andamento e pronta para receber ocorrências.</span>
            </div>

            <div class="timeline-step ${frete.status == 'ENTREGUE' ? 'done' : frete.status == 'NAO_ENTREGUE' || frete.status == 'CANCELADO' ? 'final-negative' : ''}">
                <strong>4. Finalização</strong>
                <span>
                    <c:choose>
                        <c:when test="${frete.status == 'ENTREGUE'}">Entrega concluída com sucesso.</c:when>
                        <c:when test="${frete.status == 'NAO_ENTREGUE'}">Frete encerrado sem entrega.</c:when>
                        <c:when test="${frete.status == 'CANCELADO'}">Operação cancelada antes da conclusão.</c:when>
                        <c:otherwise>Aguardando fechamento da operação.</c:otherwise>
                    </c:choose>
                </span>
            </div>
        </div>
    </section>

    <section class="card detail-card">
        <div class="table-header detail-section-header">
            <div>
                <span class="section-label">Ações</span>
                <h2>Próximos passos da operação</h2>
            </div>
        </div>

        <div class="actions-grid">
            <c:if test="${frete.status == 'EMITIDO'}">
                <div class="action-card">
                    <div class="action-card-top">
                        <div class="action-card-icon">
                            <i class="fas fa-truck-fast"></i>
                        </div>
                        <span class="badge blue">Próxima etapa</span>
                    </div>

                    <h3>Confirmar saída</h3>
                    <p>Registra a saída do frete e coloca o veículo em viagem na mesma operação.</p>

                    <form action="fretes" method="post">
                        <input type="hidden" name="id" value="${frete.id}" />
                        <input type="hidden" name="acaoFrete" value="confirmarSaida" />
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-check"></i>
                            Confirmar Saída
                        </button>
                    </form>
                </div>

                <div class="action-card">
                    <div class="action-card-top">
                        <div class="action-card-icon">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                        <span class="badge gray">Histórico</span>
                    </div>

                    <h3>Registrar ocorrência</h3>
                    <p>Use para saída do pátio ou qualquer observação operacional. Só a ocorrência de entrega realizada encerra o frete.</p>

                    <a href="ocorrencias?acao=novo&freteId=${frete.id}&retornoFreteId=${frete.id}" class="btn-small">
                        <i class="fas fa-plus"></i>
                        Nova Ocorrência
                    </a>
                </div>

                <div class="action-card danger-card">
                    <div class="action-card-top">
                        <div class="action-card-icon danger-icon">
                            <i class="fas fa-ban"></i>
                        </div>
                        <span class="badge red">Encerramento</span>
                    </div>

                    <h3>Cancelar frete</h3>
                    <p>Use quando a operação não será iniciada e o frete precisa ser encerrado.</p>

                    <form action="fretes" method="post">
                        <input type="hidden" name="id" value="${frete.id}" />
                        <input type="hidden" name="acaoFrete" value="cancelarFrete" />
                        <button type="submit" class="btn-danger action-button-danger">
                            <i class="fas fa-xmark"></i>
                            Cancelar Frete
                        </button>
                    </form>
                </div>
            </c:if>

            <c:if test="${frete.status == 'SAIDA_CONFIRMADA'}">
                <div class="action-card">
                    <div class="action-card-top">
                        <div class="action-card-icon">
                            <i class="fas fa-route"></i>
                        </div>
                        <span class="badge blue">Próxima etapa</span>
                    </div>

                    <h3>Iniciar trânsito</h3>
                    <p>Avança a operação para em trânsito e libera o fluxo de entrega final.</p>

                    <form action="fretes" method="post">
                        <input type="hidden" name="id" value="${frete.id}" />
                        <input type="hidden" name="acaoFrete" value="iniciarTransito" />
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-truck-fast"></i>
                            Marcar Em Trânsito
                        </button>
                    </form>
                </div>

                <div class="action-card">
                    <div class="action-card-top">
                        <div class="action-card-icon">
                            <i class="fas fa-triangle-exclamation"></i>
                        </div>
                        <span class="badge gray">Histórico</span>
                    </div>

                    <h3>Registrar ocorrência</h3>
                    <p>Lance um evento operacional intermediário. Essas ocorrências mantêm o frete em andamento e não encerram a entrega.</p>

                    <a href="ocorrencias?acao=novo&freteId=${frete.id}&retornoFreteId=${frete.id}" class="btn-small">
                        <i class="fas fa-plus"></i>
                        Nova Ocorrência
                    </a>
                </div>
            </c:if>

            <c:if test="${frete.status == 'EM_TRANSITO'}">
                <div class="action-card">
                    <div class="action-card-top">
                        <div class="action-card-icon">
                            <i class="fas fa-circle-check"></i>
                        </div>
                        <span class="badge green">Conclusão</span>
                    </div>

                    <h3>Registrar entrega realizada</h3>
                    <p>Abra o comprovante digital com recebedor, foto, horário e localização automática da entrega.</p>

                    <a href="ocorrencias?acao=novo&freteId=${frete.id}&tipo=ENTREGA_REALIZADA&retornoFreteId=${frete.id}" class="btn-primary">
                        <i class="fas fa-box-open"></i>
                        Informar Entrega
                    </a>
                </div>

                <div class="action-card">
                    <div class="action-card-top">
                        <div class="action-card-icon">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                        <span class="badge gray">Histórico</span>
                    </div>

                    <h3>Cadastrar ocorrência</h3>
                    <p>Use para avaria, extravio, tentativa de entrega ou atualizações da viagem. Só a entrega realizada fecha o frete.</p>

                    <a href="ocorrencias?acao=novo&freteId=${frete.id}&retornoFreteId=${frete.id}" class="btn-small">
                        <i class="fas fa-plus"></i>
                        Nova Ocorrência
                    </a>
                </div>

                <div class="action-card danger-card">
                    <div class="action-card-top">
                        <div class="action-card-icon danger-icon">
                            <i class="fas fa-triangle-exclamation"></i>
                        </div>
                        <span class="badge red">Exige motivo</span>
                    </div>

                    <h3>Finalizar como não entregue</h3>
                    <p>Encerra o frete e devolve o veículo para disponível. Explique o motivo no campo abaixo.</p>

                    <form action="fretes" method="post" class="inline-form">
                        <input type="hidden" name="id" value="${frete.id}" />
                        <input type="hidden" name="acaoFrete" value="marcarNaoEntregue" />
                        <textarea name="motivoFalha" placeholder="Descreva o motivo da não entrega" required></textarea>
                        <button type="submit" class="btn-danger action-button-danger">
                            <i class="fas fa-flag"></i>
                            Marcar Não Entregue
                        </button>
                    </form>
                </div>
            </c:if>

            <c:if test="${frete.status == 'ENTREGUE' || frete.status == 'NAO_ENTREGUE' || frete.status == 'CANCELADO'}">
                <div class="action-card finished-card">
                    <div class="action-card-top">
                        <div class="action-card-icon">
                            <i class="fas fa-lock"></i>
                        </div>
                        <span class="badge gray">Somente consulta</span>
                    </div>

                    <h3>Frete finalizado</h3>
                    <p>Essa operação não recebe novas ocorrências. O histórico abaixo permanece disponível para consulta completa.</p>
                </div>
            </c:if>
        </div>
    </section>

    <section class="card detail-card">
        <div class="table-header detail-section-header">
            <div>
                <span class="section-label">Histórico</span>
                <h2>Ocorrências do frete</h2>
                <p class="section-copy">Histórico operacional em ordem cronológica inversa.</p>
            </div>

            <!-- <a href="ocorrencias" class="btn-small">
                <i class="fas fa-list"></i>
                Abrir Consulta de Ocorrências
            </a> -->
        </div>

        <div class="occurrence-list">
            <c:choose>
                <c:when test="${not empty ocorrencias}">
                    <c:forEach var="ocorrencia" items="${ocorrencias}">
                        <div class="occurrence-card">
                            <div class="occurrence-card-header">
                                <div>
                                    <strong>${ocorrencia.tipo}</strong>
                                    <div class="muted mask-datetime" data-iso="${ocorrencia.dataHora}">${ocorrencia.dataHora}</div>
                                </div>

                                <span class="badge blue">${ocorrencia.municipio}/${ocorrencia.uf}</span>
                            </div>

                            <c:if test="${not empty ocorrencia.descricao}">
                                <p class="occurrence-text">${ocorrencia.descricao}</p>
                            </c:if>

                            <c:if test="${not empty ocorrencia.recebedorNome || not empty ocorrencia.recebedorDocumento}">
                                <p class="muted occurrence-meta">
                                    Recebedor: ${ocorrencia.recebedorNome}
                                    <c:if test="${not empty ocorrencia.recebedorDocumento}">
                                        - ${ocorrencia.recebedorDocumento}
                                    </c:if>
                                </p>
                            </c:if>

                            <c:if test="${not empty ocorrencia.latitude && not empty ocorrencia.longitude}">
                                <p class="muted occurrence-meta">
                                    Localização: ${ocorrencia.latitude}, ${ocorrencia.longitude}
                                    <a
                                        href="https://www.google.com/maps?q=${ocorrencia.latitude},${ocorrencia.longitude}"
                                        target="_blank"
                                        rel="noopener noreferrer"
                                        class="occurrence-evidence-link"
                                    >
                                        Abrir no mapa
                                    </a>
                                </p>
                            </c:if>

                            <c:if test="${not empty ocorrencia.fotoEvidenciaUrl}">
                                <div class="occurrence-evidence">
                                    <a
                                        href="${ocorrencia.fotoEvidenciaUrl}"
                                        target="_blank"
                                        rel="noopener noreferrer"
                                        class="occurrence-evidence-link"
                                    >
                                        Abrir evidência
                                    </a>
                                    <img
                                        src="${ocorrencia.fotoEvidenciaUrl}"
                                        alt="Foto de evidência da ocorrência ${ocorrencia.tipo}"
                                        class="occurrence-evidence-image"
                                    />
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <div class="occurrence-card empty-occurrence-card">
                        <strong>Nenhuma ocorrência registrada</strong>
                        <p class="muted occurrence-meta">Use as ações acima para começar a acompanhar a operação em detalhes.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

</main>

<script src="/RichardFretes/js/funcoesDetalheFrete.js"></script>

</body>
</html>
