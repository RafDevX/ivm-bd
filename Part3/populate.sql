INSERT INTO IVM(num_serie, fabricante) VALUES ('ABCD', 'Aldi');
INSERT INTO IVM(num_serie, fabricante) VALUES ('1234', 'Aldi');
INSERT INTO IVM(num_serie, fabricante) VALUES ('ABCD', 'Lidl');
INSERT INTO IVM(num_serie, fabricante) VALUES
  ('001', 'Spar'),
  ('002', 'Spar'),
  ('003', 'Spar'),
  ('004', 'Spar'),
  ('005', 'Spar'),
  ('006', 'Spar'),
  ('007', 'Spar'),
  ('008', 'Spar'),
  ('009', 'Spar'),
  ('010', 'Spar'),
  ('011', 'Spar'),
  ('012', 'Spar'),
  ('013', 'Spar'),
  ('014', 'Spar'),
  ('015', 'Spar'),
  ('016', 'Spar'),
  ('017', 'Spar'),
  ('018', 'Spar'),
  ('019', 'Spar'),
  ('020', 'Spar'),
  ('021', 'Spar'),
  ('022', 'Spar'),
  ('023', 'Spar'),
  ('024', 'Spar'),
  ('025', 'Spar');

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
INSERT INTO planograma(ean, nro, num_serie, fabricante, faces, unidades, loc) VALUES ('9002490100789', 1, 'ABCD', 'Lidl', 6, 10, 'Cave 01');
INSERT INTO planograma(ean, nro, num_serie, fabricante, faces, unidades, loc) VALUES ('9002490100789', 1, '1234', 'Aldi', 3, 23, 'Corredor 1');

INSERT INTO retalhista(tin, name) VALUES ('500123456', 'Galp');
INSERT INTO retalhista(tin, name) VALUES ('500789012', 'Repsol');
INSERT INTO retalhista(tin, name) VALUES ('500345678', 'Shell');

INSERT INTO evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin) VALUES ('9002490100070', 1, 'ABCD', 'Aldi', '2020-06-14T15:24:21Z', 10, '500123456');
INSERT INTO evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin) VALUES ('9002490100070', 1, 'ABCD', 'Aldi', '2020-07-13T12:04:41Z', 01, '500123456');
INSERT INTO evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin) VALUES ('9002490100070', 1, 'ABCD', 'Aldi', '2021-02-11T19:04:21Z', 04, '500789012');
INSERT INTO evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin) VALUES ('9002490100789', 1, 'ABCD', 'Lidl', '2022-03-13T08:09:12Z', 02, '500345678');
INSERT INTO evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin) VALUES ('9002490100789', 1, '1234', 'Aldi', '2022-03-13T08:09:13Z', 12, '500345678');
INSERT INTO evento_reposicao(ean, nro, num_serie, fabricante, instante, unidades, tin) VALUES ('9002490100789', 1, '1234', 'Aldi', '2022-03-13T08:09:24Z', 13, '500345678');

INSERT INTO responsavel_por(nome_cat, tin, num_serie, fabricante) VALUES ('Bebidas',  '500123456', 'ABCD', 'Lidl');
INSERT INTO responsavel_por(nome_cat, tin, num_serie, fabricante) VALUES ('Saudável', '500345678', 'ABCD', 'Aldi');
INSERT INTO responsavel_por(nome_cat, tin, num_serie, fabricante) VALUES
	('Ovos', '500789012', '001', 'Spar'),
	('Leite Magro', '500789012', '002', 'Spar'),
	('Leite Meio Gordo', '500789012', '003', 'Spar'),
	('Leite Gordo', '500789012', '004', 'Spar'),
	('Iogurtes Líquidos', '500789012', '005', 'Spar'),
	('Iogurtes Proteína', '500789012', '006', 'Spar'),
	('Iogurtes Gregos', '500789012', '007', 'Spar'),
	('Cereais Linha e Fibra', '500789012', '008', 'Spar'),
	('Muesli e Granola', '500789012', '009', 'Spar'),
	('Barras de Cereais', '500789012', '010', 'Spar'),
	('Doces e Compotas', '500789012', '011', 'Spar'),
	('Mel', '500789012', '012', 'Spar'),
	('Nutella e Cremes de Barrar', '500789012', '013', 'Spar'),
	('Atum', '500789012', '014', 'Spar'),
	('Salsichas', '500789012', '015', 'Spar'),
	('Patês', '500789012', '016', 'Spar'),
	('Alternativas Vegetarianas', '500789012', '017', 'Spar'),
	('Peixe Fresco', '500789012', '018', 'Spar'),
	('Peixe Congelado', '500789012', '019', 'Spar'),
	('Mariscos', '500789012', '020', 'Spar'),
	('Porco', '500789012', '021', 'Spar'),
	('Novilho, Vitela e Vitelão', '500789012', '022', 'Spar'),
	('Frango e Peru', '500789012', '023', 'Spar'),
	('Bebidas', '500789012', '024', 'Spar'),
	('Saudável', '500789012', '025', 'Spar');
