function somenteNumeros(valor) {
    return (valor || '').replace(/\D/g, '');
}

function formatarCpf(valor) {
    var numeros = somenteNumeros(valor).slice(0, 11);

    if (numeros.length !== 11) {
        return valor || '-';
    }

    return numeros.replace(/^(\d{3})(\d{3})(\d{3})(\d{2})$/, '$1.$2.$3-$4');
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
    document.querySelectorAll('.mask-cpf').forEach(function (campo) {
        campo.textContent = formatarCpf(campo.textContent);
    });

    document.querySelectorAll('.mask-phone').forEach(function (campo) {
        campo.textContent = formatarTelefone(campo.textContent);
    });
}

function atualizarResumo() {
    var linhas = document.querySelectorAll('.motorista-row');
    var ativos = 0;
    var cnhVencida = 0;

    linhas.forEach(function (linha) {
        if (linha.dataset.status === 'ATIVO') {
            ativos++;
        }

        if (linha.dataset.cnh === 'vencida') {
            cnhVencida++;
        }
    });

    var totalAtivos = document.getElementById('totalAtivos');
    var totalCnhVencida = document.getElementById('totalCnhVencida');

    if (totalAtivos) {
        totalAtivos.textContent = ativos;
    }

    if (totalCnhVencida) {
        totalCnhVencida.textContent = cnhVencida;
    }
}

function configurarFiltros() {
    var busca = document.getElementById('buscaMotorista');
    var filtroStatus = document.getElementById('filtroStatus');
    var filtroCnh = document.getElementById('filtroCnh');
    var linhas = document.querySelectorAll('.motorista-row');
    var emptyFilterState = document.getElementById('emptyFilterState');

    function filtrar() {
        var termoTexto = busca.value.toLowerCase().trim();
        var termoNumerico = somenteNumeros(termoTexto);
        var statusSelecionado = filtroStatus.value;
        var cnhSelecionada = filtroCnh.value;
        var visiveis = 0;

        linhas.forEach(function (linha) {
            var texto = (linha.dataset.search || '').toLowerCase();
            var textoNumerico = somenteNumeros(texto);
            var statusLinha = linha.dataset.status;
            var cnhLinha = linha.dataset.cnh;

            var encontrouTexto =
                termoTexto === '' ||
                texto.indexOf(termoTexto) !== -1 ||
                (termoNumerico !== '' && textoNumerico.indexOf(termoNumerico) !== -1);

            var encontrouStatus =
                statusSelecionado === '' ||
                statusLinha === statusSelecionado;

            var encontrouCnh =
                cnhSelecionada === '' ||
                cnhLinha === cnhSelecionada;

            var mostrar = encontrouTexto && encontrouStatus && encontrouCnh;

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

    if (filtroCnh) {
        filtroCnh.addEventListener('change', filtrar);
    }
}

aplicarMascarasTabela();
atualizarResumo();
configurarFiltros();
