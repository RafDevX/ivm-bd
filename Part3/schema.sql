DROP TABLE IF EXISTS categoria CASCADE;
DROP TABLE IF EXISTS categoria_simples CASCADE;
DROP TABLE IF EXISTS super_categoria CASCADE;
DROP TABLE IF EXISTS tem_outra CASCADE;
DROP TABLE IF EXISTS produto CASCADE;
DROP TABLE IF EXISTS tem_categoria CASCADE;
DROP TABLE IF EXISTS IVM CASCADE;
DROP TABLE IF EXISTS ponto_de_retalho CASCADE;
DROP TABLE IF EXISTS instalada_em CASCADE;
DROP TABLE IF EXISTS prateleira CASCADE;
DROP TABLE IF EXISTS planograma CASCADE;
DROP TABLE IF EXISTS retalhista CASCADE;
DROP TABLE IF EXISTS responsavel_por CASCADE;
DROP TABLE IF EXISTS evento_reposicao CASCADE;

CREATE TABLE IF NOT EXISTS categoria (
	nome VARCHAR(255) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS categoria_simples (
	nome VARCHAR(255) PRIMARY KEY REFERENCES categoria(nome)
);

CREATE TABLE IF NOT EXISTS super_categoria (
	nome VARCHAR(255) PRIMARY KEY REFERENCES categoria(nome)
);

CREATE TABLE IF NOT EXISTS tem_outra (
	super_categoria VARCHAR(255) NOT NULL REFERENCES super_categoria(nome),
	categoria VARCHAR(255) PRIMARY KEY REFERENCES categoria(nome)
);

CREATE TABLE IF NOT EXISTS produto (
	ean CHAR(13) PRIMARY KEY CHECK (ean ~ '^\d{13}$'),
	cat VARCHAR(255) NOT NULL REFERENCES categoria(nome),
	descr VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS tem_categoria (
	ean CHAR(13) NOT NULL REFERENCES produto(ean),
	nome VARCHAR(255) NOT NULL REFERENCES categoria(nome),
	PRIMARY KEY (ean, nome)
);

CREATE TABLE IF NOT EXISTS IVM (
	num_serie VARCHAR(255) NOT NULL,
	fabricante VARCHAR(255) NOT NULL,
	PRIMARY KEY (num_serie, fabricante)
);

CREATE TABLE IF NOT EXISTS ponto_de_retalho (
	nome VARCHAR(255) PRIMARY KEY,
	distrito VARCHAR(255) NOT NULL,
	concelho VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS instalada_em (
	num_serie VARCHAR(255) NOT NULL,
	fabricante VARCHAR(255) NOT NULL,
	local VARCHAR(255) NOT NULL REFERENCES ponto_de_retalho(nome),
	PRIMARY KEY (num_serie, fabricante),
	FOREIGN KEY (num_serie, fabricante) REFERENCES IVM(num_serie, fabricante)
);

CREATE TABLE IF NOT EXISTS prateleira (
	nro INT NOT NULL,
	num_serie VARCHAR(255) NOT NULL,
	fabricante VARCHAR(255) NOT NULL,
	altura INT NOT NULL,
	nome VARCHAR(255) NOT NULL REFERENCES categoria(nome),
	PRIMARY KEY (nro, num_serie, fabricante),
	FOREIGN KEY (num_serie, fabricante) REFERENCES IVM(num_serie, fabricante)
);

CREATE TABLE IF NOT EXISTS planograma (
	ean CHAR(13) NOT NULL REFERENCES produto(ean),
	nro INT NOT NULL,
	num_serie VARCHAR(255) NOT NULL,
	fabricante VARCHAR(255) NOT NULL,
	faces INT NOT NULL,
	unidades INT NOT NULL,
	loc VARCHAR(255),
	PRIMARY KEY (ean, nro, num_serie, fabricante),
	FOREIGN KEY (nro, num_serie, fabricante) REFERENCES prateleira(nro, num_serie, fabricante)
);

CREATE TABLE IF NOT EXISTS retalhista (
	tin CHAR(9) PRIMARY KEY CHECK (tin ~ '^\d{9}$'),
	name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS responsavel_por (
	nome_cat VARCHAR(255) NOT NULL REFERENCES categoria(nome),
	tin CHAR(9) NOT NULL REFERENCES retalhista(tin),
	num_serie VARCHAR(255) NOT NULL,
	fabricante VARCHAR(255) NOT NULL,
	PRIMARY KEY (num_serie, fabricante),
	FOREIGN KEY (num_serie, fabricante) REFERENCES IVM(num_serie, fabricante)
);

CREATE TABLE IF NOT EXISTS evento_reposicao (
	ean CHAR(13) NOT NULL,
	nro INT NOT NULL,
	num_serie VARCHAR(255) NOT NULL,
	fabricante VARCHAR(255) NOT NULL,
	instante TIMESTAMP NOT NULL,
	unidades INT NOT NULL,
	tin CHAR(9) NOT NULL REFERENCES retalhista(tin),
	PRIMARY KEY (ean, nro, num_serie, fabricante, instante),
	FOREIGN KEY (ean, nro, num_serie, fabricante) REFERENCES planograma(ean, nro, num_serie, fabricante)
);
