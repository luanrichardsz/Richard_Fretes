
function somenteNumeros(valor) {
    return (valor || '').replace(/\D/g, '');
}

function formatarPlaca(valor) {
    return (valor || '').toUpperCase().trim();
}

function formatarKg(valor) {
    var numero = parseFloat((valor || '').toString().replace(',', '.'));

    if (isNaN(numero)) {
        return valor || '0';
    }

    return numero.toLocaleString('pt-BR', {
        maximumFractionDigits: 0
    });
}

function aplicarMascarasTabela() {
    document.querySelectorAll('.mask-placa').forEach(function (campo) {
        campo.textContent = formatarPlaca(campo.textContent);
    });

    document.querySelectorAll('.mask-kg').forEach(function (campo) {
        campo.textContent = formatarKg(campo.textContent);
    });
}

function atualizarResumo() {
    var linhas = document.querySelectorAll('.veiculo-row');
    var disponiveis = 0;
    var manutencao = 0;

    linhas.forEach(function (linha) {
        if (linha.dataset.status === 'DISPONIVEL') {
            disponiveis++;
        }

        if (linha.dataset.status === 'EM_MANUTENCAO' || linha.dataset.manutencao === 'sim') {
            manutencao++;
        }
    });

    var totalDisponiveis = document.getElementById('totalDisponiveis');
    var totalManutencao = document.getElementById('totalManutencao');

    if (totalDisponiveis) {
        totalDisponiveis.textContent = disponiveis;
    }

    if (totalManutencao) {
        totalManutencao.textContent = manutencao;
    }
}

function configurarFiltros() {
    var busca = document.getElementById('buscaVeiculo');
    var filtroStatus = document.getElementById('filtroStatus');
    var linhas = document.querySelectorAll('.veiculo-row');
    var emptyFilterState = document.getElementById('emptyFilterState');

    function filtrar() {
        var termoTexto = busca.value.toLowerCase().trim();
        var termoNumerico = somenteNumeros(termoTexto);
        var statusSelecionado = filtroStatus.value;
        var visiveis = 0;

        linhas.forEach(function (linha) {
            var texto = (linha.dataset.search || '').toLowerCase();
            var textoNumerico = somenteNumeros(texto);
            var statusLinha = linha.dataset.status;

            var encontrouTexto =
                termoTexto === '' ||
                texto.indexOf(termoTexto) !== -1 ||
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
