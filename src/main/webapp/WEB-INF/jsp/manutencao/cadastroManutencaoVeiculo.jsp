<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>${not empty manutencao.id ? 'Editar Manutenção' : 'Nova Manutenção'}</title>

    <link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
    <link rel="stylesheet" href="/RichardFretes/css/styleC.css" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        .maintenance-overview-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }
        .maintenance-overview-card {
            min-width: 0;
            padding: 18px;
            border-radius: 20px;
            background:
                radial-gradient(circle at top right, rgba(47, 124, 255, 0.08), transparent 36%),
                rgba(255, 255, 255, 0.035);
            border: 1px solid var(--border);
        }
        .maintenance-overview-card small {
            display: block;
            color: var(--muted);
            font-size: 0.7rem;
            font-weight: 900;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            margin-bottom: 8px;
        }
        .maintenance-overview-card strong {
            display: block;
            color: var(--text);
            font-size: 1rem;
            font-weight: 900;
        }
        .maintenance-overview-card span {
            display: block;
            color: var(--text-soft);
            font-size: 0.82rem;
            font-weight: 700;
            line-height: 1.55;
            margin-top: 8px;
        }
        .locked-vehicle-field {
            min-height: 54px;
            padding: 14px 16px;
            border-radius: 18px;
            border: 1px dashed var(--border-strong);
            background:
                linear-gradient(180deg, rgba(255, 255, 255, 0.05), rgba(255, 255, 255, 0.035)),
                rgba(148, 163, 184, 0.08);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
        }
        .locked-vehicle-copy {
            min-width: 0;
        }
        .locked-vehicle-copy strong {
            display: block;
            color: var(--text);
            font-size: 0.96rem;
            font-weight: 900;
        }
        .locked-vehicle-copy span {
            display: block;
            margin-top: 5px;
            color: var(--text-soft);
            font-size: 0.8rem;
            font-weight: 700;
            line-height: 1.45;
        }
        .locked-vehicle-badge {
            flex-shrink: 0;
            padding: 8px 11px;
            border-radius: 999px;
            background: rgba(47, 124, 255, 0.14);
            border: 1px solid rgba(47, 124, 255, 0.22);
            color: var(--royal-light);
            font-size: 0.72rem;
            font-weight: 900;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }
        .select-helper {
            margin-top: 10px;
            color: var(--muted);
            font-size: 0.78rem;
            font-weight: 700;
            line-height: 1.5;
        }
        @media (max-width: 768px) {
            .maintenance-overview-grid {
                grid-template-columns: 1fr;
            }
            .locked-vehicle-field {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
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

    <c:url var="urlVoltarManutencoes" value="manutencoes">
        <c:if test="${not empty manutencao.veiculoId}">
            <c:param name="veiculoId" value="${manutencao.veiculoId}" />
        </c:if>
    </c:url>

    <div class="page-heading">
        <div>
            <span>Gestão de manutenção</span>
            <h1>${not empty manutencao.id ? 'Editar Manutenção' : 'Nova Manutenção'}</h1>
            <p>Planeje preventivas, registre corretivas e mantenha a disponibilidade da frota sob controle.</p>
        </div>
    </div>

    <section class="card">
        <c:if test="${not empty erro}">
            <div class="alert alert-error">
                <i class="fas fa-circle-exclamation"></i>
                ${erro}
            </div>
        </c:if>

        <c:if test="${not empty veiculoSelecionado}">
            <div class="form-section">
                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-truck"></i>
                    </div>
                    <div>
                        <h3>Veículo selecionado</h3>
                        <p>${veiculoSelecionado.placa} - ${veiculoSelecionado.tipo}</p>
                    </div>
                </div>

                <c:if test="${not empty resumoVeiculo}">
                    <div class="maintenance-overview-grid">
                        <div class="maintenance-overview-card">
                            <small>Próxima manutenção</small>
                            <strong>${not empty resumoVeiculo.proximaDataPrevista ? resumoVeiculo.proximaDataPrevista : 'Sem agenda'}</strong>
                            <span>${not empty resumoVeiculo.proximaDescricao ? resumoVeiculo.proximaDescricao : 'Nenhuma manutenção agendada.'}</span>
                        </div>
                        <div class="maintenance-overview-card">
                            <small>Última concluída</small>
                            <strong>${not empty resumoVeiculo.ultimaDataRealizacao ? resumoVeiculo.ultimaDataRealizacao : 'Sem histórico'}</strong>
                            <span>${not empty resumoVeiculo.ultimaDescricao ? resumoVeiculo.ultimaDescricao : 'Nenhuma manutenção concluída.'}</span>
                        </div>
                    </div>
                </c:if>
            </div>
        </c:if>

        <form action="manutencoes" method="post">
            <c:if test="${not empty manutencao.id}">
                <input type="hidden" name="id" value="${manutencao.id}" />
            </c:if>

            <div class="form-section">
                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-clipboard-list"></i>
                    </div>
                    <div>
                        <h3>Planejamento</h3>
                        <p>Defina o veículo, o tipo de manutenção e o status do processo.</p>
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group full">
                        <label>Veículo <span class="required">*</span></label>
                        <c:choose>
                            <c:when test="${veiculoTravado and not empty veiculoSelecionado}">
                                <input type="hidden" name="veiculoId" value="${veiculoSelecionado.id}" />
                                <div class="locked-vehicle-field">
                                    <div class="locked-vehicle-copy">
                                        <strong>${veiculoSelecionado.placa} - ${veiculoSelecionado.tipo}</strong>
                                        <span>Esta manutenção está vinculada ao veículo de origem e não pode ser trocada nesta tela.</span>
                                    </div>
                                    <span class="locked-vehicle-badge">Vínculo fixo</span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <select name="veiculoId" required ${semVeiculosComManutencao ? 'disabled' : ''}>
                                    <option value="">Selecione um veículo</option>
                                    <c:forEach items="${veiculos}" var="veiculo">
                                        <option value="${veiculo.id}" ${manutencao.veiculoId eq veiculo.id ? 'selected' : ''}>
                                            ${veiculo.placa} - ${veiculo.tipo}
                                        </option>
                                    </c:forEach>
                                </select>
                                <c:choose>
                                    <c:when test="${semVeiculosComManutencao}">
                                        <p class="select-helper">Nenhum veículo com histórico de manutenção foi encontrado. Abra a manutenção a partir da tela de veículos para criar o primeiro registro.</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="select-helper">O seletor mostra apenas veículos que já possuem manutenção registrada.</p>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="form-group">
                        <label>Tipo <span class="required">*</span></label>
                        <select name="tipo" required>
                            <option value="">Selecione</option>
                            <c:forEach items="${tipoManutencaoOptions}" var="tipo">
                                <option value="${tipo}" ${manutencao.tipo eq tipo ? 'selected' : ''}>${tipo}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Status <span class="required">*</span></label>
                        <select name="status" required>
                            <option value="">Selecione</option>
                            <c:forEach items="${statusManutencaoOptions}" var="status">
                                <option value="${status}" ${manutencao.status eq status ? 'selected' : ''}>${status}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group full">
                        <label>Descrição <span class="required">*</span></label>
                        <input type="text" name="descricao" maxlength="180" value="${manutencao.descricao}" placeholder="Ex: troca preventiva de óleo e filtros" required />
                    </div>
                </div>
            </div>

            <div class="form-section">
                <div class="form-section-header">
                    <div class="form-section-icon">
                        <i class="fas fa-calendar-days"></i>
                    </div>
                    <div>
                        <h3>Prazos e custos</h3>
                        <p>Controle agenda, execução e investimento realizado na manutenção.</p>
                    </div>
                </div>

                <div class="form-grid">
                    <div class="form-group">
                        <label>Data prevista <span class="required">*</span></label>
                        <input type="date" name="dataPrevista" value="${manutencao.dataPrevista}" required />
                    </div>

                    <div class="form-group">
                        <label>Data de realização</label>
                        <input type="date" name="dataRealizacao" value="${manutencao.dataRealizacao}" />
                    </div>

                    <div class="form-group">
                        <label>Custo (R$)</label>
                        <input type="number" name="custo" min="0" step="0.01" value="${manutencao.custo}" placeholder="0,00" />
                    </div>

                    <div class="form-group">
                        <label>Oficina / fornecedor</label>
                        <input type="text" name="fornecedorOficina" maxlength="120" value="${manutencao.fornecedorOficina}" placeholder="Nome da oficina ou responsável" />
                    </div>

                    <div class="form-group full">
                        <label>Observação</label>
                        <textarea name="observacao" rows="4" maxlength="600" placeholder="Detalhes técnicos, peças trocadas, recomendações ou observações finais.">${manutencao.observacao}</textarea>
                    </div>
                </div>
            </div>

            <div class="form-actions">
                <a href="${urlVoltarManutencoes}" class="btn-small">
                    <i class="fas fa-arrow-left"></i>
                    Cancelar
                </a>

                <button type="submit" class="btn-primary" ${semVeiculosComManutencao ? 'disabled' : ''}>
                    <i class="fas fa-save"></i>
                    ${not empty manutencao.id ? 'Atualizar Manutenção' : 'Salvar Manutenção'}
                </button>
            </div>
        </form>
    </section>

</main>

</body>
</html>
