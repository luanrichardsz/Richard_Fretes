function manterSomenteDigitos(valor, limite) {
  var numeros = valor.replace(/\D/g, "");
  return limite ? numeros.slice(0, limite) : numeros;
}

function aplicarMascaraCpf(valor) {
  var numeros = manterSomenteDigitos(valor, 11);

  return numeros
    .replace(/^(\d{3})(\d)/, "$1.$2")
    .replace(/^(\d{3})\.(\d{3})(\d)/, "$1.$2.$3")
    .replace(/\.(\d{3})(\d)/, ".$1-$2");
}

function aplicarMascaraRg(valor) {
  var numeros = manterSomenteDigitos(valor, 9);

  return numeros
    .replace(/^(\d{2})(\d)/, "$1.$2")
    .replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3")
    .replace(/\.(\d{3})(\d)/, ".$1-$2");
}

function aplicarMascaraTelefone(valor) {
  var numeros = manterSomenteDigitos(valor, 11);

  if (numeros.length <= 10) {
    return numeros
      .replace(/^(\d{2})(\d)/, "($1) $2")
      .replace(/(\d{4})(\d)/, "$1-$2");
  }

  return numeros
    .replace(/^(\d{2})(\d)/, "($1) $2")
    .replace(/(\d{5})(\d)/, "$1-$2");
}

function aplicarMascaraCnpj(valor) {
  var numeros = manterSomenteDigitos(valor, 14);

  return numeros
    .replace(/^(\d{2})(\d)/, "$1.$2")
    .replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3")
    .replace(/\.(\d{3})(\d)/, ".$1/$2")
    .replace(/(\d{4})(\d)/, "$1-$2");
}

function configurarMascaraPorId(id, formatador) {
  var campo = document.getElementById(id);

  if (!campo) {
    return;
  }

  campo.addEventListener("input", function () {
    campo.value = formatador(campo.value);
  });

  campo.value = formatador(campo.value);
}

function limparCampoNumerico(id, limite) {
  var campo = document.getElementById(id);

  if (campo && campo.value) {
    campo.value = manterSomenteDigitos(campo.value, limite);
  }
}

function configurarChavePix() {
  var tipoPix = document.getElementById("tipoPix");
  var chavePix = document.getElementById("chavePix");

  if (!tipoPix || !chavePix) {
    return;
  }

  function aplicar() {
    var tipo = tipoPix.value;
    chavePix.removeAttribute("inputmode");
    chavePix.removeAttribute("maxlength");

    if (tipo === "CPF") {
      chavePix.inputMode = "numeric";
      chavePix.maxLength = 14;
      chavePix.value = aplicarMascaraCpf(chavePix.value);
      return;
    }

    if (tipo === "CNPJ") {
      chavePix.inputMode = "numeric";
      chavePix.maxLength = 18;
      chavePix.value = aplicarMascaraCnpj(chavePix.value);
      return;
    }

    if (tipo === "CELULAR") {
      chavePix.inputMode = "numeric";
      chavePix.maxLength = 15;
      chavePix.value = aplicarMascaraTelefone(chavePix.value);
      return;
    }
  }

  chavePix.addEventListener("input", function () {
    var tipo = tipoPix.value;

    if (tipo === "CPF") {
      chavePix.value = aplicarMascaraCpf(chavePix.value);
    } else if (tipo === "CNPJ") {
      chavePix.value = aplicarMascaraCnpj(chavePix.value);
    } else if (tipo === "CELULAR") {
      chavePix.value = aplicarMascaraTelefone(chavePix.value);
    }
  });

  tipoPix.addEventListener("change", aplicar);
  aplicar();
}

document.querySelector("form").addEventListener("submit", function (e) {
  var campoDataNascimento = document.getElementById("dataNascimento");
  var dataNascimento = campoDataNascimento.value;
  var hojeIso = new Date().toISOString().split("T")[0];

  if (campoDataNascimento) {
    campoDataNascimento.max = hojeIso;
  }

  if (dataNascimento) {
    if (dataNascimento > hojeIso) {
      alert("A data de nascimento não pode ser maior que a data atual.");
      e.preventDefault();
      return;
    }

    var dataInput = new Date(dataNascimento);
    var hoje = new Date();
    var idade = hoje.getFullYear() - dataInput.getFullYear();
    var m = hoje.getMonth() - dataInput.getMonth();

    if (m < 0 || (m === 0 && hoje.getDate() < dataInput.getDate())) {
      idade--;
    }

    if (idade < 18) {
      alert("O motorista deve ter pelo menos 18 anos!");
      e.preventDefault();
      return;
    }

    if (idade > 100) {
      alert("Por favor, insira uma data de nascimento válida.");
      e.preventDefault();
      return;
    }
  }

  limparCampoNumerico("cpf", 11);
  limparCampoNumerico("rg", 9);
  limparCampoNumerico("telefone", 11);
  limparCampoNumerico("telefoneEmergencia", 11);
  limparCampoNumerico("numeroCnh", 11);

  var tipoPix = document.getElementById("tipoPix");
  if (tipoPix) {
    if (tipoPix.value === "CPF") {
      limparCampoNumerico("chavePix", 11);
    } else if (tipoPix.value === "CNPJ") {
      limparCampoNumerico("chavePix", 14);
    } else if (tipoPix.value === "CELULAR") {
      limparCampoNumerico("chavePix", 11);
    }
  }
});

configurarMascaraPorId("cpf", aplicarMascaraCpf);
configurarMascaraPorId("rg", aplicarMascaraRg);
configurarMascaraPorId("telefone", aplicarMascaraTelefone);
configurarMascaraPorId("telefoneEmergencia", aplicarMascaraTelefone);
configurarChavePix();
