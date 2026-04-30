CREATE TABLE Usuario (
	id SERIAL PRIMARY KEY,
	usuario VARCHAR(150) NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
	senha VARCHAR(50) NOT NULL,
	is_administrador BOOLEAN DEFAULT FALSE,
	cliente_id INTEGER,
	ativo BOOLEAN DEFAULT TRUE
);

UPDATE 
	usuario
SET
	is_administrador = true	
WHERE
	id = 1;

UPDATE 
	usuario
SET
	cliente_id = 1	
WHERE
	id = 2;