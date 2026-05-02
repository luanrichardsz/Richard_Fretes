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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

</head>

<body>

<header class="top-header">
    <a href="menu" class="logo-btn" title="Home"><i class="fas fa-home"></i></a>
</header>

<div class="container">

  <section class="card">
    <div class="status-header">
      <div>
        <h2 style="margin: 0 0 6px 0;">Frete ${frete.numeroFrete}</h2>
        <div class="muted">Acompanhe a operação, etapas concluídas e ocorrências registradas.</div>
      </div>
      <div class="stack">
        <span class="badge ${frete.status == 'ENTREGUE' ? 'green' : frete.status == 'NAO_ENTREGUE' || frete.status == 'CANCELADO' ? 'red' : frete.status == 'EM_TRANSITO' ? 'blue' : 'gray'}">
          ${frete.status}
        </span>
        <a href="fretes"><button type="button" class="btn-neutral">Voltar</button></a>
        <a href="fretes?acao=editar&id=${frete.id}"><button type="button" class="btn-small">Editar Cadastro</button></a>
      </div>
    </div>
  </section>

  <c:if test="${not empty erro}">
    <section class="card">
      <div style="padding: 12px; border-radius: 8px; background: #fdecea; color: #b42318; border: 1px solid #f5c2c7;">
        ${erro}
      </div>
    </section>
  </c:if>

  <section class="card">
    <h3>Resumo da Operação</h3>
    <div class="detail-grid">
      <div class="detail-item">
        <strong>Remetente</strong>
        <span>${not empty remetente.nomeFantasia ? remetente.nomeFantasia : remetente.razaoSocial}</span>
      </div>
      <div class="detail-item">
        <strong>Destinatário</strong>
        <span>${not empty destinatario.nomeFantasia ? destinatario.nomeFantasia : destinatario.razaoSocial}</span>
      </div>
      <div class="detail-item">
        <strong>Motorista</strong>
        <span>${motorista.nomeCompleto}</span>
      </div>
      <div class="detail-item">
        <strong>Veículo</strong>
        <span>${veiculo.placa} - ${veiculo.tipo}</span>
      </div>
      <div class="detail-item">
        <strong>Natureza da Carga</strong>
        <span>${frete.naturezaCarga}</span>
      </div>
      <div class="detail-item">
        <strong>Peso Bruto</strong>
        <span>${frete.pesoBruto} kg</span>
      </div>
      <div class="detail-item">
        <strong>Valor Total</strong>
        <span>R$ <fmt:formatNumber value="${frete.valorTotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
      </div>
      <div class="detail-item">
        <strong>Previsão de Entrega</strong>
        <span>${frete.previsaoEntrega}</span>
      </div>
      <div class="detail-item">
        <strong>Data de Emissão</strong>
        <span>${frete.dataEmissao}</span>
      </div>
      <div class="detail-item">
        <strong>Data de Saída</strong>
        <span>${not empty frete.dataSaida ? frete.dataSaida : 'Aguardando confirmação'}</span>
      </div>
      <div class="detail-item">
        <strong>Data de Entrega</strong>
        <span>${not empty frete.dataEntrega ? frete.dataEntrega : 'Ainda não finalizado'}</span>
      </div>
      <div class="detail-item">
        <strong>Última Ocorrência</strong>
        <span>${not empty ultimaOcorrencia ? ultimaOcorrencia.tipo : 'Nenhuma registrada'}</span>
      </div>
      <c:if test="${not empty frete.motivoFalha}">
        <div class="detail-item">
          <strong>Motivo da Não Entrega</strong>
          <span>${frete.motivoFalha}</span>
        </div>
      </c:if>
    </div>
  </section>

  <section class="card">
    <h3>Rota</h3>
    <div class="detail-grid">
      <div class="detail-item">
        <strong>Origem</strong>
        <span>${enderecoOrigem.logradouro}, ${enderecoOrigem.numero} - ${enderecoOrigem.municipio}/${enderecoOrigem.uf}</span>
      </div>
      <div class="detail-item">
        <strong>Destino</strong>
        <span>${enderecoDestino.logradouro}, ${enderecoDestino.numero} - ${enderecoDestino.municipio}/${enderecoDestino.uf}</span>
      </div>
      <div class="detail-item">
        <strong>IBGE Origem</strong>
        <span>${frete.origemIbge}</span>
      </div>
      <div class="detail-item">
        <strong>IBGE Destino</strong>
        <span>${frete.destinoIbge}</span>
      </div>
    </div>
  </section>

  <section class="card">
    <h3>Etapas do Frete</h3>
    <div class="timeline">
      <div class="timeline-step ${frete.status == 'EMITIDO' ? 'active' : frete.status != 'EMITIDO' ? 'done' : ''}">
        <strong>1. Emitido</strong>
        <span>Frete criado e liberado para acompanhamento.</span>
      </div>
      <div class="timeline-step ${frete.status == 'SAIDA_CONFIRMADA' ? 'active' : frete.status == 'EM_TRANSITO' || frete.status == 'ENTREGUE' || frete.status == 'NAO_ENTREGUE' ? 'done' : ''}">
        <strong>2. Saída Confirmada</strong>
        <span>${not empty frete.dataSaida ? frete.dataSaida : 'Saída ainda não confirmada.'}</span>
      </div>
      <div class="timeline-step ${frete.status == 'EM_TRANSITO' ? 'active' : frete.status == 'ENTREGUE' || frete.status == 'NAO_ENTREGUE' ? 'done' : ''}">
        <strong>3. Em Trânsito</strong>
        <span>Viagem em andamento e apta para receber ocorrências.</span>
      </div>
      <div class="timeline-step ${frete.status == 'ENTREGUE' ? 'done' : frete.status == 'NAO_ENTREGUE' ? 'final-negative' : frete.status == 'CANCELADO' ? 'final-negative' : ''}">
        <strong>4. Finalização</strong>
        <span>
          <c:choose>
            <c:when test="${frete.status == 'ENTREGUE'}">Entrega concluída com sucesso.</c:when>
            <c:when test="${frete.status == 'NAO_ENTREGUE'}">Frete finalizado sem entrega.</c:when>
            <c:when test="${frete.status == 'CANCELADO'}">Frete cancelado.</c:when>
            <c:otherwise>Aguardando fechamento da operação.</c:otherwise>
          </c:choose>
        </span>
      </div>
    </div>
  </section>

  <section class="card">
    <h3>Ações Operacionais</h3>
    <div class="actions-grid">
      <c:if test="${frete.status == 'EMITIDO'}">
        <div class="action-card">
          <h3>Confirmar Saída</h3>
          <p>Registra a saída do frete e coloca o veículo em viagem na mesma operação.</p>
          <form action="fretes" method="post">
            <input type="hidden" name="id" value="${frete.id}" />
            <input type="hidden" name="acaoFrete" value="confirmarSaida" />
            <button type="submit" class="btn-primary">Confirmar Saída</button>
          </form>
        </div>
        <div class="action-card">
          <h3>Cancelar Frete</h3>
          <p>Use quando a operação não será iniciada e o frete precisa ser encerrado.</p>
          <form action="fretes" method="post">
            <input type="hidden" name="id" value="${frete.id}" />
            <input type="hidden" name="acaoFrete" value="cancelarFrete" />
            <button type="submit" class="btn-danger">Cancelar Frete</button>
          </form>
        </div>
      </c:if>

      <c:if test="${frete.status == 'SAIDA_CONFIRMADA'}">
        <div class="action-card">
          <h3>Iniciar Trânsito</h3>
          <p>Avança a operação para em trânsito e libera o fluxo de entrega final.</p>
          <form action="fretes" method="post">
            <input type="hidden" name="id" value="${frete.id}" />
            <input type="hidden" name="acaoFrete" value="iniciarTransito" />
            <button type="submit" class="btn-primary">Marcar Em Trânsito</button>
          </form>
        </div>
        <div class="action-card">
          <h3>Registrar Ocorrência</h3>
          <p>Lance um evento operacional intermediário para manter o histórico do frete.</p>
          <a href="ocorrencias?acao=novo&freteId=${frete.id}&retornoFreteId=${frete.id}">
            <button type="button" class="btn-neutral">Nova Ocorrência</button>
          </a>
        </div>
      </c:if>

      <c:if test="${frete.status == 'EM_TRANSITO'}">
        <div class="action-card">
          <h3>Registrar Entrega Realizada</h3>
          <p>Abre o cadastro da ocorrência final de entrega, exigindo recebedor e documento.</p>
          <a href="ocorrencias?acao=novo&freteId=${frete.id}&tipo=ENTREGA_REALIZADA&retornoFreteId=${frete.id}">
            <button type="button" class="btn-primary">Informar Entrega</button>
          </a>
        </div>
        <div class="action-card">
          <h3>Cadastrar Ocorrência</h3>
          <p>Use para avaria, extravio, tentativa de entrega ou atualizações da viagem.</p>
          <a href="ocorrencias?acao=novo&freteId=${frete.id}&retornoFreteId=${frete.id}">
            <button type="button" class="btn-neutral">Nova Ocorrência</button>
          </a>
        </div>
        <div class="action-card">
          <h3>Finalizar como Não Entregue</h3>
          <p>Encerra o frete e devolve o veículo para disponível. Informe o motivo abaixo.</p>
          <form action="fretes" method="post" class="inline-form">
            <input type="hidden" name="id" value="${frete.id}" />
            <input type="hidden" name="acaoFrete" value="marcarNaoEntregue" />
            <textarea name="motivoFalha" placeholder="Descreva o motivo da não entrega" required></textarea>
            <button type="submit" class="btn-danger">Marcar Não Entregue</button>
          </form>
        </div>
      </c:if>

      <c:if test="${frete.status == 'ENTREGUE' || frete.status == 'NAO_ENTREGUE' || frete.status == 'CANCELADO'}">
        <div class="action-card">
          <h3>Frete Finalizado</h3>
          <p>Essa operação não recebe novas ocorrências. O histórico abaixo permanece disponível para consulta.</p>
        </div>
      </c:if>
    </div>
  </section>

  <section class="card">
    <div class="status-header">
      <div>
        <h3 style="margin: 0 0 6px 0;">Ocorrências do Frete</h3>
        <div class="muted">Histórico operacional em ordem cronológica inversa.</div>
      </div>
      <a href="ocorrencias"><button type="button" class="btn-small">Abrir Consulta de Ocorrências</button></a>
    </div>

    <div class="occurrence-list" style="margin-top: 16px;">
      <c:choose>
        <c:when test="${not empty ocorrencias}">
          <c:forEach var="ocorrencia" items="${ocorrencias}">
            <div class="occurrence-card">
              <div class="occurrence-card-header">
                <div>
                  <strong>${ocorrencia.tipo}</strong>
                  <div class="muted">${ocorrencia.dataHora}</div>
                </div>
                <span class="badge blue">${ocorrencia.municipio}/${ocorrencia.uf}</span>
              </div>

              <c:if test="${not empty ocorrencia.descricao}">
                <p style="margin-bottom: 0;">${ocorrencia.descricao}</p>
              </c:if>

              <c:if test="${not empty ocorrencia.recebedorNome || not empty ocorrencia.recebedorDocumento}">
                <p class="muted" style="margin-bottom: 0;">
                  Recebedor: ${ocorrencia.recebedorNome}
                  <c:if test="${not empty ocorrencia.recebedorDocumento}">
                    - ${ocorrencia.recebedorDocumento}
                  </c:if>
                </p>
              </c:if>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="occurrence-card">
            <strong>Nenhuma ocorrência registrada</strong>
            <p class="muted" style="margin-bottom: 0;">Use as ações acima para começar a acompanhar a operação em detalhes.</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </section>

</div>

</body>
</html>
