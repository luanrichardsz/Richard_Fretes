package br.com.motorista;

import br.com.motorista.MotoristaDAO;
import br.com.exception.CadastroException;
import br.com.motorista.Motorista;
import br.com.frete.FreteDAO;
import br.com.util.ValidationUtils;

import java.time.LocalDate;
import java.time.Period;

public class MotoristaBO {

    private final MotoristaDAO motoristaDAO;
    private final FreteDAO freteDAO;

    public MotoristaBO() {
        this(new MotoristaDAO(), new FreteDAO());
    }

    public MotoristaBO(MotoristaDAO motoristaDAO) {
        this(motoristaDAO, new FreteDAO());
    }

    public MotoristaBO(MotoristaDAO motoristaDAO, FreteDAO freteDAO) {
        this.motoristaDAO = motoristaDAO;
        this.freteDAO = freteDAO;
    }

    public void salvar(Motorista motorista) throws CadastroException {
        validarMotorista(motorista, false);
        motoristaDAO.salvar(motorista);
    }

    public void atualizar(Motorista motorista) throws CadastroException {
        validarMotorista(motorista, true);
        motoristaDAO.atualizar(motorista);
    }

    private void validarMotorista(Motorista motorista, boolean emEdicao) throws CadastroException {
        if (motorista == null) {
            throw new CadastroException("Motorista inválido.");
        }

        if (ValidationUtils.estaVazio(motorista.getNomeCompleto())) {
            throw new CadastroException("Nome completo é obrigatório.");
        }

        String cpfLimpo = ValidationUtils.manterSomenteDigitos(motorista.getCpf());
        if (!ValidationUtils.cpfValido(cpfLimpo)) {
            throw new CadastroException("CPF inválido.");
        }

        if (motoristaDAO.existeCpfParaOutroMotorista(cpfLimpo, emEdicao ? motorista.getId() : null)) {
            throw new CadastroException("Já existe um motorista cadastrado com este CPF.");
        }

        String rgLimpo = ValidationUtils.manterSomenteDigitos(motorista.getRg());
        if (rgLimpo.length() < 5 || rgLimpo.length() > 20) {
            throw new CadastroException("RG inválido.");
        }

        if (motorista.getDataNascimento() == null) {
            throw new CadastroException("Data de nascimento é obrigatória.");
        }

        int idade = Period.between(motorista.getDataNascimento(), LocalDate.now()).getYears();
        if (idade < 18) {
            throw new CadastroException("O motorista deve ter pelo menos 18 anos.");
        }

        if (idade > 100) {
            throw new CadastroException("Data de nascimento inválida.");
        }

        String telefoneLimpo = ValidationUtils.manterSomenteDigitos(motorista.getTelefone());
        if (!ValidationUtils.telefoneValido(telefoneLimpo)) {
            throw new CadastroException("Telefone inválido.");
        }

        if (!ValidationUtils.estaVazio(motorista.getTelefoneEmergencia())) {
            String telefoneEmergenciaLimpo = ValidationUtils.manterSomenteDigitos(motorista.getTelefoneEmergencia());
            if (!ValidationUtils.telefoneValido(telefoneEmergenciaLimpo)) {
                throw new CadastroException("Telefone de emergência inválido.");
            }
            motorista.setTelefoneEmergencia(telefoneEmergenciaLimpo);
        }

        if (ValidationUtils.estaVazio(motorista.getNumeroCnh())) {
            throw new CadastroException("Número CNH é obrigatório.");
        }

        String cnhLimpa = ValidationUtils.manterSomenteDigitos(motorista.getNumeroCnh());
        if (cnhLimpa.length() != 11) {
            throw new CadastroException("Número CNH inválido.");
        }

        if (motoristaDAO.existeCnhParaOutroMotorista(cnhLimpa, emEdicao ? motorista.getId() : null)) {
            throw new CadastroException("Já existe um motorista cadastrado com esta CNH.");
        }

        if (motorista.getValidadeCnh() == null) {
            throw new CadastroException("Validade CNH é obrigatória.");
        }

        if (!ValidationUtils.estaVazio(motorista.getChavePix())) {
            validarChavePix(motorista);
        } else {
            throw new CadastroException("Chave PIX é obrigatória.");
        }

        if (motorista.getClienteId() == null) {
            throw new CadastroException("Cliente responsável pelo motorista é obrigatório.");
        }

        if (emEdicao
                && motorista.getStatus() == Motorista.StatusMotorista.INATIVO
                && freteDAO.existeFreteAtivoParaMotorista(motorista.getId(), null)) {
            throw new CadastroException(
                "Não é permitido inativar um motorista com frete em status EMITIDO, SAÍDA CONFIRMADA ou EM TRÂNSITO."
            );
        }

        motorista.setNomeCompleto(motorista.getNomeCompleto().trim());
        motorista.setCpf(cpfLimpo);
        motorista.setRg(rgLimpo);
        motorista.setTelefone(telefoneLimpo);
        motorista.setNumeroCnh(cnhLimpa);

        if (motorista.getNomeEmergencia() != null) {
            motorista.setNomeEmergencia(motorista.getNomeEmergencia().trim());
        }

        if (motorista.getParentescoEmergencia() != null) {
            motorista.setParentescoEmergencia(motorista.getParentescoEmergencia().trim());
        }
    }

    private void validarChavePix(Motorista motorista) throws CadastroException {
        String chavePix = motorista.getChavePix().trim();

        switch (motorista.getTipoPix()) {
            case CPF:
                String cpfPix = ValidationUtils.manterSomenteDigitos(chavePix);
                if (!ValidationUtils.cpfValido(cpfPix)) {
                    throw new CadastroException("Chave PIX CPF inválida.");
                }
                motorista.setChavePix(cpfPix);
                break;
            case CNPJ:
                String cnpjPix = ValidationUtils.manterSomenteDigitos(chavePix);
                if (!ValidationUtils.cnpjValido(cnpjPix)) {
                    throw new CadastroException("Chave PIX CNPJ inválida.");
                }
                motorista.setChavePix(cnpjPix);
                break;
            case CELULAR:
                String celularPix = ValidationUtils.manterSomenteDigitos(chavePix);
                if (!ValidationUtils.telefoneValido(celularPix)) {
                    throw new CadastroException("Chave PIX celular inválida.");
                }
                motorista.setChavePix(celularPix);
                break;
            case EMAIL:
                if (!ValidationUtils.emailValido(chavePix)) {
                    throw new CadastroException("Chave PIX email inválida.");
                }
                motorista.setChavePix(chavePix);
                break;
            case CHAVE_ALEATORIA:
                if (ValidationUtils.estaVazio(chavePix)) {
                    throw new CadastroException("Chave PIX aleatória inválida.");
                }
                motorista.setChavePix(chavePix);
                break;
            default:
                throw new CadastroException("Tipo PIX inválido.");
        }
    }
}
