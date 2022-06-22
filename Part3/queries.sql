/* 1. Qual o nome do retalhista (ou retalhistas) responsáveis pela reposição do maior número de categorias? */
SELECT name 
  FROM retalhista 
  NATURAL JOIN responsavel_por 
  GROUP BY tin 
  HAVING COUNT(tin) >= ALL (
    SELECT COUNT(tin) 
    FROM responsavel_por 
    GROUP BY tin
);

/* 2. Qual o nome do ou dos retalhistas que são responsáveis por todas as categorias simples? */
SELECT DISTINCT name FROM responsavel_por rp NATURAL JOIN retalhista
WHERE NOT EXISTS (
  SELECT nome
  FROM categoria_simples
  EXCEPT
  SELECT categoria_simples.nome
  FROM categoria_simples
  INNER JOIN responsavel_por
    ON responsavel_por.nome_cat = categoria_simples.nome
  WHERE responsavel_por.tin = rp.tin
);

/* 3. Quais os produtos (ean) que nunca foram repostos? */
SELECT p.ean
FROM produto AS p LEFT OUTER JOIN evento_reposicao er ON (p.ean = er.ean)
WHERE er.ean IS NULL;

/* 4. Quais os produtos (ean) que foram repostos sempre pelo mesmo retalhista? */
SELECT ean FROM evento_reposicao
  GROUP BY ean 
  HAVING COUNT(DISTINCT tin) = 1;
