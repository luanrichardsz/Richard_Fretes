CREATE TABLE endereco (
    id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    cep VARCHAR(8) NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL DEFAULT 'S/N',
    complemento VARCHAR(100),
    bairro VARCHAR(60),
    municipio VARCHAR(60) NOT NULL,
    codigo_ibge VARCHAR(7),
    uf CHAR(2) NOT NULL,
    ponto_referencia VARCHAR(150),
    
    -- Deletando o cliente, o endereço some junto 
    CONSTRAINT fk_cliente 
        FOREIGN KEY (cliente_id) 
        REFERENCES cliente(id) 
        ON DELETE CASCADE
);

CREATE INDEX idx_endereco_cliente ON endereco(cliente_id);