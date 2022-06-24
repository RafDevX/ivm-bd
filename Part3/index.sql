DROP INDEX IF EXISTS tin_index;
DROP INDEX IF EXISTS nome_cat_index;
DROP INDEX IF EXISTS cat_index;
DROP INDEX IF EXISTS descr_index;

/* 7.1 
O SELECT DISTINCT benificia de um indice para name em retalhista.
No entanto, o postgresql já cria este indice devido à UNIQUE constraint da coluna.

Na comparação R.tin = P.tin, R.tin é uma Primary key pelo que não é necessário criar um indice.
P.tin é um Foreign key, pelo que criamos um indice do mesmo tipo que o usado por R.tin, B-TREE.

P.nome_cat = 'Frutos' é uma comparação simples para a qual o indice do tipo HASH é o mais apropriado.
*/

CREATE INDEX tin_index ON responsavel_por USING BTREE(tin);
CREATE INDEX nome_cat_index ON responsavel_por USING HASH(nome_cat);

EXPLAIN ANALYZE SELECT DISTINCT R.name
  FROM retalhista R, responsavel_por P
  WHERE R.tin = P.tin AND P.nome_cat = 'Frutos';

/* 7.2
O GROUP BY T.nome benificia de um indice em tem_categoria para nome.
No entanto, o postgresql já cria um indice para (ean, nome) porque se trata da primary key.
O planner é capaz de usar este indice, pelo que não se justifica criar outro.

Na comparação P.cat = T.nome, T.nome já tem um indice utilizável.
Criamos para P.cat um indice do mesmo tipo que o usado por T.nome, B-TREE.

Na comparação P.descr like 'A%', criamos um indice do tipo B-TREE para descr em produto.
Indices do tipo B-TREE são capazes de agilizar operações de pattern matching.  
*/

CREATE INDEX cat_index ON produto USING BTREE(cat);
CREATE INDEX descr_index ON produto USING BTREE(descr);

EXPLAIN ANALYZE SELECT T.nome, count(T.ean)
  FROM produto P, tem_categoria T
  WHERE P.cat = T.nome AND P.descr like 'A%'
  GROUP BY T.nome;

