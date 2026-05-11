function somenteNumeros(valor) {
    return (valor || '').replace(/\D/g, '');
}

function traduzirStatus(status) {
    var mapa = {
        EMITIDO: 'Emitido',
        SAIDA_CONFIRMADA: 'Saida confirmada',
        EM_TRANSITO: 'Em transito',
        ENTREGUE: 'Entregue',
        NAO_ENTREGUE: 'Nao entregue',
        CANCELADO: 'Cancelado'
    };

    return mapa[status] || status || '-';
}

function formatarDataHoraBrasil(valor) {
    if (!valor) {
        return null;
    }

    var dataNormalizada = valor.toString().trim().replace(' ', 'T');
    var data = new Date(dataNormalizada);

    if (isNaN(data.getTime())) {
        return null;
    }

    return {
        data: new Intl.DateTimeFormat('pt-BR', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric'
        }).format(data),
        hora: new Intl.DateTimeFormat('pt-BR', {
            hour: '2-digit',
            minute: '2-digit'
        }).format(data),
        completo: new Intl.DateTimeFormat('pt-BR', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        }).format(data)
    };
}

function aplicarMascarasTabela() {
    document.querySelectorAll('.mask-datetime').forEach(function (container) {
        var dataFormatada = formatarDataHoraBrasil(container.dataset.iso || container.textContent);
        var dataPrincipal = container.querySelector('.date-primary');
        var dataSecundaria = container.querySelector('.date-secondary');

        if (!dataFormatada) {
            if (dataSecundaria) {
                dataSecundaria.textContent = 'Data nao disponivel';
            }
            return;
        }

        if (dataPrincipal) {
            dataPrincipal.textContent = dataFormatada.data;
        }

        if (dataSecundaria) {
            dataSecundaria.textContent = dataFormatada.hora + ' (horario local)';
        }

        container.setAttribute('title', dataFormatada.completo);
    });
}

function atualizarResumo() {
    var linhas = document.querySelectorAll('.frete-row');
    var emOperacao = 0;
    var entregues = 0;

    linhas.forEach(function (linha) {
        var status = linha.dataset.status;

        if (status === 'EMITIDO' || status === 'SAIDA_CONFIRMADA' || status === 'EM_TRANSITO') {
            emOperacao++;
        }

        if (status === 'ENTREGUE') {
            entregues++;
        }
    });

    var totalEmOperacao = document.getElementById('totalEmOperacao');
    var totalEntregues = document.getElementById('totalEntregues');

    if (totalEmOperacao) {
        totalEmOperacao.textContent = emOperacao;
    }

    if (totalEntregues) {
        totalEntregues.textContent = entregues;
    }
}

function configurarFiltros() {
    var busca = document.getElementById('buscaFrete');
    var filtroStatus = document.getElementById('filtroStatus');
    var linhas = document.querySelectorAll('.frete-row');
    var emptyFilterState = document.getElementById('emptyFilterState');

    function filtrar() {
        var termoTexto = busca.value.toLowerCase().trim();
        var termoNumerico = somenteNumeros(termoTexto);
        var statusSelecionado = filtroStatus.value;
        var visiveis = 0;

        linhas.forEach(function (linha) {
            var texto = (linha.dataset.search || '').toLowerCase();
            var textoNumerico = somenteNumeros(texto);
            var statusLinha = linha.dataset.status || '';
            var statusFormatado = traduzirStatus(statusLinha).toLowerCase();

            var encontrouTexto =
                termoTexto === '' ||
                texto.indexOf(termoTexto) !== -1 ||
                statusFormatado.indexOf(termoTexto) !== -1 ||
                (termoNumerico !== '' && textoNumerico.indexOf(termoNumerico) !== -1);

            var encontrouStatus =
                statusSelecionado === '' ||
                statusLinha === statusSelecionado;

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
