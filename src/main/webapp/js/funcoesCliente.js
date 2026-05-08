function somenteNumeros(valor) {
    return (valor || '').replace(/\D/g, '');
}

function formatarCnpj(valor) {
    var numeros = somenteNumeros(valor).slice(0, 14);

    if (numeros.length !== 14) {
        return valor || '-';
    }

    return numeros.replace(/^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})$/, '$1.$2.$3/$4-$5');
}

function formatarTelefone(valor) {
    var numeros = somenteNumeros(valor).slice(0, 11);

    if (numeros.length === 10) {
        return numeros.replace(/^(\d{2})(\d{4})(\d{4})$/, '($1) $2-$3');
    }

    if (numeros.length === 11) {
        return numeros.replace(/^(\d{2})(\d{5})(\d{4})$/, '($1) $2-$3');
    }

    return valor || '-';
}

function aplicarMascarasTabela() {
    document.querySelectorAll('.mask-cnpj').forEach(function (campo) {
        campo.textContent = formatarCnpj(campo.textContent);
    });

    document.querySelectorAll('.mask-phone').forEach(function (campo) {
        campo.textContent = formatarTelefone(campo.textContent);
    });
}

function atualizarResumo() {
    var linhas = document.querySelectorAll('.cliente-row');
    var ativos = 0;
    var inativos = 0;

    linhas.forEach(function (linha) {
        if (linha.dataset.status === 'ativo') {
            ativos++;
        } else {
            inativos++;
        }
    });

    var totalAtivos = document.getElementById('totalAtivos');
    var totalInativos = document.getElementById('totalInativos');

    if (totalAtivos) {
        totalAtivos.textContent = ativos;
    }

    if (totalInativos) {
        totalInativos.textContent = inativos;
    }
}

function configurarFiltros() {
    var busca = document.getElementById('buscaCliente');
    var filtroStatus = document.getElementById('filtroStatus');
    var linhas = document.querySelectorAll('.cliente-row');
    var emptyFilterState = document.getElementById('emptyFilterState');

    function filtrar() {
        var termo = somenteNumeros(busca.value.toLowerCase()) || busca.value.toLowerCase().trim();
        var termoTexto = busca.value.toLowerCase().trim();
        var status = filtroStatus.value;
        var visiveis = 0;

        linhas.forEach(function (linha) {
            var texto = (linha.dataset.search || '').toLowerCase();
            var textoNumerico = somenteNumeros(texto);
            var statusLinha = linha.dataset.status;

            var encontrouTexto =
                termoTexto === '' ||
                texto.indexOf(termoTexto) !== -1 ||
                textoNumerico.indexOf(somenteNumeros(termoTexto)) !== -1;

            var encontrouStatus =
                status === '' ||
                statusLinha === status;

            var mostrar = encontrouTexto && encontrouStatus;

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

    if (filtroStatus) {
        filtroStatus.addEventListener('change', filtrar);
    }
}

aplicarMascarasTabela();
atualizarResumo();
configurarFiltros();