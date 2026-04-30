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

function lerValorDecimal(id) {
  var campo = document.getElementById(id);

  if (!campo || !campo.value) {
    return 0;
  }

  return parseFloat(campo.value.replace(",", ".")) || 0;
}

function atualizarValorTotal() {
  var campoValorTotal = document.getElementById("valorTotal");

  if (!campoValorTotal) {
    return;
  }

  var total = lerValorDecimal("valorFreteBruto")
    + lerValorDecimal("valorPedagio")
    + lerValorDecimal("valorIcms");

  campoValorTotal.value = total > 0 ? total.toFixed(2) : "";
}

["valorFreteBruto", "valorPedagio", "valorIcms"].forEach(function (id) {
  var campo = document.getElementById(id);

  if (!campo) {
    return;
  }

  campo.addEventListener("input", atualizarValorTotal);
});

atualizarValorTotal();

document.querySelector("form").addEventListener("submit", function () {
  atualizarValorTotal();
  limparDigitosFrete("chaveNfe", 44);
  limparDigitosFrete("origemIbge", 7);
  limparDigitosFrete("destinoIbge", 7);
});
