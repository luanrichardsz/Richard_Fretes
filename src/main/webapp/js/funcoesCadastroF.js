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
  campo.addEventListener("input", function () {
    campo.value = campo.value.replace(/\D/g, "").slice(0, limite);
  });

  campo.value = campo.value.replace(/\D/g, "").slice(0, limite);
});

document.querySelector("form").addEventListener("submit", function () {
  limparDigitosFrete("chaveNfe", 44);
  limparDigitosFrete("origemIbge", 7);
  limparDigitosFrete("destinoIbge", 7);
});
