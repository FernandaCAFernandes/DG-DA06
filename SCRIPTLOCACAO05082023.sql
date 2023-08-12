select * from dw.dim_cliente;
select * from dw.dim_carro;
select * from dw.dim_combustivel;
select * from dw.dim_vendedor;
select * from dw.dim_data;
select * from dw.fato_locacao;
-----------------------------------
-- SELECIONA A QTDE DE DIARIAS DE ACORDO COM O MODELO DO CARRO
SELECT DISTINCT ca.modelocarro
, SUM(l.qtddiaria) as Qtde_diaria_total
FROM dw.fato_locacao l
INNER JOIN 
dw.dim_carro ca
ON 
l.classicarro = ca.classicarro
GROUP BY ca.modelocarro
, l.qtddiaria;
-----------------------------
--SELECIONA A QTDE DE LOCACAO PELO ANO DO CARRO.
SELECT DISTINCT ca.anocarro as Ano_Carro
, COUNT(l.idlocacao) as Qtde_alocacao_total
FROM dw.fato_locacao l
INNER JOIN 
dw.dim_carro ca
ON 
l.classicarro = ca.classicarro
GROUP BY ca.anocarro
ORDER BY  COUNT(l.idlocacao) DESC;
------------------------------------
--SELECIONA OS TIPOS DE CARRO COM COMBUSTIVEL COM MAIOR LOCACAO.
SELECT DISTINCT 
co.tipocombustivel
, COUNT(l.idlocacao) AS QTDE_LOCACAO
FROM 
dw.fato_locacao l
INNER JOIN 
dw.dim_carro ca ON l.classicarro = ca.classicarro
INNER JOIN 
dw.dim_combustivel co ON ca.idcombustivel = co.idcombustivel
WHERE 1=1
GROUP BY co.tipocombustivel
ORDER BY COUNT(l.idlocacao) DESC;


