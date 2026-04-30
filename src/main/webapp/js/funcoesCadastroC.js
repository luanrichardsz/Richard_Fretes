function aplicarMascaraCnpj(valor) {
  var numeros = valor.replace(/\D/g, "").slice(0, 14);

  return numeros
    .replace(/^(\d{2})(\d)/, "$1.$2")
    .replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3")
    .replace(/\.(\d{3})(\d)/, ".$1/$2")
    .replace(/(\d{4})(\d)/, "$1-$2");
}

function aplicarMascaraTelefone(valor) {
  var numeros = valor.replace(/\D/g, "").slice(0, 11);

  if (numeros.length <= 10) {
    return numeros
      .replace(/^(\d{2})(\d)/, "($1) $2")
      .replace(/(\d{4})(\d)/, "$1-$2");
  }

  return numeros
    .replace(/^(\d{2})(\d)/, "($1) $2")
    .replace(/(\d{5})(\d)/, "$1-$2");
}

function configurarMascara(nomeCampo, formatador) {
  var campo = document.querySelector('input[name="' + nomeCampo + '"]');

  if (!campo) {
    return;
  }

  campo.addEventListener("input", function () {
    campo.value = formatador(campo.value);
  });

  campo.value = formatador(campo.value);
}

document.querySelector("form").addEventListener("submit", function (event) {
  const campoDocumento = document.getElementById("documento");
  const campoTelefone = document.getElementById("telefone");

  if (campoDocumento.value.length < 18) {
    alert("Preencha o CNPJ corretamente.");
    campoDocumento.focus();
    event.preventDefault();
    return;
  }

  if (campoTelefone.value.length < 14) {
    alert("Preencha o telefone corretamente.");
    campoTelefone.focus();
    event.preventDefault();
    return;
  }


  limparMascara("documento");
  limparMascara("telefone");
});

function limparMascara(id){
  var campo = document.getElementById(id);

  if(campo && campo.value){
    campo.value = campo.value.replace(/\D/g, "");
  }
}

configurarMascara("documento", aplicarMascaraCnpj);
configurarMascara("telefone", aplicarMascaraTelefone);
