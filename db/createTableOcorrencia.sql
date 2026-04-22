-- Criacao de ENUMs para garantir integridade dos dados e facilitar consultas
CREATE TYPE tipo_ocorrencia_enum AS ENUM (
    'SAIDA_DO_PATIO', 
    'EM_ROTA', 
    'TENTATIVA_DE_ENTREGA', 
    'ENTREGA_REALIZADA', 
    'AVARIA', 
    'EXTRAVIO', 
    'OUTROS'
);

CREATE TABLE ocorrencia_frete (
    id SERIAL PRIMARY KEY,
    frete_id INT NOT NULL,
    tipo tipo_ocorrencia_enum NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    municipio VARCHAR(60) NOT NULL,
    uf CHAR(2) NOT NULL,
    
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    
    descricao TEXT, 
    recebedor_nome VARCHAR(100),
    recebedor_documento VARCHAR(20),
    foto_evidencia_url VARCHAR(255),

    -- O frete dessa ocorrencia sendo apagado, a ocorrencia se apaga
    CONSTRAINT fk_frete_ocorrencia 
        FOREIGN KEY (frete_id) 
        REFERENCES frete(id) 
        ON DELETE CASCADE
);

CREATE INDEX idx_ocorrencia_frete_id ON ocorrencia_frete(frete_id);
CREATE INDEX idx_ocorrencia_data_hora ON ocorrencia_frete(data_hora);