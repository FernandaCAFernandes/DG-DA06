-- Dimensão Produto:
SELECT cdpro AS Codigo_Produto
, nmpro AS Nome_Produto
, tppro AS Tipo_Produto
, undpro AS Unidade_Medida_Produto
, slpro AS Saldo_Liquido_Produto
, stpro AS Status_Produto
FROM tbpro;

-- Dimensão Vendedor:
SELECT cdvdd AS Codigo_Vendedor
, nmvdd AS Nome_Vendedor
, CASE
	WHEN sxvdd = 1 THEN 'Masculino' 
	WHEN sxvdd = 0 THEN 'Feminino'
	ELSE 'None'
	END Sexo_Vendedor
, perccomissao AS Comissao_Vendedor
, matfunc AS Matriculo_Vendedor
FROM tbvdd;

--Dimensão Cliente:
SELECT DISTINCT nmcli AS Nome_Cliente
, agecli AS Idade_Cliente
, clacli AS Classificacao_Cliente
, CASE
	WHEN sxcli = 'M' THEN 'Masculino' 
	WHEN sxcli = 'F' THEN 'Feminino'
	ELSE 'None'
	END Sexo_Cliente
, cidcli AS Cidade_Cliente
, estcli AS Estado_Cliente
, paicli AS Pais_Cliente
FROM tbven; 

--Dimensão Dependente:
SELECT cdvdd AS Codigo_Vendedor
, cddep AS Codigo_Dependente
, nmdep AS Nome_Dependente
, TO_CHAR (dtnasc, 'DD/MM/YYYY') AS Data_Nascimento
,  CASE
	WHEN sxdep = 'M' THEN 'Masculino' 
	WHEN sxdep = 'F' THEN 'Feminino'
	ELSE 'None'
	END Sexo_Dependente
, inepescola AS Codigo_InepEscola
FROM tbdep
ORDER BY cdvdd; 

--Dimensão Canais:
/*Nesse caso são os tipos de canais do fato_venda OU
cada canal de cada venda? Dunno >< */
SELECT DISTINCT CASE 
	WHEN canal = 'Loja Própria' THEN 0
	WHEN canal = 'Loja Virtual' THEN 1 
	ELSE -1
	END Codigo_Canal
, canal AS Canal
FROM tbven
ORDER BY Codigo_Canal;

--Dimensão Status: 
/*Nesse caso são os tipos de status do fato_venda OU
cada status de cada venda? Dunno >< */
SELECT DISTINCT stven AS Codigo_Status
, CASE
	WHEN stven = 1 THEN 'Concluída'
	WHEN stven = 2 THEN 'Em Aberto'
	WHEN stven = 3 THEN 'Cancelada'
	ELSE 'None'
	END Status
FROM tbven
ORDER BY stven; 

-- Dimensão Data:
select * from tbven;

SELECT TO_CHAR (dtven, 'DD/MM/YYYY') AS Data_Completa_Venda
, DATE_PART ('week', dtven) AS Semana_Ano_Venda
, DATE_PART ('month', dtven) AS Mes_Venda
, DATE_PART ('year', dtven) AS Ano_Venda
, DATE_PART ('quarter', dtven) AS Trimestre_Venda
FROM tbven
ORDER BY dtven;

--Fato Vendas:
--O Select contém os valores númericos, não se deve alterar os códigos para texto.
-- Obs: Tabela Fato NÃO TEM TEXTO!
SELECT ven.cdven AS Codigo_Venda
, ven.cdcli AS Codigo_Cliente
, ven.cdvdd AS Codigo_Vendedor
, item.cdvenitem AS Codigo_Produto
, TO_CHAR (dtven, 'DD/MM/YYYY') AS Codigo_Data_Venda
, CASE 
	WHEN canal= 'Loja Própria' THEN 1
	WHEN canal = 'Loja Virtual' THEN 2
	ELSE -1 
	END Codigo_Canal
, ven.stven AS Codigo_Status_Venda
, item.qtven AS Quantidade_Venda
, item.vruven AS Valor_Unitario_Venda
, item.qtven * item.vruven AS Valor_Total_Venda
, ven.deleted AS Deletado
FROM tbven ven
LEFT JOIN tbven_item item ON ven.cdven = item.cdven
GROUP BY ven.cdcli
, ven.cdvdd
, item.cdvenitem
, ven.dtven
, ven.canal
, stven
, ven.cdven
, item.qtven
, item.vruven
, item.qtven * item.vruven
ORDER BY ven.cdven;

-- Criação do Schema DW : Criar um novo Scheme chamado xx_dw
--CREATE TABLE dw.nome_tabela AS SELECT DO SCHEME

-- Dim_Produto:
CREATE TABLE dw.dim_produto AS
SELECT cdpro AS Codigo_Produto
, nmpro AS Nome_Produto
, tppro AS Tipo_Produto
, undpro AS Unidade_Medida_Produto
, slpro AS Saldo_Liquido_Produto
, stpro AS Status_Produto
FROM tbpro;

-- Dim_Vendedor:
CREATE TABLE dw.dim_vendedor AS
SELECT cdvdd AS Codigo_Vendedor
, nmvdd AS Nome_Vendedor
, CASE
	WHEN sxvdd = 1 THEN 'Masculino' 
	WHEN sxvdd = 0 THEN 'Feminino'
	ELSE 'None'
	END Sexo_Vendedor
, perccomissao AS Comissao_Vendedor
, matfunc AS Matriculo_Vendedor
FROM tbvdd;

--Dim_Cliente:
CREATE TABLE dw.dim_cliente AS
SELECT DISTINCT nmcli AS Nome_Cliente
, agecli AS Idade_Cliente
, clacli AS Classificacao_Cliente
, CASE
	WHEN sxcli = 'M' THEN 'Masculino' 
	WHEN sxcli = 'F' THEN 'Feminino'
	ELSE 'None'
	END Sexo_Cliente
, cidcli AS Cidade_Cliente
, estcli AS Estado_Cliente
, paicli AS Pais_Cliente
FROM tbven; 

--Dim_Dependente:
CREATE TABLE dw.dim_dependente AS
SELECT cdvdd AS Codigo_Vendedor
, cddep AS Codigo_Dependente
, nmdep AS Nome_Dependente
, TO_CHAR (dtnasc, 'DD/MM/YYYY') AS Data_Nascimento
,  CASE
	WHEN sxdep = 'M' THEN 'Masculino' 
	WHEN sxdep = 'F' THEN 'Feminino'
	ELSE 'None'
	END Sexo_Dependente
, inepescola AS Codigo_InepEscola
FROM tbdep
ORDER BY cdvdd; 

--Dim_Canal
CREATE TABLE dw.dim_canal AS
SELECT DISTINCT CASE 
	WHEN canal = 'Loja Própria' THEN 0
	WHEN canal = 'Loja Virtual' THEN 1 
	ELSE -1
	END Codigo_Canal
, canal AS Canal
FROM tbven
ORDER BY Codigo_Canal;


--Dim_Status
CREATE TABLE dw.dim_status AS
SELECT DISTINCT stven AS Codigo_Status
, CASE
	WHEN stven = 1 THEN 'Concluída'
	WHEN stven = 2 THEN 'Em Aberto'
	WHEN stven = 3 THEN 'Cancelada'
	ELSE 'None'
	END Status
FROM tbven
ORDER BY stven; 

--Dim_Data
CREATE TABLE dw.dim_data AS
SELECT TO_CHAR (dtven, 'DD/MM/YYYY') AS Data_Completa_Venda
, DATE_PART ('week', dtven) AS Semana_Ano_Venda
, DATE_PART ('month', dtven) AS Mes_Venda
, DATE_PART ('year', dtven) AS Ano_Venda
, DATE_PART ('quarter', dtven) AS Trimestre_Venda
FROM tbven
ORDER BY dtven;

--Fato_Vendas
CREATE TABLE dw.fato_vendas AS
SELECT ven.cdven AS Codigo_Venda
, ven.cdcli AS Codigo_Cliente
, ven.cdvdd AS Codigo_Vendedor
, item.cdvenitem AS Codigo_Produto
, TO_CHAR (dtven, 'DD/MM/YYYY') AS Codigo_Data_Venda
, CASE 
	WHEN canal= 'Loja Própria' THEN 1
	WHEN canal = 'Loja Virtual' THEN 2
	ELSE -1 
	END Codigo_Canal
, ven.stven AS Codigo_Status_Venda
, item.qtven AS Quantidade_Venda
, item.vruven AS Valor_Unitario_Venda
, item.qtven * item.vruven AS Valor_Total_Venda
, ven.deleted AS Deletado
FROM tbven ven
LEFT JOIN tbven_item item ON ven.cdven = item.cdven
GROUP BY ven.cdcli
, ven.cdvdd
, item.cdvenitem
, ven.dtven
, ven.canal
, stven
, ven.cdven
, item.qtven
, item.vruven
, item.qtven * item.vruven
ORDER BY ven.cdven;

SELECT * FROM dw.dim_data;

--- Desafio 3 
-- 1 Quantidade de Vendas no Estados do Ceará e São Paulo
SELECT cli.estado_cliente 
, SUM(v.quantidade_venda) AS Quantidade_Vendas
FROM dw.fato_vendas v 
INNER JOIN dw.dim_cliente cli ON v.codigo_cliente = cli.codigo_cliente
WHERE 1=1
AND cli.estado_cliente in ('São Paulo', 'Ceará')
GROUP BY cli.estado_cliente
ORDER BY cli.estado_cliente 
ASC;

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
