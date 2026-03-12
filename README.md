# Análise de Vendas no Varejo — Projeto SQL

## Visão Geral do Projeto

**Título**: Análise de Vendas no Varejo  
**Nível**: Iniciante  
**Banco de Dados**: `sql_project_p1`  
**Ferramenta**: Microsoft SQL Server  

Este projeto demonstra habilidades e técnicas SQL utilizadas por analistas de dados para explorar, limpar e analisar dados de vendas no varejo. O projeto envolve renomear e preparar a tabela de vendas, realizar uma análise exploratória dos dados (EDA) e responder perguntas de negócio específicas por meio de queries SQL. Ideal para quem está começando na área de dados e quer construir uma base sólida em SQL.

---

## Objetivos

1. **Configurar a tabela de vendas**: Renomear e preparar a tabela de vendas com os dados fornecidos.
2. **Limpeza de dados**: Identificar e remover registros com valores nulos.
3. **Análise Exploratória (EDA)**: Realizar uma análise básica para entender o conjunto de dados.
4. **Análise de Negócio**: Usar SQL para responder perguntas de negócio e extrair insights dos dados de vendas.

---

## Estrutura do Projeto

### 1. Preparação da Tabela

A tabela original foi renomeada para `retail_sales` usando o comando abaixo:

```sql
EXEC sp_rename '[SQL - Retail Sales Analysis_utf]', 'retail_sales';
```

A tabela `retail_sales` contém as seguintes colunas:

| Coluna | Descrição |
|---|---|
| transactions_id | ID único da transação |
| sale_date | Data da venda |
| sale_time | Hora da venda |
| customer_id | ID do cliente |
| gender | Gênero do cliente |
| age | Idade do cliente |
| category | Categoria do produto |
| quantiy | Quantidade vendida |
| price_per_unit | Preço por unidade |
| cogs | Custo dos produtos vendidos |
| total_sale | Valor total da venda |

---

### 2. Exploração e Limpeza dos Dados

- **Contagem de registros**: Total de vendas na tabela.
- **Contagem de clientes**: Quantidade de clientes únicos.
- **Categorias**: Identificação das categorias de produtos disponíveis.
- **Verificação de nulos**: Checagem e remoção de registros com dados faltantes.

```sql
-- Total de vendas
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Total de clientes únicos
SELECT COUNT(DISTINCT customer_id) AS total_clientes FROM retail_sales;

-- Categorias disponíveis
SELECT DISTINCT category FROM retail_sales;

-- Verificar registros com valores nulos
SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL OR
    sale_date IS NULL OR
    gender IS NULL OR
    quantiy IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL OR
    category IS NULL;

-- Deletar registros com valores nulos
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL OR
    sale_date IS NULL OR
    gender IS NULL OR
    quantiy IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL OR
    category IS NULL;
```

---

### 3. Análise de Dados e Resultados

As queries abaixo foram desenvolvidas para responder perguntas de negócio específicas:

**Q1. Retornar todas as vendas realizadas em '2022-11-05':**
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

**Q2. Retornar todas as transações da categoria 'Clothing' com quantidade >= 4 em novembro de 2022:**
```sql
SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND FORMAT(sale_date, 'yyyy-MM') = '2022-11'
    AND quantiy >= 4;
```

**Q3. Calcular o total de vendas por categoria:**
```sql
SELECT 
    category,
    SUM(total_sale) AS total_sale_category,
    COUNT(*) AS total_vendas
FROM retail_sales
GROUP BY category;
```

**Q4. Encontrar a média de idade dos clientes que compraram da categoria 'Beauty':**
```sql
SELECT 
    AVG(age) AS media_idade,
    COUNT(*) AS total_vendas
FROM retail_sales
WHERE category = 'Beauty';
```

**Q5. Encontrar todas as transações com total_sale maior que 1000:**
```sql
SELECT total_sale 
FROM retail_sales
WHERE total_sale > 1000;
```

**Q6. Total de transações por gênero em cada categoria:**
```sql
SELECT
    category,
    gender,
    COUNT(*) AS total_trans
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

**Q7. Média de vendas por mês e mês com maior venda em cada ano:**
```sql
SELECT
    YEAR(sale_date)  AS ano,
    MONTH(sale_date) AS mes,
    AVG(total_sale)  AS media_vendas,
    RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS ranking
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY YEAR(sale_date), MONTH(sale_date);
```

**Q8. Top 5 clientes com maior total de vendas:**
```sql
SELECT
    customer_id,
    SUM(total_sale) AS total_vendas
FROM retail_sales
GROUP BY customer_id
ORDER BY total_vendas DESC;
```

**Q9. Número de clientes únicos por categoria:**
```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS clientes_unicos
FROM retail_sales
GROUP BY category;
```

**Q10. Criar turnos e contar número de pedidos por turno:**
```sql
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Manhã'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Tarde'
            ELSE 'Noite'
        END AS turno
    FROM retail_sales
)
SELECT 
    turno,
    COUNT(*) AS total_pedidos
FROM hourly_sale
GROUP BY turno
ORDER BY total_pedidos DESC;
```

---

## Conclusões

- **Perfil dos clientes**: O conjunto de dados inclui clientes de diferentes faixas etárias, com vendas distribuídas em categorias como Clothing e Beauty.
- **Transações de alto valor**: Diversas transações com total_sale acima de 1000 indicam compras de maior valor agregado.
- **Tendências de vendas**: A análise mensal revela variações sazonais, ajudando a identificar os meses de pico.
- **Insights de clientes**: A análise identifica os clientes que mais gastam e as categorias mais populares.

---

## Relatórios Gerados

- **Resumo de Vendas**: Total de vendas, perfil demográfico dos clientes e desempenho por categoria.
- **Análise de Tendências**: Insights sobre vendas por mês e por turno do dia.
- **Insights de Clientes**: Ranking dos top clientes e contagem de clientes únicos por categoria.
