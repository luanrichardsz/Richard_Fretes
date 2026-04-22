-- Criacao de ENUMs para garantir integridade dos dados e facilitar consultas
CREATE TYPE status_veiculo_enum AS ENUM ('DISPONIVEL', 'EM_VIAGEM', 'EM_MANUTENCAO', 'INATIVO');

CREATE TABLE veiculo (
    id SERIAL PRIMARY KEY,
    placa VARCHAR(7) NOT NULL UNIQUE,
    renavam VARCHAR(11) NOT NULL UNIQUE,
    rntrc VARCHAR(20),
    ano_fabricacao INT NOT NULL,
    ano_modelo INT NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    tipo_outros VARCHAR(30),
    quantidade_eixos SMALLINT NOT NULL,
    combustivel VARCHAR(20) DEFAULT 'Diesel',
    tara_kg INT NOT NULL,
    capacidade_carga_kg INT NOT NULL,
    volume_m3 INT DEFAULT 0,
    status status_veiculo_enum DEFAULT 'DISPONIVEL',
    adicionado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    motorista_id INT,
    manutencao_pendente BOOLEAN DEFAULT FALSE,
    seguro_validade DATE,

    -- Vinculando motorista a veiculo (Um motorista pode ter varios veiculos, mas um veiculo tem apenas um motorista principal)
    CONSTRAINT fk_motorista_veiculo
        FOREIGN KEY (motorista_id) 
        REFERENCES motorista(id) 
        ON DELETE SET NULL
);

CREATE INDEX idx_veiculo_placa ON veiculo(placa);