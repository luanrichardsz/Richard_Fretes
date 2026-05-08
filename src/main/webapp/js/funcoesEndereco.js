function somenteNumeros(valor) {
    return (valor || '').replace(/\D/g, '');
}

function formatarCep(valor) {
    var numeros = somenteNumeros(valor).slice(0, 8);

    if (numeros.length !== 8) {
        return valor || '-';
    }

    return numeros.replace(/^(\d{5})(\d{3})$/, '$1-$2');
}

function aplicarMascarasTabela() {
    document.querySelectorAll('.mask-cep').forEach(function (campo) {
        campo.textContent = formatarCep(campo.textContent);
    });
}

function atualizarResumo() {
    var linhas = document.querySelectorAll('.endereco-row');
    var municipios = {};
    var referencias = 0;

    linhas.forEach(function (linha) {
        var municipio = (linha.dataset.municipio || '').trim().toLowerCase();
        var uf = (linha.dataset.uf || '').trim().toUpperCase();

        if (municipio !== '') {
            municipios[municipio + '-' + uf] = true;
        }

        if (linha.dataset.referencia === 'sim') {
            referencias++;
        }
    });

    var totalMunicipios = document.getElementById('totalMunicipios');
    var totalReferencias = document.getElementById('totalReferencias');

    if (totalMunicipios) {
        totalMunicipios.textContent = Object.keys(municipios).length;
    }

    if (totalReferencias) {
        totalReferencias.textContent = referencias;
    }
}

function preencherFiltroUf() {
    var filtroUf = document.getElementById('filtroUf');
    var linhas = document.querySelectorAll('.endereco-row');
    var ufs = {};

    if (!filtroUf) {
        return;
    }

    linhas.forEach(function (linha) {
        var uf = (linha.dataset.uf || '').trim().toUpperCase();

        if (uf !== '') {
            ufs[uf] = true;
        }
    });

    Object.keys(ufs).sort().forEach(function (uf) {
        var option = document.createElement('option');
        option.value = uf.toLowerCase();
        option.textContent = uf;
        filtroUf.appendChild(option);
    });
}

function configurarFiltros() {
    var busca = document.getElementById('buscaEndereco');
    var filtroUf = document.getElementById('filtroUf');
    var linhas = document.querySelectorAll('.endereco-row');
    var emptyFilterState = document.getElementById('emptyFilterState');

    function filtrar() {
        var termoTexto = busca.value.toLowerCase().trim();
        var termoNumerico = somenteNumeros(termoTexto);
        var ufSelecionada = filtroUf.value;
        var visiveis = 0;

        linhas.forEach(function (linha) {
            var texto = (linha.dataset.search || '').toLowerCase();
            var textoNumerico = somenteNumeros(texto);
            var ufLinha = (linha.dataset.uf || '').toLowerCase();

            var encontrouTexto =
                termoTexto === '' ||
                texto.indexOf(termoTexto) !== -1 ||
                (termoNumerico !== '' && textoNumerico.indexOf(termoNumerico) !== -1);

            var encontrouUf =
                ufSelecionada === '' ||
                ufLinha === ufSelecionada;

            var mostrar = encontrouTexto && encontrouUf;

            linha.style.display = mostrar ? '' : 'none';

            if (mostrar) {
                visiveis++;
            }
        });

        if (emptyFilterState) {
            emptyFilterState.classList.toggle('hidden', visiveis > 0);
        }
    }

    if (busca) {
        busca.addEventListener('input', filtrar);
    }

    if (filtroUf) {
        filtroUf.addEventListener('change', filtrar);
    }
}

aplicarMascarasTabela();
atualizarResumo();
preencherFiltroUf();
configurarFiltros();