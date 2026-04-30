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
if (recebedorDocumento) {
  recebedorDocumento.addEventListener("input", function () {
    recebedorDocumento.value = aplicarMascaraDocumentoOcorrencia(recebedorDocumento.value);
  });

  recebedorDocumento.value = aplicarMascaraDocumentoOcorrencia(recebedorDocumento.value);
}

document.querySelector("form").addEventListener("submit", function () {
  if (recebedorDocumento && recebedorDocumento.value) {
    recebedorDocumento.value = manterDigitosOcorrencia(recebedorDocumento.value, 14);
  }
});
