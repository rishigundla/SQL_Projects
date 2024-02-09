-- Create database
CREATE DATABASE IF NOT EXISTS walmart;

-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);


-- Add time_of_day column
SELECT
	time,
    (CASE 
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN time BETWEEN "12:01:00" AND "17:00:00" THEN "Afternoon"
		ELSE "Evening"
	END
	) AS time_of_date
FROM sales;

 
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);


UPDATE sales
SET time_of_day =  
(CASE 
	WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN time BETWEEN "12:01:00" AND "17:00:00" THEN "Afternoon"
	ELSE "Evening"
END);

-- Add day_name column
SELECT
	date,
    DAYNAME(date) AS day_name
FROM sales;


ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);


UPDATE sales
SET day_name = DAYNAME(date);

-- Add month_name column
SELECT
	date,
    MONTHNAME(date) AS month_name
FROM sales;


ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);


UPDATE sales
SET month_name = MONTHNAME(date);

/*---------------------------Generic Questions-------------------------------*/

-- 1. How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM sales;


-- 2. In which city is each branch?
SELECT
	DISTINCT city,
    branch
FROM sales;

/*---------------------------Product-------------------------------*/

-- 1. How many unique product lines does the data have?
SELECT
	DISTINCT product_line
FROM sales;


-- 2. What is the most common payment method?
SELECT
	payment,
	COUNT(payment) AS payment_cnt
FROM sales
GROUP BY payment
ORDER BY payment_cnt DESC;


-- 3. What is the most selling product line?
SELECT 
	product_line,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY product_line
ORDER BY total_quantity DESC;


-- 4. What is the total revenue by month?
SELECT 
	month_name,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;


-- 5. What month had the largest COGS? 
SELECT 
	month_name,
    SUM(cogs) AS total_cogs
FROM sales
GROUP BY month_name
ORDER BY total_cogs DESC;


-- 6. What product line had the largest revenue?
SELECT 
	product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;


-- 7. What is the city with the largest revenue?
SELECT 
	city,
    SUM(total) AS total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;


-- 8. What product line had the largest VAT?
SELECT 
	product_line,
    AVG(tax_pct) AS avg
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;


-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT
	product_line,
    AVG(quantity) as avg_quantity,
    (CASE WHEN AVG(quantity) > (SELECT AVG(quantity) AS avg_quantity FROM sales) THEN "Good"
    ELSE "Bad"
    END) AS category
FROM sales
GROUP BY product_line;


-- 10. Which branch sold more products than average product sold?
SELECT 
	branch,
    AVG(quantity) AS avg_quantity
FROM sales
GROUP BY branch
HAVING avg_quantity >= (SELECT AVG(quantity) FROM sales);


-- 11. What is the most common product line by gender
SELECT
	product_line,
    SUM(CASE WHEN gender = "Male" THEN 1 ELSE 0 END) AS Male,
    SUM(CASE WHEN gender = "Female" THEN 1 ELSE 0 END) AS Female
FROM sales
GROUP BY product_line;


-- 12. What is the average rating of each product line?
SELECT
	product_line,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


/*-----------------------------Sales---------------------------------*/

-- 1. Number of sales made in each time of the day per weekday?
SELECT
	day_name,
    SUM(CASE WHEN time_of_day = "Morning" THEN 1 ELSE 0 END) AS Morning,
    SUM(CASE WHEN time_of_day = "Afternoon" THEN 1 ELSE 0 END) AS Afternoon,
    SUM(CASE WHEN time_of_day = "Evening" THEN 1 ELSE 0 END) AS Evening
FROM sales
GROUP BY day_name;


-- 2. Which of the customer types brings the % of revenue?
SELECT 
	customer_type,
    (SUM(total) / (SELECT SUM(total) FROM sales))*100 AS pct_revenue
FROM sales
GROUP BY customer_type;


-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
	city,
    AVG(tax_pct) AS avg_tax
FROM sales
GROUP BY city
ORDER BY avg_tax DESC;


-- 4. Which customer type pays the most in VAT?
SELECT 
	customer_type,
    SUM(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;


/*-----------------------------Customer---------------------------------*/

-- 1. What is the most common customer type?
SELECT 
	customer_type,
    COUNT(*) as cnt_customer
FROM sales
GROUP BY customer_type
ORDER BY cnt_customer DESC;

-- 2. Which customer type buys the most?
SELECT 
	customer_type,
    SUM(quantity) as total_quantity
FROM sales
GROUP BY customer_type
ORDER BY total_quantity DESC;


-- 3. Which Customer type has most of the customers by gender?
SELECT
	customer_type,
    SUM(CASE WHEN gender = "Male" THEN 1 ELSE 0 END) AS Male,
    SUM(CASE WHEN gender = "Female" THEN 1 ELSE 0 END) AS Female
FROM sales
GROUP BY customer_type;


-- 4. What is the gender distribution per branch?
SELECT
	branch,
    (SUM(CASE WHEN gender = "Male" THEN 1 ELSE 0 END) / COUNT(*)) * 100  AS Male,
    (SUM(CASE WHEN gender = "Female" THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS Female
FROM sales
GROUP BY branch
ORDER BY branch;


-- 5. Which time of the day do customers give most ratings?
SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- 6. Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
    AVG(CASE WHEN branch = "A" THEN rating END) AS "A",
    AVG(CASE WHEN branch = "B" THEN rating END) AS "B",
    AVG(CASE WHEN branch = "C" THEN rating END) AS "C"
FROM sales
GROUP BY time_of_day;


-- 7. Which day fo the week has the best avg ratings?
SELECT
	day_name,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;    


-- 8. Which day of the week has the best average ratings per branch?
SELECT
	day_name,
    AVG(CASE WHEN branch = "A" THEN rating END) AS "A",
    AVG(CASE WHEN branch = "B" THEN rating END) AS "B",
    AVG(CASE WHEN branch = "C" THEN rating END) AS "C"
FROM sales
GROUP BY day_name;
