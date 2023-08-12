
-- -------------
-- Exercicio --
-- -------------

-- -------------
-- 1. 
-- Apresente a query para listar o código e o nome do vendedor com maior número de vendas	
-- (contagem), e que estas vendas estejam com o status concluída. As colunas presentes no	
-- resultado devem ser, portanto, codigovendedor (cdvdd) e nomevendedor (nmvdd). 			
-- -------------
SELECT vdd.cdvdd AS codigo_vendedor
, vdd.nmvdd AS nome_vendedor
--, ven.stven AS status_venda
--, SUM(item.qtven) AS qtde_vendida_total
FROM tbvdd vdd
INNER JOIN tbven ven ON vdd.cdvdd = ven.cdvdd
INNER JOIN tbven_item item ON ven.cdven = item.cdven
WHERE 1=1
AND ven.stven= 1
GROUP BY vdd.cdvdd
,vdd.nmvdd
--,ven.stven
ORDER BY SUM(item.qtven) 
DESC
LIMIT 1
;

-- -------------
-- 2. 
-- Apresente a query para listar o código e nome do produto mais vendido entre as datas de		
-- 2014-02-03 até 2018-02-02. As colunas presentes no resultado devem ser codigoproduto (cdpro)	
-- e nomeproduto (nmpro).																		
-- -------------
SELECT pro.cdpro AS codigo_produto
, pro.nmpro AS nome_produto
--, SUM(item.qtven) AS qtde_vendida_total
--, ven.dtven AS data_venda
FROM tbven ven
INNER JOIN tbven_item item ON ven.cdven = item.cdven
INNER JOIN tbpro pro ON item.cdpro = pro.cdpro
WHERE 1=1
AND ven.dtven BETWEEN '2014-02-03' AND '2018-02-02' 
AND ven.stven = 1 
GROUP BY pro.cdpro
, pro.nmpro
, ven.dtven
ORDER BY SUM(item.qtven) DESC
;

-- -------------
-- 3. 
-- Apresente a query para listar o código e nome cliente com maior gasto na loja. As colunas			
-- presentes no resultado devem ser codigocliente (cdcli), nomecliente (nmcli) e gasto, esta última		
-- representando o somatório das vendas atribuídas ao cliente.																											--
-- -------------
SELECT ven.cdcli AS codigo_cliente
, ven.nmcli AS nome_cliente
, SUM(item.qtven*item.vruven) AS preco_total
FROM tbven ven
INNER JOIN tbven_item item ON ven.cdven = item.cdven
WHERE 1=1
AND ven.stven = 1
GROUP BY ven.cdcli
, ven.nmcli
ORDER BY SUM(item.qtven*item.vruven) DESC
LIMIT 1
;

-- -------------
-- 4. 
-- Apresente a query para listar código, nome e data de nascimento dos dependentes do vendedor
-- com menor valor total bruto em vendas (não sendo zero). As colunas presentes no resultado
-- devem ser codigodependente (cddep), nomedependente (nmdep), datanascimento (dtnasc).											--																	--
-- -------------
SELECT dep.cddep AS codigo_depedente
, dep.nmdep AS nome_depedente
, dep.dtnasc AS data_nascimento_dependente
--, vdd.cdvdd AS codigo_vendedor
--, vdd.nmvdd AS nome_vendedor
--, SUM(item.qtven*item.vruven) AS valor_total_vendas
FROM tbvdd vdd
INNER JOIN tbven ven ON vdd.cdvdd = ven.cdvdd
INNER JOIN tbven_item item ON ven.cdven = item.cdven
INNER JOIN tbdep dep ON ven.cdvdd = dep.cdvdd
WHERE 1=1
AND ven.stven = 1
GROUP BY vdd.cdvdd
, vdd.nmvdd
, dep.cddep
, dep.nmdep
, dep.dtnasc
ORDER BY SUM(qtven*vruven) ASC
LIMIT 1 
;

-- -------------
-- 5. 
-- Apresente a query para listar os 3 produtos menos vendidos pelos canais de E-Commerce(Loja Virtual) ou
-- Matriz(Loja Propria). As colunas presentes no resultado devem ser canalvendas(canal), codigoproduto
-- (cdpro), nomeproduto (nmpro) e quantidade_vendas.										--																	--
-- -------------
SELECT ven.canal AS canal_venda
, pro.cdpro AS codigo_produto
, pro.nmpro AS nome_produto
, SUM(item.qtven) AS quantidade_vendas
FROM tbven ven
INNER JOIN tbven_item item ON ven.cdven = item.cdven
INNER JOIN tbpro pro ON item.cdpro = pro.cdpro
WHERE 1=1
AND ven.stven = 1
GROUP BY ven.canal
, pro.cdpro
, pro.nmpro
ORDER BY SUM(item.qtven) ASC
LIMIT 3
;


-- -------------
-- 6. 
-- Apresente a query para listar o gasto médio por estado da federação. As colunas presentes no
-- resultado devem ser estado e gastomedio. Considere apresentar a coluna gastomedio
-- arredondada na segunda casa decimal.																										--
-- -------------
SELECT ven.estcli AS estado
--, ven.paicli AS pais
--, AVG(item.qtven*item.vruven) AS gasto_medio_nd
, ROUND (AVG (item.qtven*item.vruven),2) AS gasto_medio
FROM tbven ven 
INNER JOIN tbven_item item ON ven.cdven = item.cdven
WHERE 1=1
AND ven.stven = 1
GROUP BY ven.estcli
--, ven.paicli
ORDER BY AVG(item.qtven*item.vruven)
;

-- -------------
-- 7. 
-- Apresente a query para listar o código das vendas (cdven) identificadas como deletadas.
-- Apresente o resultado em ordem crescente.																									--
-- -------------
SELECT ven.cdven AS codigo_venda
FROM tbven ven
WHERE 1=1
AND ven.stven = 1
AND ven.deleted = 1
ORDER BY ven.cdven ASC;

-- -------------
-- 8. 
-- Apresente a query para listar a quantidade média vendida de cada produto agrupado por estado
-- da federação. As colunas presentes no resultado devem ser estado e nomeproduto (nmprod) e
-- quantidade_media. Considere arredondar o valor da coluna quantidade_media na quarta casa
-- decimal. Ordene os resultados pelo estado (1o) e nome do produto (2o).																								--
-- -------------
SELECT ven.estcli AS estado
, pro.nmpro AS nome_produto
--, AVG(item.qtven) AS qtde_media_vendida_nd
, ROUND ( AVG(item.qtven),4) AS qtde_media_vendida
FROM tbven ven 
INNER JOIN tbven_item item ON ven.cdven = item.cdven
INNER JOIN tbpro pro ON item.cdpro = pro.cdpro
WHERE 1=1
AND ven.stven = 1
GROUP BY ven.estcli
, pro.nmpro
ORDER BY ven.estcli ASC
, pro.nmpro ASC
;

-- -------------
-- 9. 
-- Calcule a receita bruta por ano.																							--
-- -------------

SELECT EXTRACT(YEAR FROM dtven) AS ano
, SUM(item.qtven*item.vruven) AS recceita_bruta
FROM tbven ven
INNER JOIN tbven_item item ON ven.cdven = item.cdven
WHERE 1=1
AND ven.stven = 1
GROUP BY 1
ORDER BY EXTRACT(YEAR FROM dtven) ASC
;

-- -------------
-- 10. 
-- Calcule a receita bruta por ano e por estado.																							--
-- -------------
SELECT EXTRACT(YEAR FROM dtven) AS ano
, ven.estcli AS estado
, SUM(item.qtven*item.vruven) AS recceita_bruta
FROM tbven ven
INNER JOIN tbven_item item ON ven.cdven = item.cdven
WHERE 1=1
AND ven.stven = 1
GROUP BY EXTRACT(YEAR FROM dtven)
, ven.estcli
ORDER BY EXTRACT(YEAR FROM dtven) ASC
;


-- -------------
-- 11. 
-- Proponha um indicador....(Indexação? x-x dunno)																							--
-- -------------
CREATE INDEX index_ven ON tbven (cdven);

