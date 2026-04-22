-- Criacao de ENUMs para garantir integridade dos dados e facilitar consultas
CREATE TYPE status_frete_enum AS ENUM (
    'EMITIDO', 
    'SAIDA_CONFIRMADA', 
    'EM_TRANSITO', 
    'ENTREGUE', 
    'NAO_ENTREGUE', 
    'CANCELADO'
);

CREATE TABLE frete (
    id SERIAL PRIMARY KEY,
    numero_frete VARCHAR(20) NOT NULL UNIQUE, -- Formato FRT-2026-0001
    
    -- Dados 
    remetente_id INT NOT NULL,
    destinatario_id INT NOT NULL,
    endereco_origem_id INT NOT NULL,
    endereco_destino_id INT NOT NULL,
    motorista_id INT NOT NULL,
    veiculo_id INT NOT NULL,
    
    -- Documentacao
    chave_nfe VARCHAR(44),
    origem_ibge VARCHAR(7) NOT NULL,
    destino_ibge VARCHAR(7) NOT NULL,
    natureza_carga VARCHAR(100),
    
    -- Pesos e Medidas
    peso_bruto DECIMAL(10,3),
    volumes INT,
    distancia_km DECIMAL(10,2) DEFAULT 0.00,
    
    -- Financeiro
    valor_frete_bruto DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    valor_pedagio DECIMAL(10,2) DEFAULT 0.00,
    aliquota_icms DECIMAL(5,2) DEFAULT 0.00,
    valor_icms DECIMAL(10,2) DEFAULT 0.00,
    valor_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    
    -- Status e Datas
    status status_frete_enum DEFAULT 'EMITIDO',
    data_emissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    previsao_entrega DATE,
    data_saida TIMESTAMP,
    data_entrega TIMESTAMP,
    
    -- Observacao
    motivo_falha TEXT,

    -- CONSTRAINTs 
    CONSTRAINT fk_remetente FOREIGN KEY (remetente_id) REFERENCES cliente(id),
    CONSTRAINT fk_destinatario FOREIGN KEY (destinatario_id) REFERENCES cliente(id),
    CONSTRAINT fk_origem_end FOREIGN KEY (endereco_origem_id) REFERENCES endereco(id),
    CONSTRAINT fk_destino_end FOREIGN KEY (endereco_destino_id) REFERENCES endereco(id),
    CONSTRAINT fk_motorista_frete FOREIGN KEY (motorista_id) REFERENCES motorista(id),
    CONSTRAINT fk_veiculo_frete FOREIGN KEY (veiculo_id) REFERENCES veiculo(id)
);

CREATE INDEX idx_frete_numero ON frete(numero_frete);
CREATE INDEX idx_frete_status ON frete(status);
CREATE INDEX idx_frete_data_emissao ON frete(data_emissao);