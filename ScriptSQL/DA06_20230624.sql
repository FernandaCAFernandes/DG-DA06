
--- Desafio 3 
-- 1 Quantidade de Vendas no Estados do Ceará e São Paulo
SELECT cli.estado_cliente 
, SUM(v.quantidade_venda) AS Quantidade_Vendas
FROM dw.fato_vendas v 
INNER JOIN dw.dim_cliente cli ON v.codigo_cliente = cli.codigo_cliente
WHERE 1=1
AND cli.estado_cliente = 'São Paulo'
OR cli.estado_cliente = 'Ceará'
GROUP BY cli.estado_cliente
ORDER BY cli.estado_cliente 
DESC;

-- 2 Quantos Depedentes tem cada Vendedor
SELECT vend.nome_vendedor
, vend.codigo_vendedor
, COUNT (d.codigo_dependente) AS Quantidade_Dependentes
FROM dw.dim_vendedor vend 
INNER JOIN dw.dim_dependente d ON vend.codigo_vendedor = d.codigo_vendedor
WHERE 1=1
GROUP BY vend.nome_vendedor
, vend.codigo_vendedor
ORDER BY vend.codigo_vendedor
ASC;

SELECT * FROM dw.fato_vendas
