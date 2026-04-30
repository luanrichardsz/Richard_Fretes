package br.com.util;

public final class ValidationUtils {

    private ValidationUtils() {
    }

    public static boolean estaVazio(String valor) {
        return valor == null || valor.trim().isEmpty();
    }

    public static String manterSomenteDigitos(String valor) {
        return valor == null ? "" : valor.replaceAll("\\D", "");
    }

    public static boolean emailValido(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }

    public static boolean telefoneValido(String telefone) {
        String telefoneLimpo = manterSomenteDigitos(telefone);
        return telefoneLimpo.length() >= 10 && telefoneLimpo.length() <= 11;
    }

    public static boolean cpfValido(String cpf) {
        if (cpf == null || cpf.length() != 11 || cpf.matches("(\\d)\\1{10}")) {
            return false;
        }

        int digito1 = calcularDigitoCpf(cpf, 9, 10);
        int digito2 = calcularDigitoCpf(cpf, 10, 11);

        return digito1 == Character.getNumericValue(cpf.charAt(9))
            && digito2 == Character.getNumericValue(cpf.charAt(10));
    }

    public static boolean cnpjValido(String cnpj) {
        if (cnpj == null || cnpj.length() != 14 || cnpj.matches("(\\d)\\1{13}")) {
            return false;
        }

        int digito1 = calcularDigitoCnpj(cnpj, new int[]{5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2});
        int digito2 = calcularDigitoCnpj(cnpj, new int[]{6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2});

        return digito1 == Character.getNumericValue(cnpj.charAt(12))
            && digito2 == Character.getNumericValue(cnpj.charAt(13));
    }

    private static int calcularDigitoCpf(String cpf, int tamanhoBase, int pesoInicial) {
        int soma = 0;

        for (int i = 0; i < tamanhoBase; i++) {
            soma += Character.getNumericValue(cpf.charAt(i)) * (pesoInicial - i);
        }

        int resto = (soma * 10) % 11;
        return resto == 10 ? 0 : resto;
    }

    private static int calcularDigitoCnpj(String cnpj, int[] pesos) {
        int soma = 0;

        for (int i = 0; i < pesos.length; i++) {
            soma += Character.getNumericValue(cnpj.charAt(i)) * pesos[i];
        }

        int resto = soma % 11;
        return resto < 2 ? 0 : 11 - resto;
    }
}
