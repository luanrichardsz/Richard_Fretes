CREATE TYPE tipo_manutencao_enum AS ENUM ('PREVENTIVA', 'CORRETIVA');

CREATE TYPE status_manutencao_enum AS ENUM ('AGENDADA', 'EM_ANDAMENTO', 'CONCLUIDA', 'CANCELADA');

CREATE TABLE manutencao_veiculo (
    id SERIAL PRIMARY KEY,
    veiculo_id INT NOT NULL,
    tipo tipo_manutencao_enum NOT NULL,
    status status_manutencao_enum NOT NULL DEFAULT 'AGENDADA',
    descricao VARCHAR(180) NOT NULL,
    data_prevista DATE NOT NULL,
    data_realizacao DATE,
    custo DECIMAL(10, 2) DEFAULT 0.00,
    fornecedor_oficina VARCHAR(120),
    observacao TEXT,
    adicionado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_veiculo_manutencao
        FOREIGN KEY (veiculo_id)
        REFERENCES veiculo(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_manutencao_veiculo_id ON manutencao_veiculo(veiculo_id);
CREATE INDEX idx_manutencao_status ON manutencao_veiculo(status);
CREATE INDEX idx_manutencao_data_prevista ON manutencao_veiculo(data_prevista);
