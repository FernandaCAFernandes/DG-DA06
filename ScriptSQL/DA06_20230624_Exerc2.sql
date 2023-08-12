
-- -------------
-- Exercicio --
-- -------------

-- -------------
-- 1. 
-- Apresente a query para listar o código e o nome do vendedor com maior número de vendas	
-- (contagem), e que estas vendas estejam com o status concluída. As colunas presentes no	
-- resultado devem ser, portanto, codigovendedor (cdvdd) e nomevendedor (nmvdd). 			
-- -------------
SELECT v.codigo_vendedor
, v.nome_vendedor
--, COUNT (ven.codigo_venda)
FROM dw.dim_vendedor v 
INNER JOIN dw.fato_vendas ven ON v.codigo_vendedor = ven.codigo_vendedor
INNER JOIN dw.dim_status s ON ven.codigo_status_venda = s.codigo_status
WHERE 1=1
AND s.status = 'Concluída'
GROUP BY v.codigo_vendedor
, v.nome_vendedor
ORDER BY COUNT (ven.codigo_venda)
DESC
LIMIT 1; 


-- -------------
-- 2. 
-- Apresente a query para listar o código e nome do produto mais vendido entre as datas de		
-- 2014-02-03 até 2018-02-02. As colunas presentes no resultado devem ser codigoproduto (cdpro)	
-- e nomeproduto (nmpro).																		
-- -------------
SELECT pro.codigo_produto
, pro.nome_produto
--, SUM (ven.quantidade_venda) AS Quantidade_Venda
FROM dw.dim_produto pro 
INNER JOIN dw.fato_vendas ven ON ven.codigo_produto = pro.codigo_produto
WHERE 1=1
AND ven.codigo_data_venda BETWEEN '01/02/2010' AND '02/02/2018'
AND ven.codigo_status_venda = 1
GROUP BY pro.codigo_produto
, pro.nome_produto
ORDER BY SUM (ven.quantidade_venda)
DESC
LIMIT 1;

-- -------------
-- 3. 
-- Apresente a query para listar o código e nome cliente com maior gasto na loja. As colunas			
-- presentes no resultado devem ser codigocliente (cdcli), nomecliente (nmcli) e gasto, esta última		
-- representando o somatório das vendas atribuídas ao cliente.																											--
-- -------------
SELECT cli.codigo_cliente
, cli.nome_cliente
, SUM (v.quantidade_venda*v.valor_unitario_venda)
FROM dw.fato_vendas v 
INNER JOIN dw.dim_cliente cli ON cli.codigo_cliente = v.codigo_cliente
WHERE 1=1
AND v.codigo_status_venda = 1 
GROUP BY cli.codigo_cliente
, cli.nome_cliente
ORDER BY SUM(v.quantidade_venda*v.valor_unitario_venda)
DESC
LIMIT 1;

-- -------------
-- 4. 
-- Apresente a query para listar código, nome e data de nascimento dos dependentes do vendedor
-- com menor valor total bruto em vendas (não sendo zero). As colunas presentes no resultado
-- devem ser codigodependente (cddep), nomedependente (nmdep), datanascimento (dtnasc).											--																	--
-- ------------
SELECT d.codigo_dependente
, d.nome_dependente
, d.data_nascimento
, vdd.codigo_vendedor
, SUM(ven.quantidade_venda*ven.valor_unitario_venda)
FROM dw.dim_dependente d 
INNER JOIN dw.dim_vendedor vdd ON d.codigo_vendedor = vdd.codigo_vendedor
INNER JOIN dw.fato_vendas ven ON vdd.codigo_vendedor = ven.codigo_vendedor
WHERE 1=1
AND ven.codigo_status_venda = 1
GROUP BY d.codigo_dependente
, d.nome_dependente
, d.data_nascimento
, vdd.codigo_vendedor
HAVING SUM(ven.quantidade_venda*ven.valor_unitario_venda) > 0
ORDER BY SUM(ven.quantidade_venda*ven.valor_unitario_venda)
DESC
LIMIT 1;
