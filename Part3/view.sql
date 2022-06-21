DROP VIEW IF EXISTS Vendas;

CREATE VIEW Vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades) AS
	SELECT
		er.ean,
		er.nome,
		EXTRACT(YEAR FROM er.instante),
		EXTRACT(QUARTER FROM er.instante),
		EXTRACT(MONTH FROM er.instante),
		EXTRACT(DAY FROM er.instante),
		EXTRACT(DOW FROM er.instante),
		pr.distrito,
		pr.concelho,
		er.unidades
	FROM (
		evento_reposicao
		NATURAL JOIN instalada_em
		NATURAL JOIN tem_categoria
	) AS er
	INNER JOIN ponto_de_retalho AS pr ON (er.local = pr.nome);
