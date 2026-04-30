function manterSomenteDigitosEndereco(valor, limite) {
  var numeros = valor.replace(/\D/g, "");
  return limite ? numeros.slice(0, limite) : numeros;
}

function aplicarMascaraCep(valor) {
  var numeros = manterSomenteDigitosEndereco(valor, 8);
  return numeros.replace(/^(\d{5})(\d)/, "$1-$2");
}

function configurarMascaraEndereco(id, formatador) {
  var campo = document.getElementById(id);

  if (!campo) {
    return;
  }

  campo.addEventListener("input", function () {
    campo.value = formatador(campo.value);
  });

  campo.value = formatador(campo.value);
}

configurarMascaraEndereco("cep", aplicarMascaraCep);

var codigoIbge = document.getElementById("codigoIbge");
if (codigoIbge) {
  codigoIbge.addEventListener("input", function () {
    codigoIbge.value = manterSomenteDigitosEndereco(codigoIbge.value, 7);
  });

  codigoIbge.value = manterSomenteDigitosEndereco(codigoIbge.value, 7);
}

var uf = document.getElementById("uf");
if (uf) {
  uf.addEventListener("input", function () {
    uf.value = uf.value.replace(/[^a-zA-Z]/g, "").toUpperCase().slice(0, 2);
  });

  uf.value = uf.value.replace(/[^a-zA-Z]/g, "").toUpperCase().slice(0, 2);
}

document.querySelector("form").addEventListener("submit", function () {
  var cep = document.getElementById("cep");

  if (cep && cep.value) {
    cep.value = manterSomenteDigitosEndereco(cep.value, 8);
  }

  if (codigoIbge && codigoIbge.value) {
    codigoIbge.value = manterSomenteDigitosEndereco(codigoIbge.value, 7);
  }

  if (uf && uf.value) {
    uf.value = uf.value.replace(/[^a-zA-Z]/g, "").toUpperCase().slice(0, 2);
  }
});
