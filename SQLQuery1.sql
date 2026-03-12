
-- RENOMEANDO TABLE

EXEC sp_rename '[SQL - Retail Sales Analysis_utf]', 'retail_sales';

SELECT * FROM retail_sales;

-- 
SELECT 
COUNT(*)
FROM retail_sales;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	gender IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
	OR
	category IS NULL;


--
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	gender IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL
	OR
	category IS NULL;


-- Explorando os dados

-- Quantas vendas temos?

SELECT COUNT (*) as total_sales FROM retail_sales

-- Quaantos clientes temos?

SELECT COUNT (DISTINCT customer_id) as total_sale FROM retail_sales;


SELECT DISTINCT category FROM retail_sales;

--Analise de dados & Bussines


-- Q.2 Escreva uma query SQL para retornar todas as transações onde a categoria é 'Clothing' e a quantidade vendida é maior que 10 no mês de Nov-2022
-- Q.3 Escreva uma query SQL para calcular o total de vendas (total_sale) por categoria.
-- Q.4 Escreva uma query SQL para encontrar a média de idade dos clientes que compraram itens da categoria 'Beauty'.
-- Q.5 Escreva uma query SQL para encontrar todas as transações onde o total_sale é maior que 1000.
-- Q.6 Escreva uma query SQL para encontrar o número total de transações (transaction_id) realizadas por cada gênero em cada categoria.
-- Q.7 Escreva uma query SQL para calcular a média de vendas por mês. Descubra o mês com maior venda em cada ano.
-- Q.8 Escreva uma query SQL para encontrar os top 5 clientes com base no maior total de vendas.
-- Q.9 Escreva uma query SQL para encontrar o número de clientes únicos que compraram itens de cada categoria.
-- Q.10 Escreva uma query SQL para criar turnos e número de pedidos (Exemplo: Manhã <= 12, Tarde entre 12 & 17, Noite > 17)



	
-- Escreva uma query SQL para retornar todas as colunas de vendas realizadas em '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Escreva uma query SQL para retornar todas as transações onde a categoria é 'Clothing' e a quantidade vendida é maior que 10 no mês de Nov-2022

SELECT 
    *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
		FORMAT(sale_date, 'yyyy-MM') = '2022-11'
    AND
    quantiy >= 4;


	-- Q.3 Escreva uma query SQL para calcular o total de vendas (total_sale) por categoria.

SELECT * FROM retail_sales;

SELECT category, SUM(total_sale) as total_sale_category,
	COUNT(*) as total_sales
FROM retail_sales
GROUP BY category;

	-- Escreva uma query SQL para encontrar a média de idade dos clientes que compraram itens da categoria 'Beauty'.

SELECT * FROM retail_sales;

SELECT AVG(customer_id) as customer_avg,
	COUNT(*) as total_sales
FROM retail_sales
WHERE category = 'Beauty';

	-- Escreva uma query SQL para encontrar todas as transações onde o total_sale é maior que 1000.

SELECT * FROM retail_sales;

SELECT total_sale FROM retail_sales
WHERE total_sale > 1000;

	-- Escreva uma query SQL para encontrar o número total de transações (transaction_id) realizadas por cada gênero em cada categoria.

SELECT * FROM retail_sales;

SELECT
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP BY category,
	gender
ORDER BY 1;


-- Escreva uma query SQL para calcular a média de vendas por mês. Descubra o mês com maior venda em cada ano.

SELECT
    YEAR(sale_date)  AS year,
    MONTH(sale_date) AS month,
    AVG(total_sale)  AS avg_sale,
    RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS ranking
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY YEAR(sale_date), MONTH(sale_date);

-- Escreva uma query SQL para encontrar os top 5 clientes com base no maior total de vendas.


SELECT * FROM retail_sales;

SELECT
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC;

-- Escreva uma query SQL para encontrar o número de clientes únicos que compraram itens de cada categoria.

SELECT * FROM retail_sales;

SELECT
	category, 
	COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

-- Escreva uma query SQL para criar turnos e número de pedidos (Exemplo: Manhã <= 12, Tarde entre 12 & 17, Noite > 17)

WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders    
FROM hourly_sale
GROUP BY shift
ORDER BY total_orders DESC;

-- FIM PROJETO



