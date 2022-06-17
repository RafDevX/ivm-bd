DROP TABLE categoria CASCADE;
DROP TABLE categoria_simples CASCADE;
DROP TABLE super_categoria CASCADE;
DROP TABLE tem_outra CASCADE;
DROP TABLE produto CASCADE;
DROP TABLE tem_categoria CASCADE;
DROP TABLE IVM CASCADE;
DROP TABLE ponto_de_retalho CASCADE;
DROP TABLE instalada_em CASCADE;
DROP TABLE prateleira CASCADE;
DROP TABLE planograma CASCADE;
DROP TABLE retalhista CASCADE;
DROP TABLE responsavel_por CASCADE;
DROP TABLE evento_reposicao CASCADE;

CREATE TABLE IF NOT EXISTS categoria (
	nome VARCHAR(50) PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS categoria_simples (
	nome VARCHAR(50) PRIMARY KEY,
	CONSTRAINT fk_categoria_simples_categoria FOREIGN KEY(nome) REFERENCES categoria(nome)
);

CREATE TABLE IF NOT EXISTS super_categoria (
	nome VARCHAR(50) PRIMARY KEY,
	CONSTRAINT fk_super_categoria_categoria FOREIGN KEY(nome) REFERENCES categoria(nome)
);

CREATE TABLE IF NOT EXISTS tem_outra (
	super_categoria VARCHAR(50) NOT NULL,
	categoria VARCHAR(50) NOT NULL,
	PRIMARY KEY(super_categoria, categoria),
	CONSTRAINT fk_tem_outra_super_categoria FOREIGN KEY(super_categoria) REFERENCES super_categoria(nome),
	CONSTRAINT fk_tem_outra_categoria FOREIGN KEY(categoria) REFERENCES categoria(nome)
);

CREATE TABLE IF NOT EXISTS produto (
	ean CHAR(13) PRIMARY KEY,
	cat VARCHAR(50) NOT NULL,
	descr VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS tem_categoria (
	ean CHAR(13) NOT NULL,
	nome VARCHAR(50) NOT NULL,
	PRIMARY KEY (ean, nome),
	CONSTRAINT fk_tem_categoria_produto FOREIGN KEY(ean) REFERENCES produto(ean),
	CONSTRAINT fk_tem_categoria_categoria FOREIGN KEY(nome) REFERENCES categoria(nome)
);

CREATE TABLE IF NOT EXISTS IVM (
	num_serie VARCHAR(50) NOT NULL,
	fabricante VARCHAR(50) NOT NULL,
	PRIMARY KEY(num_serie, fabricante)
);

CREATE TABLE IF NOT EXISTS ponto_de_retalho (
	nome VARCHAR(50) PRIMARY KEY,
	distrito VARCHAR(50) NOT NULL,
	concelho VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS instalada_em (
	num_serie VARCHAR(50) NOT NULL,
	fabricante VARCHAR(50) NOT NULL,
	local VARCHAR(200) NOT NULL,
	PRIMARY KEY(num_serie, fabricante),
	CONSTRAINT fk_instalada_em_ivm FOREIGN KEY(num_serie, fabricante) REFERENCES IVM(num_serie, fabricante),
	CONSTRAINT fk_instalada_em_ponto_de_retalho FOREIGN KEY(local) REFERENCES ponto_de_retalho(nome)
);

CREATE TABLE IF NOT EXISTS prateleira (
	nro INT NOT NULL,
	num_serie VARCHAR(50) NOT NULL,
	fabricante VARCHAR(50) NOT NULL,
	altura INT NOT NULL,
	nome VARCHAR(50) NOT NULL,
	PRIMARY KEY(nro, num_serie, fabricante),
	CONSTRAINT fk_prateleira_ivm FOREIGN KEY(num_serie, fabricante) REFERENCES IVM(num_serie, fabricante),
	CONSTRAINT fk_prateleira_categoria FOREIGN KEY(nome) REFERENCES categoria(nome)
);

CREATE TABLE IF NOT EXISTS planograma (
	ean CHAR(13) NOT NULL,
	nro INT NOT NULL,
	num_serie VARCHAR(50) NOT NULL,
	fabricante VARCHAR(50) NOT NULL,
	faces INT NOT NULL,
	unidades INT NOT NULL,
	loc VARCHAR(255),
	PRIMARY KEY(ean, nro, num_serie, fabricante),
	CONSTRAINT fk_planograma_produto FOREIGN KEY(ean) REFERENCES produto(ean),
	CONSTRAINT fk_planograma_prateleira FOREIGN KEY(nro, num_serie, fabricante) REFERENCES prateleira(nro, num_serie, fabricante)
);

CREATE TABLE IF NOT EXISTS retalhista (
	tin CHAR(9) PRIMARY KEY,
	name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS responsavel_por (
	nome_cat VARCHAR(50) NOT NULL,
	tin CHAR(9) NOT NULL,
	num_serie VARCHAR(50) NOT NULL,
	fabricante VARCHAR(50) NOT NULL,
	PRIMARY KEY(num_serie, fabricante),
	CONSTRAINT fk_responsavel_por_ivm FOREIGN KEY(num_serie, fabricante) REFERENCES IVM(num_serie, fabricante),
	CONSTRAINT fk_responsavel_por_retalhista FOREIGN KEY(tin) REFERENCES retalhista(tin),
	CONSTRAINT fk_responsavel_por_categoria FOREIGN KEY(nome_cat) REFERENCES categoria(nome)
);

CREATE TABLE IF NOT EXISTS evento_reposicao (
	ean CHAR(13) NOT NULL,
	nro INT NOT NULL,
	num_serie VARCHAR(50) NOT NULL,
	fabricante VARCHAR(50) NOT NULL,
	instante TIMESTAMP NOT NULL,
	unidades INT NOT NULL,
	tin CHAR(9) NOT NULL,
	PRIMARY KEY(ean, nro, num_serie, fabricante, instante),
	CONSTRAINT fk_evento_reposicao_planograma FOREIGN KEY(ean, nro, num_serie, fabricante) REFERENCES planograma(ean, nro, num_serie, fabricante),
	CONSTRAINT fk_evento_reposicao_retalhista FOREIGN KEY(tin) REFERENCES retalhista(tin)
);
