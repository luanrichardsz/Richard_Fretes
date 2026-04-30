-- Criacao de ENUMs para garantir integridade dos dados e facilitar consultas
CREATE TYPE categoria_cnh_enum AS ENUM ('A', 'B', 'C', 'D', 'E', 'AB', 'AC', 'AD', 'AE');
CREATE TYPE tipo_vinculo_enum AS ENUM ('FUNCIONARIO', 'AGREGADO', 'TERCEIRO');
CREATE TYPE tipo_pix_enum AS ENUM ('CPF', 'CNPJ', 'EMAIL', 'CELULAR', 'CHAVE_ALEATORIA');
CREATE TYPE status_motorista_enum AS ENUM ('ATIVO', 'INATIVO', 'SUSPENSO');

CREATE TABLE motorista (
    id SERIAL PRIMARY KEY,
    nome_completo VARCHAR(150) NOT NULL,
    rg VARCHAR(20),
    cpf VARCHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    telefone VARCHAR(20) NOT NULL,

    -- Contato de Emergência
    nome_emergencia VARCHAR(100),
    telefone_emergencia VARCHAR(20),
    parentesco_emergencia VARCHAR(30),

    -- CNH
    numero_cnh VARCHAR(15) NOT NULL UNIQUE,
    categoria_cnh categoria_cnh_enum NOT NULL,
    validade_cnh DATE NOT NULL,
    validade_toxicologico DATE NOT NULL,

    -- Financeiro
    tipo_vinculo tipo_vinculo_enum NOT NULL,
    chave_pix VARCHAR(100),
    tipo_pix tipo_pix_enum,
    status status_motorista_enum DEFAULT 'ATIVO',
    adicionado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	-- Ligação com a empresa
	cliente_id INT NOT NULL,

	CONSTRAINT fk_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE INDEX idx_motorista_cpf ON motorista(cpf);
CREATE INDEX idx_motorista_cnh ON motorista(numero_cnh);