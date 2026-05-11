function limparDigitosFrete(id, limite) {
  var campo = document.getElementById(id);

  if (campo && campo.value) {
    campo.value = campo.value.replace(/\D/g, "").slice(0, limite);
  }
}

["chaveNfe", "origemIbge", "destinoIbge"].forEach(function (id) {
  var campo = document.getElementById(id);

  if (!campo) {
    return;
  }

  var limite = id === "chaveNfe" ? 44 : 7;

  if (id === "chaveNfe") {
    campo.addEventListener("input", function () {
      campo.value = campo.value.replace(/\D/g, "").slice(0, limite);
    });
  }

  campo.value = campo.value.replace(/\D/g, "").slice(0, limite);
});

function atualizarIbgePorEndereco(selectId, inputId) {
  var select = document.getElementById(selectId);
  var input = document.getElementById(inputId);

  if (!select || !input) {
    return;
  }

  function sincronizar() {
    var optionSelecionada = select.options[select.selectedIndex];
    var codigoIbge = optionSelecionada ? optionSelecionada.getAttribute("data-codigo-ibge") : "";
    input.value = (codigoIbge || "").replace(/\D/g, "").slice(0, 7);
  }

  select.addEventListener("change", sincronizar);
  sincronizar();
}

atualizarIbgePorEndereco("enderecoOrigemId", "origemIbge");
atualizarIbgePorEndereco("enderecoDestinoId", "destinoIbge");

function filtrarEnderecosDestinoPorDestinatario() {
  var selectDestinatario = document.getElementById("destinatarioId");
  var selectEnderecoDestino = document.getElementById("enderecoDestinoId");

  if (!selectDestinatario || !selectEnderecoDestino) {
    return;
  }

  var clienteSelecionado = (selectDestinatario.value || "").trim();
  var valorAtual = selectEnderecoDestino.value;
  var temOpcaoSelecionadaVisivel = false;

  Array.prototype.forEach.call(selectEnderecoDestino.options, function (option, index) {
    if (index === 0) {
      option.hidden = false;
      return;
    }

    var clienteId = (option.getAttribute("data-cliente-id") || "").trim();
    var deveExibir = !!clienteSelecionado && clienteId === clienteSelecionado;

    option.hidden = !deveExibir;

    if (deveExibir && option.value === valorAtual) {
      temOpcaoSelecionadaVisivel = true;
    }
  });

  if (!temOpcaoSelecionadaVisivel) {
    selectEnderecoDestino.value = "";
  }

  selectEnderecoDestino.dispatchEvent(new Event("change"));
}

function lerValorDecimal(id) {
  var campo = document.getElementById(id);

  if (!campo || !campo.value) {
    return 0;
  }

  return parseFloat(campo.value.replace(",", ".")) || 0;
}

function validarPrevisaoEntrega() {
  var campo = document.getElementById("previsaoEntrega");

  if (!campo) {
    return true;
  }

  var valor = (campo.value || "").trim();

  if (!valor) {
    campo.setCustomValidity("");
    return true;
  }

  var formatoValido = /^\d{4}-\d{2}-\d{2}$/.test(valor);
  if (!formatoValido) {
    campo.setCustomValidity("Informe uma data válida no formato AAAA-MM-DD.");
    return false;
  }

  var partes = valor.split("-");
  var ano = parseInt(partes[0], 10);
  var mes = parseInt(partes[1], 10);
  var dia = parseInt(partes[2], 10);
  var data = new Date(Date.UTC(ano, mes - 1, dia));
  var dataValida = data.getUTCFullYear() === ano
    && data.getUTCMonth() === mes - 1
    && data.getUTCDate() === dia;

  if (!dataValida) {
    campo.setCustomValidity("Informe uma data de previsão de entrega válida.");
    return false;
  }

  campo.setCustomValidity("");
  return true;
}

function obterDadosEndereco(selectId) {
  var select = document.getElementById(selectId);

  if (!select || !select.selectedIndex || select.selectedIndex < 0) {
    return null;
  }

  var optionSelecionada = select.options[select.selectedIndex];
  if (!optionSelecionada || !optionSelecionada.value) {
    return null;
  }

  return {
    uf: (optionSelecionada.getAttribute("data-uf") || "").trim().toUpperCase(),
    municipio: (optionSelecionada.getAttribute("data-municipio") || "").trim().toUpperCase()
  };
}

function calcularAliquotaIcmsPadrao() {
  var origem = obterDadosEndereco("enderecoOrigemId");
  var destino = obterDadosEndereco("enderecoDestinoId");

  if (!origem || !destino || !origem.uf || !destino.uf) {
    return 0;
  }

  if (origem.uf === destino.uf && origem.municipio === destino.municipio) {
    return 0;
  }

  var sulSudeste = ["SP", "RJ", "MG", "PR", "SC", "RS"];
  var norteNordesteCentroOesteOuEs = ["AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "PA", "PB", "PE", "PI", "RN", "RO", "RR", "SE", "TO"];

  if (origem.uf !== destino.uf
    && sulSudeste.indexOf(origem.uf) !== -1
    && norteNordesteCentroOesteOuEs.indexOf(destino.uf) !== -1) {
    return 7;
  }

  return 12;
}

function atualizarIcms() {
  var campoAliquota = document.getElementById("aliquotaIcms");
  var campoValorIcms = document.getElementById("valorIcms");

  if (!campoAliquota || !campoValorIcms) {
    return;
  }

  var aliquota = calcularAliquotaIcmsPadrao();
  var valorFreteBruto = lerValorDecimal("valorFreteBruto");
  var valorIcms = valorFreteBruto * (aliquota / 100);

  campoAliquota.value = aliquota > 0 ? aliquota.toFixed(2) : "0.00";
  campoValorIcms.value = valorIcms > 0 ? valorIcms.toFixed(2) : "0.00";
}

function atualizarValorTotal() {
  var campoValorTotal = document.getElementById("valorTotal");

  if (!campoValorTotal) {
    return;
  }

  var total = lerValorDecimal("valorFreteBruto")
    + lerValorDecimal("valorPedagio")
    + lerValorDecimal("valorIcms");

  campoValorTotal.value = total > 0 ? total.toFixed(2) : "0.00";
}

function atualizarValoresFrete() {
  atualizarIcms();
  atualizarValorTotal();
}

["valorFreteBruto", "valorPedagio"].forEach(function (id) {
  var campo = document.getElementById(id);

  if (!campo) {
    return;
  }

  campo.addEventListener("input", atualizarValoresFrete);
});

["enderecoOrigemId", "enderecoDestinoId"].forEach(function (id) {
  var campo = document.getElementById(id);

  if (!campo) {
    return;
  }

  campo.addEventListener("change", atualizarValoresFrete);
});

var campoDestinatario = document.getElementById("destinatarioId");
if (campoDestinatario) {
  campoDestinatario.addEventListener("change", filtrarEnderecosDestinoPorDestinatario);
}

var campoPrevisaoEntrega = document.getElementById("previsaoEntrega");
if (campoPrevisaoEntrega) {
  campoPrevisaoEntrega.addEventListener("input", validarPrevisaoEntrega);
  campoPrevisaoEntrega.addEventListener("change", validarPrevisaoEntrega);
}

filtrarEnderecosDestinoPorDestinatario();
validarPrevisaoEntrega();
atualizarValoresFrete();

var formularioFrete = document.querySelector("form");

if (formularioFrete) {
  formularioFrete.addEventListener("submit", function (event) {
    if (!validarPrevisaoEntrega()) {
      event.preventDefault();
      document.getElementById("previsaoEntrega").reportValidity();
      return;
    }

    atualizarValoresFrete();
    limparDigitosFrete("chaveNfe", 44);
    limparDigitosFrete("origemIbge", 7);
    limparDigitosFrete("destinoIbge", 7);
  });
}
