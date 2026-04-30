package br.com.exception;

public class FreteException extends NegocioException {

    public FreteException(String message) {
        super(message);
    }

    public FreteException(String message, Throwable cause) {
        super(message, cause);
    }
}
