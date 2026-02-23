-- Find each country and number of stores
SELECT 
  country, 
  COUNT(store_name) as number_of_stores
FROM stores
GROUP BY country
ORDER BY number_of_stores DESC;



-- What is the total number of units sold by each store?
SELECT 
  st.store_name,
  SUM(sl.quantity) as total_units_sold
FROM sales sl
LEFT JOIN stores st
  ON sl.store_id = st.store_id
GROUP BY st.store_name
ORDER BY total_units_sold DESC;



-- How many sales occurred in December 2023?
SELECT 
  SUM(quantity) as total_sales
FROM sales
WHERE sale_date >= '2023-12-01' AND sale_date <= '2023-12-31';


-- How many stores have never had a warranty claim filed against any of their products?
SELECT 
  st.store_name,
  COUNT(w.claim_id) AS number_of_claims
FROM sales sl
LEFT JOIN warranty w
  ON sl.sale_id = w.sale_id
LEFT JOIN stores st
  ON sl.store_id = st.store_id
GROUP BY st.store_name
HAVING number_of_claims = 0
ORDER BY number_of_claims DESC;


-- What percentage of warranty claims are marked as "Warranty Void"?
SELECT 
  repair_status,
  COUNT(claim_id) AS claims,
  ROUND( (COUNT(claim_id) / (SELECT COUNT(claim_id) FROM warranty))*100, 1) AS pct_claims
FROM warranty
GROUP BY repair_status;



-- Which store had the highest total units sold in the last year?
SELECT 
  st.store_name,
  SUM(quantity) AS total_units_sold
FROM sales sl
LEFT JOIN stores st 
  ON sl.store_id = st.store_id
WHERE YEAR(sale_date) = (SELECT MAX(YEAR(sale_date))-1 FROM sales)
GROUP BY st.store_name
ORDER BY total_units_sold DESC;



-- Count the number of unique products sold in the last year?
SELECT 
  COUNT(DISTINCT product_id) AS unique_products
FROM sales
WHERE YEAR(sale_date) = (SELECT MAX(YEAR(sale_date))-1 FROM sales);



-- What is the average price of products in each category?
SELECT 
  c.category_name,
  ROUND(AVG(p.price),1) AS avg_price
FROM products p
LEFT JOIN category c
  ON p.category_id = c.category_id
GROUP BY category_name
ORDER BY avg_price DESC;



-- How many warranty claims were filed in 2020?
SELECT 
  COUNT(claim_id) AS total_claims
FROM warranty
WHERE YEAR(claim_date) = 2020;



-- Identify each store and best selling day based on highest qty sold?
WITH demo AS (
          SELECT 
            store_id,
            DATE_FORMAT(sale_date, 'EEEE') AS sale_day,
            SUM(quantity) AS total_units_sold,
            RANK() OVER(PARTITION BY store_id ORDER BY SUM(quantity) DESC) AS rnk
          FROM sales
          GROUP BY store_id, sale_day
          ORDER BY store_id, total_units_sold DESC
)
SELECT 
  s.store_name,
  d.sale_day AS highest_sale_day,
  d.total_units_sold
FROM demo d
LEFT JOIN stores s
  ON d.store_id = s.store_id
WHERE rnk = 1;



-- Identify least selling product of each country for each year based on total unit sold

WITH demo AS (
            SELECT 
                YEAR(sale_date) AS year,
                st.country,
                p.product_name,
                SUM(quantity) AS total_units_sold,
                RANK() OVER(PARTITION BY YEAR(sale_date), st.country ORDER BY SUM(quantity) ASC) AS rnk
            FROM sales sl
            LEFT JOIN stores st
              ON sl.store_id = st.store_id
            LEFT JOIN products p 
              ON sl.product_id = p.product_id
            GROUP BY year, country, product_name
            ORDER BY year, country, total_units_sold ASC
)
SELECT year,
       country,
       product_name,
       total_units_sold
FROM demo
WHERE rnk = 1;



-- How many warranty claims were filed within 180 days of a product sale?
SELECT
  COUNT(claim_id) AS total_claims_within_180_days
FROM sales s
LEFT JOIN warranty w
  ON s.sale_id = w.sale_id
WHERE claim_id IS NOT NULL AND DATEDIFF(DAY, s.sale_date,  w.claim_date) <= 180;



-- How many warranty claims have been filed for products launched in the last two years?
SELECT
  p.product_name,
  COUNT(claim_id) AS total_claims
FROM sales s
LEFT JOIN products p
  ON s.product_id = p.product_id
LEFT JOIN warranty w
  ON s.sale_id = w.sale_id
WHERE YEAR(launch_date) >= (SELECT (MAX(YEAR(launch_date)) - 2) FROM products) AND claim_id IS NOT NULL
GROUP BY product_name
ORDER BY total_claims DESC;



-- List the months in the last 3 years where sales exceeded 5000 units from USA?
SELECT
  date_format(s.sale_date, 'yyyy-MM') AS month_year,
  SUM(s.quantity) AS total_units_sold
FROM sales s
LEFT JOIN products p
  ON s.product_id = p.product_id
LEFT JOIN stores st
  ON s.store_id = st.store_id
WHERE YEAR(s.sale_date) >= (SELECT MAX(YEAR(sale_date)) - 3 FROM sales) AND UPPER(st.country) = 'USA'
GROUP BY month_year
HAVING total_units_sold > 5000
ORDER BY month_year;



-- Which product category had the most warranty claims filed in the last 2 years?
SELECT 
  c.category_name,
  COUNT(w.claim_id) AS total_claims
FROM sales s
LEFT JOIN warranty w
  ON s.sale_id = w.sale_id
LEFT JOIN products p
  ON s.product_id = p.product_id
LEFT JOIN category c
  ON p.category_id = c.category_id
WHERE YEAR(w.claim_date) >= (SELECT MAX(YEAR(claim_date)) - 2 FROM warranty)
GROUP BY c.category_name
ORDER BY total_claims DESC;



-- Determine the percentage chance of receiving claims after each purchase for each country.
SELECT 
  st.country,
  COUNT(sl.quantity) AS total_quantity,
  COUNT(w.claim_id) AS total_claims,
  ROUND((COUNT(w.claim_id) / COUNT(sl.quantity))*100, 2) AS claim_percentage
FROM sales sl
LEFT JOIN warranty w
 ON sl.sale_id = w.sale_id
LEFT JOIN stores st
  ON sl.store_id = st.store_id
GROUP BY st.country
ORDER BY claim_percentage DESC;



-- Analyze each stores year by year growth ratio
WITH demo AS (
              SELECT
                YEAR(sl.sale_date) AS year,
                st.store_name,
                SUM(sl.quantity * p.price) AS total_sales              
              FROM sales sl
              LEFT JOIN stores st
                ON sl.store_id = st.store_id
              LEFT JOIN products p
                ON sl.product_id = p.product_id
              GROUP BY YEAR(sl.sale_date), st.store_name
              ORDER BY YEAR(sl.sale_date), SUM(sl.quantity) DESC
              )
SELECT 
  *,
  LAG(total_sales) OVER (PARTITION BY store_name ORDER BY year) AS prev_year_sales,
  ROUND(((total_sales - prev_year_sales)/prev_year_sales)*100, 1) AS yoy_growth
  FROM demo;



  -- What is the correlation between product price and warranty claims for products sold in the last five years? (Segment based on diff price)
WITH demo AS (
              SELECT
                p.product_name,
                AVG(p.price) AS avg_price,
                COUNT(s.sale_id) AS total_sales,
                COUNT(w.claim_id) AS total_claims
              FROM sales s
              LEFT JOIN warranty w
                ON s.sale_id = w.sale_id
              LEFT JOIN products p
                ON s.product_id = p.product_id
              WHERE YEAR(s.sale_date) >= (SELECT MAX(YEAR(sale_date)) - 5 FROM sales)
              GROUP BY p.product_name
)
SELECT
  corr(avg_price, total_claims) AS correlation
FROM demo;



-- Identify the store with the highest percentage of "Paid Repaired" claims in relation to total claims filed.
SELECT 
  st.store_name,
  COUNT(CASE WHEN w.repair_status = 'Paid Repaired' THEN w.claim_id END) AS paid_repaired_claims,
  COUNT(w.claim_id) AS total_claims,
  ROUND(try_divide(paid_repaired_claims, total_claims) * 100, 2) AS paid_repaired_claim_pct
FROM sales sl
LEFT JOIN warranty w
 ON sl.sale_id = w.sale_id
LEFT JOIN stores st
  ON sl.store_id = st.store_id
GROUP BY st.store_name
ORDER BY paid_repaired_claim_pct DESC;



-- Write SQL query to calculate the monthly running total of sales for each store over the past four years and compare the trends across this period?
WITH demo AS (
              SELECT
                st.store_name,
                DATE_FORMAT(s.sale_date, 'yyyy-MM') AS month_year,
                SUM(p.price * s.quantity) AS total_sales
              FROM sales s
              LEFT JOIN products p
                ON s.product_id = p.product_id
              LEFT JOIN stores st
                ON s.store_id = st.store_id
              WHERE YEAR(s.sale_date) >= (SELECT MAX(YEAR(sale_date)) - 4 FROM sales)
              GROUP BY st.store_name, month_year
              ORDER BY st.store_name, month_year
)
SELECT
  *,
  SUM(total_sales) OVER(PARTITION BY store_name ORDER BY month_year) AS cumulative_sales
FROM demo;  



-- Write SQL query to calculate the monthly sales for each store over the past four years and compare the growth over previous month?
WITH demo AS (
              SELECT
                st.store_name,
                DATE_FORMAT(s.sale_date, 'yyyy-MM') AS month_year,
                SUM(p.price * s.quantity) AS total_sales
              FROM sales s
              LEFT JOIN products p
                ON s.product_id = p.product_id
              LEFT JOIN stores st
                ON s.store_id = st.store_id
              WHERE YEAR(s.sale_date) >= (SELECT MAX(YEAR(sale_date)) - 4 FROM sales)
              GROUP BY st.store_name, month_year
              ORDER BY st.store_name, month_year
)
SELECT
  *,
  LAG(total_sales) OVER(PARTITION BY store_name ORDER BY month_year) AS prev_sales,
  ROUND( ((total_sales - prev_sales) / prev_sales) * 100, 1 ) AS growth
FROM demo;



-- 20.Analyze sales trends of product over time, segmented into key time periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months?

SELECT
  p.product_name,
  CASE 
    WHEN DATEDIFF(s.sale_date, p.launch_date) <= 180 THEN 'Launch to 6 months'
    WHEN DATEDIFF(s.sale_date, p.launch_date) <= 360 THEN '6-12 months'
    WHEN DATEDIFF(s.sale_date, p.launch_date) <= 540 THEN '12-18 months'
    ELSE 'Beyond 18 months'
  END AS time_period,
  SUM(s.quantity * p.price) AS total_sales
FROM sales s
LEFT JOIN products p
  ON s.product_id = p.product_id
GROUP BY product_name, time_period
ORDER BY product_name, time_period;