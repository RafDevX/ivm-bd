/*
7.1

tin é primary key, logo já tem um B-TREE(tin) index

a query combina indices pelo que queremos usar o mesmo tipo de index para nome_cat
src: https://www.postgresql.org/docs/current/indexes-bitmap-scans.html
*/
CREATE INDEX nome_cat_index ON responsavel_por USING B-TREE(nome_cat)

/*
7.2

o correia diz que o GROUP BY é melhor com B-TREE mas não encontro a fonte.
uma possibilidade é ele lido isto (https://www.postgresql.org/docs/current/indexes-ordering.html) e confundido com GROUP BY
caso não se encontre a fonte deviamos usar o HASH

o LIKE necessita de B-TREE index

should we index P.cat?
*/
CREATE INDEX nome_index ON tem_categoria USING HASH(nome)
CREATE INDEX desc_index ON produto USING B-TREE(desc)
