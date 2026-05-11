function formatarDataBrasil(valor) {
  if (!valor) {
    return null;
  }

  var data = new Date(valor.toString().trim() + "T00:00:00");

  if (isNaN(data.getTime())) {
    return null;
  }

  return new Intl.DateTimeFormat("pt-BR", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric"
  }).format(data);
}

function formatarDataHoraBrasil(valor) {
  if (!valor) {
    return null;
  }

  var dataNormalizada = valor.toString().trim().replace(" ", "T");
  var data = new Date(dataNormalizada);

  if (isNaN(data.getTime())) {
    return null;
  }

  return new Intl.DateTimeFormat("pt-BR", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit"
  }).format(data);
}

document.querySelectorAll(".mask-date").forEach(function (elemento) {
  var valor = elemento.dataset.iso || elemento.textContent;
  var formatado = formatarDataBrasil(valor);

  if (formatado) {
    elemento.textContent = formatado;
  }
});

document.querySelectorAll(".mask-datetime").forEach(function (elemento) {
  var valor = elemento.dataset.iso || elemento.textContent;
  var formatado = formatarDataHoraBrasil(valor);

  if (formatado) {
    elemento.textContent = formatado;
  }
});
