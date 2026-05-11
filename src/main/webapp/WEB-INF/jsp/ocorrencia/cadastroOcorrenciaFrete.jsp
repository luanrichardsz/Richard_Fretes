<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>${not empty ocorrencia.id ? 'Editar Ocorrência' : 'Nova Ocorrência'}</title>

<link rel="icon" type="image/x-icon" href="/RichardFretes/img/richardFretes01-removebg-preview.ico"/>
<link rel="stylesheet" href="/RichardFretes/css/styleC.css" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
.proof-card {
  margin: 0 0 22px 0;
  padding: 22px 24px;
  border-radius: 22px;
  background:
    radial-gradient(circle at top right, rgba(96, 165, 250, 0.16), transparent 28%),
    linear-gradient(135deg, rgba(12, 30, 61, 0.96), rgba(11, 27, 53, 0.92));
  border: 1px solid rgba(59, 130, 246, 0.22);
  box-shadow: 0 18px 42px rgba(7, 15, 34, 0.28);
  display: flex;
  align-items: flex-start;
  gap: 16px;
}
.proof-card-icon {
  width: 52px;
  height: 52px;
  border-radius: 18px;
  background: rgba(59, 130, 246, 0.14);
  border: 1px solid rgba(96, 165, 250, 0.28);
  color: #93c5fd;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  font-size: 1.15rem;
}
.proof-card-copy {
  min-width: 0;
}
.proof-card-eyebrow {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  margin-bottom: 8px;
  color: #93c5fd;
  font-size: 0.72rem;
  font-weight: 900;
  letter-spacing: 0.12em;
  text-transform: uppercase;
}
.proof-card h3 {
  margin: 0 0 8px 0;
  color: var(--text);
  font-size: 1.35rem;
  font-weight: 900;
  letter-spacing: -0.03em;
}
.proof-card p {
  margin: 0;
  max-width: 720px;
  color: var(--text-soft);
  font-size: 0.94rem;
  font-weight: 700;
  line-height: 1.6;
}
.location-status {
  display: block;
  margin-top: 8px;
  color: var(--muted);
  font-size: 0.82rem;
  font-weight: 700;
}
.location-actions {
  display: flex;
  gap: 10px;
  align-items: center;
  flex-wrap: wrap;
}
.proof-preview {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin-top: 12px;
}
.proof-preview img {
  width: min(320px, 100%);
  border-radius: 14px;
  border: 1px solid var(--border);
  box-shadow: 0 12px 30px rgba(15, 23, 42, 0.22);
}
.upload-shell {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 12px;
  padding: 14px 16px;
  border-radius: 16px;
  border: 1px dashed var(--royal-border);
  background: rgba(47, 124, 255, 0.07);
}
.upload-shell input[type="file"] {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
.upload-trigger {
  cursor: pointer;
}
.upload-filename {
  color: var(--text-soft);
  font-size: 0.82rem;
  font-weight: 700;
}
.readonly-field {
  min-height: 52px;
  background:
    linear-gradient(135deg, rgba(148, 163, 184, 0.10), rgba(148, 163, 184, 0.06)) !important;
  border: 1px solid rgba(148, 163, 184, 0.22) !important;
  color: #e2e8f0 !important;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.03) !important;
  font-weight: 800 !important;
  letter-spacing: 0.01em;
  -webkit-text-fill-color: #e2e8f0 !important;
}
.readonly-field::placeholder {
  color: rgba(226, 232, 240, 0.62) !important;
}
.readonly-field:focus {
  border-color: rgba(96, 165, 250, 0.26) !important;
  background: linear-gradient(135deg, rgba(148, 163, 184, 0.12), rgba(148, 163, 184, 0.08)) !important;
  box-shadow: 0 0 0 4px rgba(47, 124, 255, 0.08) !important;
}
.alert-inline {
  margin-bottom: 15px;
  padding: 12px;
  border-radius: 8px;
  background: #fdecea;
  color: #b42318;
  border: 1px solid #f5c2c7;
}
.form-actions {
  margin-top: 24px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}
.form-section {
  padding: 22px;
}
.form-section + .form-section {
  margin-top: 20px;
}
.form-section-header {
  margin-bottom: 20px;
}
.form-section-header p {
  max-width: 620px;
}
@media (max-width: 768px) {
  .proof-card {
    padding: 18px;
    border-radius: 18px;
    flex-direction: column;
  }
  .proof-card-icon {
    width: 46px;
    height: 46px;
    border-radius: 16px;
  }
  .upload-shell {
    align-items: flex-start;
  }
}
</style>

</head>

<body>

<header class="top-header">
    <a href="menu" class="logo-btn" title="Voltar" onclick="if (window.history.length > 1) { window.history.back(); return false; }"><i class="fas fa-arrow-left"></i></a>
    <a href="menu" class="logo-btn" title="Home"><i class="fas fa-home"></i></a>
</header>

<div class="container">

  <c:set var="isComprovanteEntrega" value="${modoComprovanteEntrega}" />

  <div class="page-heading">
    <div>
      <span>${isComprovanteEntrega ? 'Comprovante digital' : 'Histórico operacional'}</span>
      <h1>
        <c:choose>
          <c:when test="${isComprovanteEntrega}">
            ${not empty ocorrencia.id ? 'Editar Comprovante' : 'Novo Comprovante'}
          </c:when>
          <c:otherwise>
            ${not empty ocorrencia.id ? 'Editar Ocorrência' : 'Nova Ocorrência'}
          </c:otherwise>
        </c:choose>
      </h1>
      <p>
        <c:choose>
          <c:when test="${isComprovanteEntrega}">
            Finalize a entrega com recebedor identificado, evidência fotográfica e localização automática quando o navegador permitir.
          </c:when>
          <c:otherwise>
            Registre eventos operacionais com dados consistentes para manter o histórico do frete mais confiável.
          </c:otherwise>
        </c:choose>
      </p>
    </div>
  </div>

  <section class="card">
    <h2>Dados da ocorrência</h2>

    <c:if test="${not empty erro}">
      <div class="alert-inline">
        ${erro}
      </div>
    </c:if>

    <c:if test="${isComprovanteEntrega}">
      <div class="proof-card">
        <div class="proof-card-icon">
          <i class="fas fa-circle-check"></i>
        </div>
        <div class="proof-card-copy">
          <span class="proof-card-eyebrow">
            <i class="fas fa-location-dot"></i>
            Entrega rastreável
          </span>
          <h3>Comprovante digital de entrega</h3>
          <p>Registre recebedor, horário, localização e evidência fotográfica para concluir a entrega com rastreabilidade completa.</p>
        </div>
      </div>
    </c:if>

    <form action="ocorrencias" method="post" enctype="multipart/form-data" novalidate>
      <c:if test="${not empty ocorrencia.id}">
        <input type="hidden" name="id" value="${ocorrencia.id}" />
      </c:if>
      <c:if test="${not empty retornoFreteId}">
        <input type="hidden" name="retornoFreteId" value="${retornoFreteId}" />
      </c:if>
      <input type="hidden" name="fotoEvidenciaUrlAtual" value="${ocorrencia.fotoEvidenciaUrl}" />

      <div class="form-section">
        <div class="form-section-header">
          <div class="form-section-icon">
            <i class="fas fa-clipboard-list"></i>
          </div>
          <div>
            <h3>Vínculo e classificação</h3>
            <p>Defina qual frete receberá o registro e o tipo operacional da ocorrência.</p>
          </div>
        </div>

        <div class="form-grid">

          <div class="form-group">
            <label>Frete ID *</label>
            <c:choose>
              <c:when test="${not empty retornoFreteId}">
                <input type="hidden" name="freteId" value="${ocorrencia.freteId}" />
                <input type="text" value="${ocorrencia.freteId} - ${freteRelacionado.numeroFrete}" readonly class="readonly-field" />
              </c:when>
              <c:otherwise>
                <input type="number" id="freteId" name="freteId" value="${ocorrencia.freteId}" min="1" step="1" required />
              </c:otherwise>
            </c:choose>
          </div>

          <div class="form-group">
            <label>Tipo Ocorrência *</label>
            <c:choose>
              <c:when test="${isComprovanteEntrega}">
                <input type="hidden" name="tipo" value="${ocorrencia.tipo}" />
                <input type="text" value="ENTREGA_REALIZADA" readonly class="readonly-field" />
              </c:when>
              <c:otherwise>
                <select name="tipo" id="tipo" required>
                  <option value="">Selecione</option>
                  <c:forEach var="tipo" items="${tipoOcorrenciaOptions}">
                    <option value="${tipo}" ${ocorrencia.tipo eq tipo ? 'selected' : ''}>${tipo}</option>
                  </c:forEach>
                </select>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>

      <div class="form-section">
        <div class="form-section-header">
          <div class="form-section-icon">
            <i class="fas fa-map-location-dot"></i>
          </div>
          <div>
            <h3>Local da ocorrência</h3>
            <p>Informe município, UF e coordenadas com validação de formato e faixa de valores.</p>
          </div>
        </div>

        <div class="form-grid">

        <div class="form-group">
          <label>Município *</label>
          <input type="text" id="municipio" name="municipio" value="${ocorrencia.municipio}" maxlength="120" minlength="2" required />
        </div>

        <div class="form-group">
          <label>UF *</label>
          <input type="text" id="uf" name="uf" value="${ocorrencia.uf}" maxlength="2" minlength="2" pattern="[A-Za-z]{2}" required />
        </div>

        <div class="form-group">
          <label>Latitude</label>
          <input type="number" step="0.000001" id="latitude" name="latitude" value="${ocorrencia.latitude}" min="-90" max="90" />
        </div>

        <div class="form-group">
          <label>Longitude</label>
          <input type="number" step="0.000001" id="longitude" name="longitude" value="${ocorrencia.longitude}" min="-180" max="180" />
        </div>

        <div class="form-group full">
          <label>Localização automática</label>
          <div class="location-actions">
            <button type="button" id="capturarLocalizacao" class="btn-small">
              <i class="fas fa-location-crosshairs"></i>
              Usar minha localização
            </button>
            <span id="locationStatus" class="location-status">Aguardando captura da localização do navegador.</span>
          </div>
        </div>
        </div>
      </div>

      <div class="form-section">
        <div class="form-section-header">
          <div class="form-section-icon">
            <i class="fas fa-id-card"></i>
          </div>
          <div>
            <h3>Recebedor e detalhamento</h3>
            <p>Garanta dados completos e consistentes para facilitar auditoria e comprovação posterior.</p>
          </div>
        </div>

        <div class="form-grid">

        <div class="form-group full">
          <label>Descrição</label>
          <textarea id="descricao" name="descricao" rows="4" maxlength="500" placeholder="${isComprovanteEntrega ? 'Ex: entrega recebida sem avarias, nota conferida e assinada.' : ''}">${ocorrencia.descricao}</textarea>
        </div>

        <div class="form-group">
          <label>Recebedor Nome ${isComprovanteEntrega ? '*' : ''}</label>
          <input type="text" id="recebedorNome" name="recebedorNome" value="${ocorrencia.recebedorNome}" minlength="3" maxlength="120" ${isComprovanteEntrega ? 'required' : ''} />
        </div>

        <div class="form-group">
          <label>Recebedor Documento ${isComprovanteEntrega ? '*' : ''}</label>
          <input type="text" id="recebedorDocumento" name="recebedorDocumento" maxlength="18" inputmode="numeric" value="${ocorrencia.recebedorDocumento}" ${isComprovanteEntrega ? 'required' : ''} />
        </div>

        <div class="form-group full">
          <label>Foto da Evidência ${isComprovanteEntrega ? '*' : ''}</label>
          <div class="upload-shell">
            <input
              type="file"
              id="fotoEvidenciaArquivo"
              name="fotoEvidenciaArquivo"
              accept="image/*"
              capture="environment"
              ${isComprovanteEntrega and empty ocorrencia.fotoEvidenciaUrl ? 'required' : ''}
            />
            <label for="fotoEvidenciaArquivo" class="btn-small upload-trigger">
              <i class="fas fa-camera"></i>
              Escolher imagem
            </label>
            <span id="uploadFileName" class="upload-filename">Nenhuma imagem selecionada.</span>
          </div>
          <small class="location-status">Envie uma foto da entrega, do recebedor ou do canhoto assinado.</small>

          <c:if test="${not empty ocorrencia.fotoEvidenciaUrl}">
            <div class="proof-preview">
              <a href="${ocorrencia.fotoEvidenciaUrl}" target="_blank" rel="noopener noreferrer">Abrir evidência atual</a>
              <img src="${ocorrencia.fotoEvidenciaUrl}" alt="Evidência da entrega" id="fotoPreviewAtual" />
            </div>
          </c:if>

          <div class="proof-preview">
            <img src="" alt="Pré-visualização da nova evidência" id="fotoPreviewNova" style="display: none;" />
          </div>
        </div>
      </div>
      </div>

      <div class="form-actions">
        <button type="submit" class="btn-primary">Salvar</button>
        <c:choose>
          <c:when test="${not empty retornoFreteId}">
            <a href="fretes?acao=detalhes&id=${retornoFreteId}" class="btn-secondary">Cancelar</a>
          </c:when>
          <c:otherwise>
            <a href="ocorrencias" class="btn-secondary">Cancelar</a>
          </c:otherwise>
        </c:choose>
      </div>

    </form>

  </section>

</div>

<script src="/RichardFretes/js/funcoesCadastroO.js"></script>

</body>
</html>
