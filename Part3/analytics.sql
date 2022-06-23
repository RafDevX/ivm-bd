/* 1. num dado período (i.e. entre duas datas), por dia da semana, por concelho e no total */

SELECT dia_semana, concelho, SUM(unidades)
	FROM Vendas
	WHERE make_date(ano :: int, mes :: int, dia_mes :: int)
		BETWEEN make_date(2019, 01, 01) AND make_date(2023, 12, 31)
	GROUP BY GROUPING SETS (dia_semana, concelho, ());

/* 2. num dado distrito (i.e. "Lisboa"), por concelho, categoria, dia da semana e no total */

SELECT concelho, cat, dia_semana, SUM(unidades)
	FROM Vendas
	WHERE distrito = 'Lisboa'
	GROUP BY CUBE(concelho, cat, dia_semana);
