function manterDigitosVeiculo(valor, limite) {
  var numeros = valor.replace(/\D/g, "");
  return limite ? numeros.slice(0, limite) : numeros;
}

function aplicarMascaraPlaca(valor) {
  var caracteres = valor.replace(/[^a-zA-Z0-9]/g, "").toUpperCase().slice(0, 7);

  if (caracteres.length <= 3) {
    return caracteres;
  }

  return caracteres.slice(0, 3) + "-" + caracteres.slice(3);
}

function configurarCampoNumerico(id, limite) {
  var campo = document.getElementById(id);

  if (!campo) {
    return;
  }

  campo.addEventListener("input", function () {
    campo.value = manterDigitosVeiculo(campo.value, limite);
  });

  campo.value = manterDigitosVeiculo(campo.value, limite);
}

var campoPlaca = document.getElementById("placa");
if (campoPlaca) {
  campoPlaca.addEventListener("input", function () {
    campoPlaca.value = aplicarMascaraPlaca(campoPlaca.value);
  });

  campoPlaca.value = aplicarMascaraPlaca(campoPlaca.value);
}

configurarCampoNumerico("renavam", 11);
configurarCampoNumerico("rntrc", 20);

document.querySelector("form").addEventListener("submit", function () {
  if (campoPlaca && campoPlaca.value) {
    campoPlaca.value = campoPlaca.value.replace(/[^a-zA-Z0-9]/g, "").toUpperCase().slice(0, 7);
  }
});
