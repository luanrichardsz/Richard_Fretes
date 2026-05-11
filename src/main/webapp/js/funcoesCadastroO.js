function manterDigitosOcorrencia(valor, limite) {
  return valor.replace(/\D/g, "").slice(0, limite);
}

function aplicarMascaraDocumentoOcorrencia(valor) {
  var numeros = valor.replace(/\D/g, "");

  if (numeros.length <= 11) {
    numeros = numeros.slice(0, 11);
    return numeros
      .replace(/^(\d{3})(\d)/, "$1.$2")
      .replace(/^(\d{3})\.(\d{3})(\d)/, "$1.$2.$3")
      .replace(/\.(\d{3})(\d)/, ".$1-$2");
  }

  numeros = numeros.slice(0, 14);
  return numeros
    .replace(/^(\d{2})(\d)/, "$1.$2")
    .replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3")
    .replace(/\.(\d{3})(\d)/, ".$1/$2")
    .replace(/(\d{4})(\d)/, "$1-$2");
}

var ufOcorrencia = document.getElementById("uf");
if (ufOcorrencia) {
  ufOcorrencia.addEventListener("input", function () {
    ufOcorrencia.value = ufOcorrencia.value.replace(/[^a-zA-Z]/g, "").toUpperCase().slice(0, 2);
  });

  ufOcorrencia.value = ufOcorrencia.value.replace(/[^a-zA-Z]/g, "").toUpperCase().slice(0, 2);
}

var recebedorDocumento = document.getElementById("recebedorDocumento");
var recebedorNome = document.getElementById("recebedorNome");
var latitudeOcorrencia = document.getElementById("latitude");
var longitudeOcorrencia = document.getElementById("longitude");
var botaoCapturarLocalizacao = document.getElementById("capturarLocalizacao");
var locationStatus = document.getElementById("locationStatus");
var fotoEvidenciaArquivo = document.getElementById("fotoEvidenciaArquivo");
var fotoPreviewNova = document.getElementById("fotoPreviewNova");
var fotoPreviewAtual = document.getElementById("fotoPreviewAtual");
var uploadFileName = document.getElementById("uploadFileName");
var tipoOcorrencia = document.getElementById("tipo");
var formOcorrencia = document.querySelector("form");
var municipioOcorrencia = document.getElementById("municipio");
var freteIdOcorrencia = document.getElementById("freteId");
var descricaoOcorrencia = document.getElementById("descricao");

function isEntregaRealizadaSelecionada() {
  if (!tipoOcorrencia) {
    return recebedorNome && recebedorNome.hasAttribute("required");
  }

  return tipoOcorrencia.value === "ENTREGA_REALIZADA";
}

function atualizarStatusLocalizacao(mensagem, cor) {
  if (!locationStatus) {
    return;
  }

  locationStatus.textContent = mensagem;
  locationStatus.style.color = cor || "#475467";
}

function definirCamposObrigatoriosEntrega() {
  var exigeComprovante = isEntregaRealizadaSelecionada();
  var existeFotoAtual = fotoPreviewAtual && fotoPreviewAtual.getAttribute("src");

  if (recebedorNome) {
    recebedorNome.required = exigeComprovante;
  }

  if (recebedorDocumento) {
    recebedorDocumento.required = exigeComprovante;
  }

  if (fotoEvidenciaArquivo) {
    fotoEvidenciaArquivo.required = exigeComprovante && !existeFotoAtual;
  }
}

function capturarLocalizacaoAutomaticamente() {
  if (!latitudeOcorrencia || !longitudeOcorrencia) {
    return;
  }

  if (!navigator.geolocation) {
    atualizarStatusLocalizacao("Geolocalização não é suportada neste navegador.", "#b42318");
    return;
  }

  atualizarStatusLocalizacao("Solicitando sua localização atual...", "#475467");

  navigator.geolocation.getCurrentPosition(
    function (position) {
      latitudeOcorrencia.value = position.coords.latitude.toFixed(6);
      longitudeOcorrencia.value = position.coords.longitude.toFixed(6);
      atualizarStatusLocalizacao("Localização capturada automaticamente com sucesso.", "#027a48");
    },
    function (error) {
      var mensagem = "Não foi possível obter a localização agora.";

      if (error && error.code === error.PERMISSION_DENIED) {
        mensagem = "Permissão de localização negada. Você ainda pode informar as coordenadas manualmente.";
      } else if (error && error.code === error.POSITION_UNAVAILABLE) {
        mensagem = "A localização do dispositivo não está disponível no momento.";
      } else if (error && error.code === error.TIMEOUT) {
        mensagem = "A captura de localização expirou. Tente novamente.";
      }

      atualizarStatusLocalizacao(mensagem, "#b42318");
    },
    {
      enableHighAccuracy: true,
      timeout: 10000,
      maximumAge: 60000
    }
  );
}

function configurarPreviewFoto() {
  if (!fotoEvidenciaArquivo || !fotoPreviewNova) {
    return;
  }

  fotoEvidenciaArquivo.addEventListener("change", function () {
    var arquivo = fotoEvidenciaArquivo.files && fotoEvidenciaArquivo.files[0];

    if (!arquivo) {
      if (uploadFileName) {
        uploadFileName.textContent = "Nenhuma imagem selecionada.";
      }
      fotoPreviewNova.style.display = "none";
      fotoPreviewNova.removeAttribute("src");
      return;
    }

    if (uploadFileName) {
      uploadFileName.textContent = arquivo.name;
    }

    fotoPreviewNova.src = URL.createObjectURL(arquivo);
    fotoPreviewNova.style.display = "block";
  });
}

function limparMensagemDeValidacaoAoDigitar(campo) {
  if (!campo) {
    return;
  }

  function limparMensagem() {
    campo.setCustomValidity("");
  }

  campo.addEventListener("input", limparMensagem);
  campo.addEventListener("change", limparMensagem);
}

function validarCampoTexto(campo, mensagem) {
  if (!campo) {
    return true;
  }

  var valor = (campo.value || "").trim();
  if (!valor) {
    campo.setCustomValidity(mensagem);
    return false;
  }

  campo.setCustomValidity("");
  return true;
}

function validarFormularioOcorrencia() {
  var formularioValido = true;

  if (freteIdOcorrencia && freteIdOcorrencia.value) {
    var freteId = parseInt(freteIdOcorrencia.value, 10);
    if (isNaN(freteId) || freteId <= 0) {
      freteIdOcorrencia.setCustomValidity("Informe um ID de frete válido.");
      formularioValido = false;
    }
  }

  if (municipioOcorrencia) {
    var municipio = (municipioOcorrencia.value || "").trim();
    if (municipio.length < 2) {
      municipioOcorrencia.setCustomValidity("Informe um município com pelo menos 2 caracteres.");
      formularioValido = false;
    } else {
      municipioOcorrencia.value = municipio;
    }
  }

  if (ufOcorrencia) {
    var uf = (ufOcorrencia.value || "").trim().toUpperCase();
    if (!/^[A-Z]{2}$/.test(uf)) {
      ufOcorrencia.setCustomValidity("Informe uma UF válida com 2 letras.");
      formularioValido = false;
    } else {
      ufOcorrencia.value = uf;
    }
  }

  var latitudePreenchida = latitudeOcorrencia && latitudeOcorrencia.value !== "";
  var longitudePreenchida = longitudeOcorrencia && longitudeOcorrencia.value !== "";
  if (latitudePreenchida !== longitudePreenchida) {
    if (latitudeOcorrencia) {
      latitudeOcorrencia.setCustomValidity("Informe latitude e longitude juntas.");
    }
    if (longitudeOcorrencia) {
      longitudeOcorrencia.setCustomValidity("Informe latitude e longitude juntas.");
    }
    formularioValido = false;
  }

  if (latitudePreenchida && latitudeOcorrencia) {
    var latitude = parseFloat(latitudeOcorrencia.value);
    if (isNaN(latitude) || latitude < -90 || latitude > 90) {
      latitudeOcorrencia.setCustomValidity("A latitude deve estar entre -90 e 90.");
      formularioValido = false;
    }
  }

  if (longitudePreenchida && longitudeOcorrencia) {
    var longitude = parseFloat(longitudeOcorrencia.value);
    if (isNaN(longitude) || longitude < -180 || longitude > 180) {
      longitudeOcorrencia.setCustomValidity("A longitude deve estar entre -180 e 180.");
      formularioValido = false;
    }
  }

  if (isEntregaRealizadaSelecionada()) {
    if (!validarCampoTexto(recebedorNome, "Informe o nome do recebedor.")) {
      formularioValido = false;
    }

    if (recebedorNome) {
      var nomeRecebedor = (recebedorNome.value || "").trim();
      if (nomeRecebedor && nomeRecebedor.length < 3) {
        recebedorNome.setCustomValidity("O nome do recebedor deve ter pelo menos 3 caracteres.");
        formularioValido = false;
      } else {
        recebedorNome.value = nomeRecebedor;
      }
    }

    if (!validarCampoTexto(recebedorDocumento, "Informe o documento do recebedor.")) {
      formularioValido = false;
    }
  }

  if (recebedorDocumento && recebedorDocumento.value) {
    var documento = manterDigitosOcorrencia(recebedorDocumento.value, 14);
    if (!(documento.length === 11 || documento.length === 14)) {
      recebedorDocumento.setCustomValidity("Informe um CPF ou CNPJ válido para o recebedor.");
      formularioValido = false;
    } else {
      recebedorDocumento.value = documento;
    }
  }

  if (descricaoOcorrencia) {
    descricaoOcorrencia.value = (descricaoOcorrencia.value || "").trim();
  }

  if (fotoEvidenciaArquivo && fotoEvidenciaArquivo.files && fotoEvidenciaArquivo.files[0]) {
    var arquivo = fotoEvidenciaArquivo.files[0];
    if (arquivo.type && arquivo.type.indexOf("image/") !== 0) {
      fotoEvidenciaArquivo.setCustomValidity("Selecione um arquivo de imagem válido.");
      formularioValido = false;
    } else if (arquivo.size > 5 * 1024 * 1024) {
      fotoEvidenciaArquivo.setCustomValidity("A imagem deve ter no máximo 5 MB.");
      formularioValido = false;
    }
  }

  return formularioValido;
}

if (recebedorDocumento) {
  recebedorDocumento.addEventListener("input", function () {
    recebedorDocumento.value = aplicarMascaraDocumentoOcorrencia(recebedorDocumento.value);
  });

  recebedorDocumento.value = aplicarMascaraDocumentoOcorrencia(recebedorDocumento.value);
}

if (tipoOcorrencia) {
  tipoOcorrencia.addEventListener("change", definirCamposObrigatoriosEntrega);
}

if (botaoCapturarLocalizacao) {
  botaoCapturarLocalizacao.addEventListener("click", capturarLocalizacaoAutomaticamente);
}

configurarPreviewFoto();
definirCamposObrigatoriosEntrega();
[
  freteIdOcorrencia,
  municipioOcorrencia,
  ufOcorrencia,
  latitudeOcorrencia,
  longitudeOcorrencia,
  recebedorNome,
  recebedorDocumento,
  descricaoOcorrencia,
  fotoEvidenciaArquivo
].forEach(limparMensagemDeValidacaoAoDigitar);

if (isEntregaRealizadaSelecionada() && latitudeOcorrencia && longitudeOcorrencia) {
  if (!latitudeOcorrencia.value || !longitudeOcorrencia.value) {
    capturarLocalizacaoAutomaticamente();
  } else {
    atualizarStatusLocalizacao("Coordenadas já preenchidas para este comprovante.", "#027a48");
  }
}

formOcorrencia.addEventListener("submit", function (event) {
  if (!validarFormularioOcorrencia()) {
    event.preventDefault();
    formOcorrencia.reportValidity();
  }
});
