DROP VIEW IF EXISTS Vendas;

CREATE VIEW Vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades) AS
  SELECT
    er.ean,
    er.nome,
    extract(YEAR FROM er.instante),
    extract(QUARTER FROM er.instante),
    extract(MONTH FROM er.instante),
    extract(DAY FROM er.instante),
    extract(DOW FROM er.instante),
    pr.distrito,
    pr.concelho,
    er.unidades
  FROM (
      evento_reposicao
      NATURAL JOIN instalada_em
      NATURAL JOIN tem_categoria
    ) AS er
    INNER JOIN ponto_de_retalho AS pr ON (er.local = pr.nome);
