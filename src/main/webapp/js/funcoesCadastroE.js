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

var cep = document.getElementById("cep");
var cepMensagem = document.getElementById("cepMensagem");
var logradouro = document.getElementById("logradouro");
var bairro = document.getElementById("bairro");
var municipio = document.getElementById("municipio");
var numero = document.querySelector('input[name="numero"]');
var codigoIbge = document.getElementById("codigoIbge");
var uf = document.getElementById("uf");

function exibirMensagemCep(mensagem, cor) {
  if (!cepMensagem) {
    return;
  }

  cepMensagem.textContent = mensagem || "";
  cepMensagem.style.color = cor || "#667085";
}

function limparEnderecoViaCep() {
  if (logradouro) {
    logradouro.value = "";
  }

  if (bairro) {
    bairro.value = "";
  }

  if (municipio) {
    municipio.value = "";
  }

  if (codigoIbge) {
    codigoIbge.value = "";
  }

  if (uf) {
    uf.value = "";
  }
}

function preencherEnderecoViaCep(dados) {
  if (logradouro) {
    logradouro.value = dados.logradouro || "";
  }

  if (bairro) {
    bairro.value = dados.bairro || "";
  }

  if (municipio) {
    municipio.value = dados.localidade || "";
  }

  if (codigoIbge) {
    codigoIbge.value = manterSomenteDigitosEndereco(dados.ibge || "", 7);
  }

  if (uf) {
    uf.value = (dados.uf || "").toUpperCase().slice(0, 2);
  }
}

function validarCepCompleto() {
  if (!cep) {
    return true;
  }

  var cepNumerico = manterSomenteDigitosEndereco(cep.value, 8);

  if (!cepNumerico) {
    cep.setCustomValidity("");
    exibirMensagemCep("");
    return true;
  }

  if (cepNumerico.length !== 8) {
    cep.setCustomValidity("Informe um CEP com 8 digitos.");
    exibirMensagemCep("Informe um CEP com 8 digitos.", "#b42318");
    return false;
  }

  cep.setCustomValidity("");
  return true;
}

function buscarCep() {
  if (!cep) {
    return;
  }

  var cepNumerico = manterSomenteDigitosEndereco(cep.value, 8);

  if (!cepNumerico) {
    limparEnderecoViaCep();
    cep.setCustomValidity("");
    exibirMensagemCep("");
    return;
  }

  if (cepNumerico.length !== 8) {
    limparEnderecoViaCep();
    cep.setCustomValidity("Informe um CEP com 8 digitos.");
    exibirMensagemCep("Informe um CEP com 8 digitos.", "#b42318");
    return;
  }

  cep.setCustomValidity("");
  exibirMensagemCep("Buscando CEP...", "#667085");

  fetch("https://viacep.com.br/ws/" + cepNumerico + "/json/")
    .then(function (response) {
      if (!response.ok) {
        throw new Error("Falha ao consultar o CEP.");
      }

      return response.json();
    })
    .then(function (dados) {
      if (dados.erro) {
        limparEnderecoViaCep();
        cep.setCustomValidity("CEP nao encontrado.");
        exibirMensagemCep("CEP nao encontrado.", "#b42318");
        cep.reportValidity();
        return;
      }

      preencherEnderecoViaCep(dados);
      cep.setCustomValidity("");
      exibirMensagemCep("Endereco preenchido automaticamente.", "#027a48");

      if (numero && !numero.value) {
        numero.focus();
      }
    })
    .catch(function () {
      cep.setCustomValidity("Nao foi possivel consultar o CEP no momento.");
      exibirMensagemCep("Nao foi possivel consultar o CEP no momento.", "#b42318");
    });
}

if (cep) {
  cep.addEventListener("input", function () {
    validarCepCompleto();

    if (manterSomenteDigitosEndereco(cep.value, 8).length < 8) {
      exibirMensagemCep("");
    }
  });

  cep.addEventListener("blur", buscarCep);
}

if (codigoIbge) {
  codigoIbge.addEventListener("input", function () {
    codigoIbge.value = manterSomenteDigitosEndereco(codigoIbge.value, 7);
  });

  codigoIbge.value = manterSomenteDigitosEndereco(codigoIbge.value, 7);
}

if (uf) {
  uf.addEventListener("input", function () {
    uf.value = uf.value.replace(/[^a-zA-Z]/g, "").toUpperCase().slice(0, 2);
  });

  uf.value = uf.value.replace(/[^a-zA-Z]/g, "").toUpperCase().slice(0, 2);
}

document.querySelector("form").addEventListener("submit", function (event) {
  if (cep && cep.value) {
    if (!validarCepCompleto()) {
      event.preventDefault();
      cep.reportValidity();
      return;
    }

    cep.value = manterSomenteDigitosEndereco(cep.value, 8);
  }

  if (codigoIbge && codigoIbge.value) {
    codigoIbge.value = manterSomenteDigitosEndereco(codigoIbge.value, 7);
  }

  if (uf && uf.value) {
    uf.value = uf.value.replace(/[^a-zA-Z]/g, "").toUpperCase().slice(0, 2);
  }
});
