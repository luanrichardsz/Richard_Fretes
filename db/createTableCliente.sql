-- Criacao de ENUMs para garantir integridade dos dados e facilitar consultas
CREATE TYPE tipo_pessoa_enum AS ENUM ('FISICA', 'JURIDICA');
CREATE TYPE tipo_entrega_enum AS ENUM ('REMETENTE', 'DESTINATARIO', 'AMBOS');

CREATE TABLE cliente (
    id SERIAL PRIMARY KEY, 
    razao_social VARCHAR(200) NOT NULL,
    nome_fantasia VARCHAR(200),
    documento VARCHAR(14) NOT NULL UNIQUE,
    inscricao_estadual VARCHAR(20),
    tipo_pessoa tipo_pessoa_enum NOT NULL,
    tipo_entrega tipo_entrega_enum NOT NULL DEFAULT 'AMBOS',
    email VARCHAR(100),
    telefone VARCHAR(20),
    ativo BOOLEAN DEFAULT TRUE, 
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);