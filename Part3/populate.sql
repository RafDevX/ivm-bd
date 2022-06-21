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
	FOREIGN KEY(nome) REFERENCES categoria(nome)
);

CREATE TABLE IF NOT EXISTS super_categoria (
	nome VARCHAR(50) PRIMARY KEY,
	FOREIGN KEY(nome) REFERENCES categoria(nome)
);

CREATE TABLE IF NOT EXISTS tem_outra (
	super_categoria VARCHAR(50) NOT NULL,
	categoria VARCHAR(50) NOT NULL,
	PRIMARY KEY(super_categoria, categoria),
	FOREIGN KEY(super_categoria) REFERENCES super_categoria(nome),
	FOREIGN KEY(categoria) REFERENCES categoria(nome),
	CHECK (super_categoria <> categoria)
);

CREATE TABLE IF NOT EXISTS produto (
	ean CHAR(13) PRIMARY KEY,
	descr VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS tem_categoria (
	ean CHAR(13) NOT NULL,
	nome VARCHAR(50) NOT NULL,
	PRIMARY KEY (ean, nome),
	FOREIGN KEY(ean) REFERENCES produto(ean),
	FOREIGN KEY(nome) REFERENCES categoria(nome)
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
	FOREIGN KEY(num_serie, fabricante) REFERENCES IVM(num_serie, fabricante),
	FOREIGN KEY(local) REFERENCES ponto_de_retalho(nome)
);

CREATE TABLE IF NOT EXISTS prateleira (
	nro INT NOT NULL,
	num_serie VARCHAR(50) NOT NULL,
	fabricante VARCHAR(50) NOT NULL,
	altura INT NOT NULL,
	nome VARCHAR(50) NOT NULL,
	PRIMARY KEY(nro, num_serie, fabricante),
	FOREIGN KEY(num_serie, fabricante) REFERENCES IVM(num_serie, fabricante),
	FOREIGN KEY(nome) REFERENCES categoria(nome)
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
	FOREIGN KEY(ean) REFERENCES produto(ean),
	FOREIGN KEY(nro, num_serie, fabricante) REFERENCES prateleira(nro, num_serie, fabricante)
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
	FOREIGN KEY(num_serie, fabricante) REFERENCES IVM(num_serie, fabricante),
	FOREIGN KEY(tin) REFERENCES retalhista(tin),
	FOREIGN KEY(nome_cat) REFERENCES categoria(nome)
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
	FOREIGN KEY(ean, nro, num_serie, fabricante) REFERENCES planograma(ean, nro, num_serie, fabricante),
	FOREIGN KEY(tin) REFERENCES retalhista(tin)
);

INSERT INTO IVM(num_serie, fabricante) VALUES ('ABCD', 'Aldi');
INSERT INTO IVM(num_serie, fabricante) VALUES ('1234', 'Aldi');
INSERT INTO IVM(num_serie, fabricante) VALUES ('ABCD', 'Lidl');

INSERT INTO ponto_de_retalho(nome, distrito, concelho) VALUES ('Galp Oeiras', 'Lisboa', 'Oeiras');

INSERT INTO instalada_em(num_serie, fabricante, local) VALUES ('ABCD', 'Aldi', 'Galp Oeiras');
INSERT INTO instalada_em(num_serie, fabricante, local) VALUES ('1234', 'Aldi', 'Galp Oeiras');
INSERT INTO instalada_em(num_serie, fabricante, local) VALUES ('ABCD', 'Lidl', 'Galp Oeiras');

INSERT INTO categoria(nome) VALUES
	('Mercearia'),
	('Cereais e Barras'),
	('Compotas, Cremes e Mel'),
	('Conservas'),
	('Peixaria e Talho'),
	('Peixaria'),
	('Talho'),
	('Lacticínios e Ovos'),
	('Leite'),
	('Iogurtes'),
	('Ovos'),
	('Leite Magro'),
	('Leite Meio Gordo'),
	('Leite Gordo'),
	('Iogurtes Líquidos'),
	('Iogurtes Proteína'),
	('Iogurtes Gregos'),
	('Cereais Linha e Fibra'),
	('Muesli e Granola'),
	('Barras de Cereais'),
	('Doces e Compotas'),
	('Mel'),
	('Nutella e Cremes de Barrar'),
	('Atum'),
	('Salsichas'),
	('Patês'),
	('Alternativas Vegetarianas'),
	('Peixe Fresco'),
	('Peixe Congelado'),
	('Mariscos'),
	('Porco'),
	('Novilho, Vitela e Vitelão'),
	('Frango e Peru'),
	('Bebidas'),
	('Saudável');

INSERT INTO categoria_simples(nome) VALUES
	('Ovos'),
	('Leite Magro'),
	('Leite Meio Gordo'),
	('Leite Gordo'),
	('Iogurtes Líquidos'),
	('Iogurtes Proteína'),
	('Iogurtes Gregos'),
	('Cereais Linha e Fibra'),
	('Muesli e Granola'),
	('Barras de Cereais'),
	('Doces e Compotas'),
	('Mel'),
	('Nutella e Cremes de Barrar'),
	('Atum'),
	('Salsichas'),
	('Patês'),
	('Alternativas Vegetarianas'),
	('Peixe Fresco'),
	('Peixe Congelado'),
	('Mariscos'),
	('Porco'),
	('Novilho, Vitela e Vitelão'),
	('Frango e Peru'),
	('Bebidas'),
	('Saudável');

INSERT INTO super_categoria(nome) VALUES
	('Mercearia'),
	('Cereais e Barras'),
	('Compotas, Cremes e Mel'),
	('Conservas'),
	('Peixaria e Talho'),
	('Peixaria'),
	('Talho'),
	('Lacticínios e Ovos'),
	('Leite'),
	('Iogurtes');

INSERT INTO tem_outra(super_categoria, categoria) VALUES
	('Mercearia', 'Cereais e Barras'),
	('Cereais e Barras', 'Cereais Linha e Fibra'),
	('Cereais e Barras', 'Muesli e Granola'),
	('Cereais e Barras', 'Barras de Cereais'),
	('Mercearia', 'Compotas, Cremes e Mel'),
	('Compotas, Cremes e Mel', 'Doces e Compotas'),
	('Compotas, Cremes e Mel', 'Nutella e Cremes de Barrar'),
	('Compotas, Cremes e Mel', 'Mel'),
	('Mercearia', 'Conservas'),
	('Conservas', 'Atum'),
	('Conservas', 'Salsichas'),
	('Conservas', 'Patês'),
	('Peixaria e Talho', 'Peixaria'),
	('Peixaria', 'Peixe Fresco'),
	('Peixaria', 'Peixe Congelado'),
	('Peixaria', 'Mariscos'),
	('Peixaria e Talho', 'Talho'),
	('Talho', 'Porco'),
	('Talho', 'Novilho, Vitela e Vitelão'),
	('Talho', 'Frango e Peru'),
	('Peixaria e Talho', 'Alternativas Vegetarianas'),
	('Lacticínios e Ovos', 'Ovos'),
	('Lacticínios e Ovos', 'Leite'),
	('Leite', 'Leite Magro'),
	('Leite', 'Leite Meio Gordo'),
	('Leite', 'Leite Gordo'),
	('Lacticínios e Ovos', 'Iogurtes'),
	('Iogurtes', 'Iogurtes Líquidos'),
	('Iogurtes', 'Iogurtes Proteína'),
	('Iogurtes', 'Iogurtes Gregos');


INSERT INTO prateleira(nro, num_serie, fabricante, altura, nome) VALUES (1, 'ABCD', 'Aldi', 120, 'Bebidas');
INSERT INTO prateleira(nro, num_serie, fabricante, altura, nome) VALUES (2, 'ABCD', 'Aldi', 220, 'Bebidas');
INSERT INTO prateleira(nro, num_serie, fabricante, altura, nome) VALUES (1, 'ABCD', 'Lidl', 100, 'Barras de Cereais');
INSERT INTO prateleira(nro, num_serie, fabricante, altura, nome) VALUES (1, '1234', 'Aldi', 300, 'Barras de Cereais');
INSERT INTO prateleira(nro, num_serie, fabricante, altura, nome) VALUES (3, '1234', 'Aldi', 120, 'Bebidas');

INSERT INTO produto(ean, descr) VALUES ('9002490100070', 'Ice Tea');
INSERT INTO produto(ean, descr) VALUES ('9002490100123', 'Água');
INSERT INTO produto(ean, descr) VALUES ('9002490100456', 'Marmelada');
INSERT INTO produto(ean, descr) VALUES ('9002490100789', 'Barritas');

INSERT INTO tem_categoria(ean, nome) VALUES ('9002490100070', 'Bebidas');
INSERT INTO tem_categoria(ean, nome) VALUES ('9002490100123', 'Bebidas');
INSERT INTO tem_categoria(ean, nome) VALUES ('9002490100123', 'Saudável');
INSERT INTO tem_categoria(ean, nome) VALUES ('9002490100456', 'Doces e Compotas');
INSERT INTO tem_categoria(ean, nome) VALUES ('9002490100789', 'Barras de Cereais');
INSERT INTO tem_categoria(ean, nome) VALUES ('9002490100789', 'Saudável');

INSERT INTO planograma(ean, nro, num_serie, fabricante, faces, unidades, loc) VALUES ('9002490100070', 1, 'ABCD', 'Aldi', 5, 10, 'Corredor 3');
INSERT INTO planograma(ean, nro, num_serie, fabricante, faces, unidades, loc) VALUES ('9002490100070', 2, 'ABCD', 'Aldi', 6, 12, 'Corredor 1');
INSERT INTO planograma(ean, nro, num_serie, fabricante, faces, unidades, loc) VALUES ('9002490100123', 1, 'ABCD', 'Aldi', 5, 12, 'Corredor 3');
INSERT INTO planograma(ean, nro, num_serie, fabricante, faces, unidades, loc) VALUES ('9002490100123', 1, 'ABCD', 'Lidl', 6, 10, 'Cave 01');
INSERT INTO planograma(ean, nro, num_serie, fabricante, faces, unidades, loc) VALUES ('9002490100789', 1, '1234', 'Aldi', 3, 23, 'Corredor 1');

INSERT INTO retalhista(tin, name) VALUES ('500123456', 'Galp');
INSERT INTO retalhista(tin, name) VALUES ('500789012', 'Repsol');
INSERT INTO retalhista(tin, name) VALUES ('500345678', 'Shell');

INSERT INTO evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin) VALUES ('9002490100070', 1, 'ABCD', 'Aldi', '2020-06-14T15:24:21Z', 15, '500123456');
INSERT INTO evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin) VALUES ('9002490100070', 1, 'ABCD', 'Aldi', '2020-07-13T12:04:41Z', 01, '500123456');
INSERT INTO evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin) VALUES ('9002490100070', 1, 'ABCD', 'Aldi', '2021-02-11T19:04:21Z', 04, '500123456');
INSERT INTO evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin) VALUES ('9002490100123', 1, 'ABCD', 'Lidl', '2022-03-13T08:09:12Z', 02, '500345678');
INSERT INTO evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin) VALUES ('9002490100123', 1, 'ABCD', 'Lidl', '2022-03-13T08:09:13Z', 23, '500345678');
INSERT INTO evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin) VALUES ('9002490100789', 1, '1234', 'Aldi', '2022-03-13T08:09:13Z', 12, '500345678');
INSERT INTO evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin) VALUES ('9002490100789', 1, '1234', 'Aldi', '2022-03-13T08:09:24Z', 13, '500345678');

INSERT INTO responsavel_por(nome_cat, tin, num_serie, fabricante) VALUES ('Bebidas',  '500123456', 'ABCD', 'Aldi');
INSERT INTO responsavel_por(nome_cat, tin, num_serie, fabricante) VALUES ('Saudável', '500345678', 'ABCD', 'Lidl');
