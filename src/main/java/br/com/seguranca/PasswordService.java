package br.com.seguranca;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Arrays;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class PasswordService {

    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final int ITERATIONS = 120000;
    private static final int SALT_LENGTH = 16;
    private static final int KEY_LENGTH = 160;
    private static final String PREFIX = "pbkdf2$";
    private final SecureRandom secureRandom = new SecureRandom();

    public String hash(String senhaEmTextoPuro) {
        byte[] salt = new byte[SALT_LENGTH];
        secureRandom.nextBytes(salt);
        byte[] hash = gerarHash(senhaEmTextoPuro, salt, ITERATIONS, KEY_LENGTH);
        byte[] combinado = new byte[salt.length + hash.length];
        System.arraycopy(salt, 0, combinado, 0, salt.length);
        System.arraycopy(hash, 0, combinado, salt.length, hash.length);
        return Base64.getEncoder().encodeToString(combinado);
    }

    public boolean matches(String senhaEmTextoPuro, String senhaHash) {
        if (senhaEmTextoPuro == null || senhaHash == null || senhaHash.trim().isEmpty()) {
            return false;
        }

        if (isCompactPbkdf2Hash(senhaHash)) {
            byte[] combinado = Base64.getDecoder().decode(senhaHash);
            byte[] salt = Arrays.copyOfRange(combinado, 0, SALT_LENGTH);
            byte[] hashEsperado = Arrays.copyOfRange(combinado, SALT_LENGTH, combinado.length);
            byte[] hashCalculado = gerarHash(senhaEmTextoPuro, salt, ITERATIONS, hashEsperado.length * 8);

            return comparacaoConstante(hashEsperado, hashCalculado);
        }

        if (isLegacyPbkdf2Hash(senhaHash)) {
            String[] partes = senhaHash.split("\\$");
            if (partes.length != 4) {
                return false;
            }

            int iterations = Integer.parseInt(partes[1]);
            byte[] salt = Base64.getDecoder().decode(partes[2]);
            byte[] hashEsperado = Base64.getDecoder().decode(partes[3]);
            byte[] hashCalculado = gerarHash(senhaEmTextoPuro, salt, iterations, hashEsperado.length * 8);

            return comparacaoConstante(hashEsperado, hashCalculado);
        }

        return senhaEmTextoPuro.equals(senhaHash);
    }

    public boolean needsRehash(String senhaArmazenada) {
        return !isCompactPbkdf2Hash(senhaArmazenada);
    }

    private boolean isCompactPbkdf2Hash(String valor) {
        if (valor == null || valor.startsWith(PREFIX)) {
            return false;
        }

        try {
            byte[] combinado = Base64.getDecoder().decode(valor);
            return combinado.length == (SALT_LENGTH + (KEY_LENGTH / 8));
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    private boolean isLegacyPbkdf2Hash(String valor) {
        return valor != null && valor.startsWith(PREFIX);
    }

    private byte[] gerarHash(String senha, byte[] salt, int iterations, int keyLength) {
        try {
            PBEKeySpec spec = new PBEKeySpec(senha.toCharArray(), salt, iterations, keyLength);
            SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
            return factory.generateSecret(spec).getEncoded();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new IllegalStateException("Nao foi possivel gerar o hash da senha.", e);
        }
    }

    private boolean comparacaoConstante(byte[] esperado, byte[] calculado) {
        if (esperado.length != calculado.length) {
            return false;
        }

        int resultado = 0;
        for (int i = 0; i < esperado.length; i++) {
            resultado |= esperado[i] ^ calculado[i];
        }
        return resultado == 0;
    }
}
