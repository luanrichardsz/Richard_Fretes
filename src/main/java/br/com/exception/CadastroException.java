package br.com.exception;

public class CadastroException extends NegocioException {

    public CadastroException(String message) {
        super(message);
    }

    public CadastroException(String message, Throwable cause) {
        super(message, cause);
    }
}
