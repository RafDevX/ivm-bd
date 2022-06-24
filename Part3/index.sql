/*
7.1
SELECT DISTINCT R.name
FROM retalhista R, responsavel_por P
WHERE R.tin = P.tin AND P.nome_cat = 'Frutos'

not sure se o SELECT DISTINCT consegue usar o index
we'll find out once DSI fixes its shit

tin é primary key, logo já tem um B-TREE(tin) index

a query combina indices pelo que queremos usar o mesmo tipo de index para nome_cat e tin
*/
CREATE INDEX name_index ON retalhista USING HASH(name)
CREATE INDEX nome_cat_index ON responsavel_por USING BTREE(nome_cat)

/*
7.2
SELECT T.nome, count(T.ean)
FROM produto P, tem_categoria T
WHERE P.cat = T.nome AND P.desc like 'A%'
GROUP BY T.nome

o correia diz que o GROUP BY é melhor com B-TREE mas não encontro a fonte.
uma possibilidade é ele lido isto (https://www.postgresql.org/docs/current/indexes-ordering.html) e confundido com GROUP BY
caso não se encontre a fonte deviamos usar o HASH

o LIKE necessita de B-TREE index

should we index P.cat?
*/
CREATE INDEX nome_index ON tem_categoria USING HASH(nome)
CREATE INDEX desc_index ON produto USING BTREE(desc)
