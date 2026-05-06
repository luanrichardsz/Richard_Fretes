const signUpButton = document.getElementById('signUp');
    const signInButton = document.getElementById('signIn');
    const mobileSignUpButton = document.getElementById('mobileSignUp');
    const mobileSignInButton = document.getElementById('mobileSignIn');
    const container = document.getElementById('container');
    const registerForm = document.getElementById('registerForm');
    const loginForm = document.getElementById('loginForm');
    const registerSuccess = document.getElementById('registerSuccess');
    const registerError = document.getElementById('registerError');
    const loginSuccess = document.getElementById('loginSuccess');
    const loginError = document.getElementById('loginError');

    function limparAlertas() {
        [registerSuccess, registerError, loginSuccess, loginError].forEach((alerta) => {
            if (alerta) {
                alerta.textContent = '';
                alerta.style.display = 'none';
            }
        });
    }

    function mostrarAlerta(elemento, mensagem) {
        if (!elemento) {
            return;
        }
        elemento.textContent = mensagem;
        elemento.style.display = 'block';
    }

    async function enviarParaApi(url, payload) {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            credentials: 'same-origin',
            body: JSON.stringify(payload)
        });

        const rawText = await response.text();
        let data;

        try {
            data = rawText ? JSON.parse(rawText) : {};
        } catch (error) {
            data = {
                mensagem: rawText || `Resposta invalida da API (HTTP ${response.status}).`
            };
        }

        return {
            ok: response.ok,
            status: response.status,
            data: data
        };
    }

    if (signUpButton) {
        signUpButton.addEventListener('click', () => {
            container.classList.add("right-panel-active");
            limparAlertas();
        });
    }

    if (signInButton) {
        signInButton.addEventListener('click', () => {
            container.classList.remove("right-panel-active");
            limparAlertas();
        });
    }

    if (mobileSignUpButton) {
        mobileSignUpButton.addEventListener('click', () => {
            container.classList.add("right-panel-active");
            limparAlertas();
        });
    }

    if (mobileSignInButton) {
        mobileSignInButton.addEventListener('click', () => {
            container.classList.remove("right-panel-active");
            limparAlertas();
        });
    }

    if (registerForm) {
        registerForm.addEventListener('submit', async (event) => {
            event.preventDefault();
            limparAlertas();

            const submitButton = registerForm.querySelector('button[type="submit"]');
            if (submitButton) {
                submitButton.disabled = true;
            }

            try {
                const resultado = await enviarParaApi('api/auth/register', {
                    usuario: document.getElementById('cadastroUsuario').value,
                    email: document.getElementById('cadastroEmail').value,
                    senha: document.getElementById('cadastroSenha').value
                });

                if (resultado.ok) {
                    mostrarAlerta(registerSuccess, resultado.data.mensagem || 'Conta criada com sucesso.');
                    registerForm.reset();
                    container.classList.remove("right-panel-active");
                } else {
                    mostrarAlerta(registerError, resultado.data.mensagem || `Nao foi possivel cadastrar (HTTP ${resultado.status}).`);
                }
            } catch (error) {
                mostrarAlerta(registerError, `Falha ao comunicar com a API de cadastro: ${error.message}`);
            } finally {
                if (submitButton) {
                    submitButton.disabled = false;
                }
            }
        });
    }

    if (loginForm) {
        loginForm.addEventListener('submit', async (event) => {
            event.preventDefault();
            limparAlertas();

            const submitButton = loginForm.querySelector('button[type="submit"]');
            if (submitButton) {
                submitButton.disabled = true;
            }

            try {
                const resultado = await enviarParaApi('api/auth/login', {
                    email: document.getElementById('loginEmail').value,
                    senha: document.getElementById('loginSenha').value
                });

                if (resultado.ok) {
                    mostrarAlerta(loginSuccess, resultado.data.mensagem || 'Login realizado com sucesso.');
                    window.location.href = 'menu';
                } else {
                    mostrarAlerta(loginError, resultado.data.mensagem || `Credenciais invalidas (HTTP ${resultado.status}).`);
                }
            } catch (error) {
                mostrarAlerta(loginError, `Falha ao comunicar com a API de login: ${error.message}`);
            } finally {
                if (submitButton) {
                    submitButton.disabled = false;
                }
            }
        });
    }