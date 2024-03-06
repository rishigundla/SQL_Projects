CREATE database marketing;
use marketing;
--------------------
-- Create the table
CREATE TABLE sustainable_clothing (
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
category VARCHAR(50),
size VARCHAR(10),
price FLOAT
);
-- Insert data into the table
INSERT INTO sustainable_clothing (product_id, product_name, category, size, price)
VALUES
(1, 'Organic Cotton T-Shirt', 'Tops', 'S', 29.99),
(2, 'Recycled Denim Jeans', 'Bottoms', 'M', 79.99),
(3, 'Hemp Crop Top', 'Tops', 'L', 24.99),
(4, 'Bamboo Lounge Pants', 'Bottoms', 'XS', 49.99),
(5, 'Eco-Friendly Hoodie', 'Outerwear', 'XL', 59.99),
(6, 'Linen Button-Down Shirt', 'Tops', 'M', 39.99),
(7, 'Organic Cotton Dress', 'Dresses', 'S', 69.99),
(8, 'Sustainable Swim Shorts', 'Swimwear', 'L', 34.99),
(9, 'Recycled Polyester Jacket', 'Outerwear', 'XL', 89.99),
(10, 'Bamboo Yoga Leggings', 'Activewear', 'XS', 54.99),
(11, 'Hemp Overalls', 'Bottoms', 'M', 74.99),
(12, 'Organic Cotton Sweater', 'Tops', 'L', 49.99),
(13, 'Cork Sandals', 'Footwear', 'S', 39.99),
(14, 'Recycled Nylon Backpack', 'Accessories', 'One Size', 59.99),
(15, 'Organic Cotton Skirt', 'Bottoms', 'XS', 34.99),
(16, 'Hemp Baseball Cap', 'Accessories', 'One Size', 24.99),
(17, 'Upcycled Denim Jacket', 'Outerwear', 'M', 79.99),
(18, 'Linen Jumpsuit', 'Dresses', 'L', 69.99),
(19, 'Organic Cotton Socks', 'Accessories', 'M', 9.99),
(20, 'Bamboo Bathrobe', 'Loungewear', 'XL', 69.99);
-- Create the table
CREATE TABLE marketing_campaigns (
campaign_id INT PRIMARY KEY,
campaign_name VARCHAR(100),
product_id INT,
start_date DATE,
end_date DATE,
FOREIGN KEY (product_id) REFERENCES sustainable_clothing (product_id)
);
-- Insert data into the table
INSERT INTO marketing_campaigns (campaign_id, campaign_name, product_id, start_date, end_date)
VALUES
(1, 'Summer Sale', 2, '2023-06-01', '2023-06-30'),
(2, 'New Collection Launch', 10, '2023-07-15', '2023-08-15'),
(3, 'Super Save', 7, '2023-08-20', '2023-09-15');
-- Create the table
CREATE TABLE transactions (
transaction_id INT PRIMARY KEY,
product_id INT,
quantity INT,
purchase_date DATE,
FOREIGN KEY (product_id) REFERENCES sustainable_clothing (product_id)
);
-- Insert data into the table
INSERT INTO transactions (transaction_id, product_id, quantity, purchase_date)
VALUES
(1, 2, 2, '2023-06-02'),
(2, 14, 1, '2023-06-02'),
(3, 5, 2, '2023-06-05'),
(4, 2, 1, '2023-06-07'),
(5, 19, 2, '2023-06-10'),
(6, 2, 1, '2023-06-13'),
(7, 16, 1, '2023-06-13'),
(8, 10, 2, '2023-06-15'),
(9, 2, 1, '2023-06-18'),
(10, 4, 1, '2023-06-22'),
(11, 18, 2, '2023-06-26'),
(12, 2, 1, '2023-06-30'),
(13, 13, 1, '2023-06-30'),
(14, 4, 1, '2023-07-04'),
(15, 6, 2, '2023-07-08'),
(16, 15, 1, '2023-07-08'),
(17, 9, 2, '2023-07-12'),
(18, 20, 1, '2023-07-12'),
(19, 11, 1, '2023-07-16'),
(20, 10, 1, '2023-07-20'),
(21, 12, 2, '2023-07-24'),
(22, 5, 1, '2023-07-29'),
(23, 10, 1, '2023-07-29'),
(24, 10, 1, '2023-08-03'),
(25, 19, 2, '2023-08-08'),
(26, 3, 1, '2023-08-14'),
(27, 10, 1, '2023-08-14'),
(28, 16, 2, '2023-08-20'),
(29, 18, 1, '2023-08-27'),
(30, 12, 2, '2023-09-01'),
(31, 13, 1, '2023-09-05'),
(32, 7, 1, '2023-09-05'),
(33, 6, 1, '2023-09-10'),
(34, 15, 2, '2023-09-14'),
(35, 9, 1, '2023-09-14'),
(36, 11, 2, '2023-09-19'),
(37, 17, 1, '2023-09-23'),
(38, 2, 1, '2023-09-28'),
(39, 14, 1, '2023-09-28'),
(40, 5, 2, '2023-09-30'),
(41, 16, 1, '2023-10-01'),
(42, 12, 2, '2023-10-01'),
(43, 1, 1, '2023-10-01'),
(44, 7, 1, '2023-10-02'),
(45, 18, 2, '2023-10-03'),
(46, 12, 1, '2023-10-03'),
(47, 13, 1, '2023-10-04'),
(48, 4, 1, '2023-10-05'),
(49, 12, 2, '2023-10-05'),
(50, 7, 1, '2023-10-06'),
(51, 4, 2, '2023-10-08'),
(52, 8, 2, '2023-10-08'),
(53, 16, 1, '2023-10-09'),
(54, 19, 1, '2023-10-09'),
(55, 1, 1, '2023-10-10'),
(56, 18, 2, '2023-10-10'),
(57, 2, 1, '2023-10-10'),
(58, 15, 2, '2023-10-11'),
(59, 17, 2, '2023-10-13'),
(60, 13, 1, '2023-10-13'),
(61, 10, 2, '2023-10-13'),
(62, 9, 1, '2023-10-13'),
(63, 19, 2, '2023-10-13'),
(64, 20, 1, '2023-10-14');
--------------------

-- Questions

-- 1. How many transactions were completed during each marketing campaign?
SELECT
	m.campaign_id,
    m.campaign_name,
    COUNT(t.transaction_id) AS cnt_transaction
FROM marketing_campaigns m
JOIN transactions t
	ON m.product_id = t.product_id
WHERE t.purchase_date BETWEEN m.start_date AND m.end_date 
GROUP BY m.campaign_id, m.campaign_name;


-- 2. Which product had the highest sales quantity?
SELECT
	c.product_id,
    c.product_name,
    SUM(t.quantity) AS total_quantity
FROM sustainable_clothing c
JOIN transactions t
	ON c.product_id = t.product_id
GROUP BY c.product_id, c.product_name
ORDER BY SUM(t.quantity) DESC;


-- 3. What is the total revenue generated from each marketing campaign?
SELECT
	m.campaign_id,
    m.campaign_name,
    ROUND(SUM(t.quantity * c.price),2) AS total_rev
FROM marketing_campaigns m
JOIN transactions t
	ON m.product_id = t.product_id
JOIN sustainable_clothing c
	ON m.product_id = c.product_id
WHERE t.purchase_date BETWEEN m.start_date AND m.end_date 
GROUP BY m.campaign_id, m.campaign_name;


-- 4. What is the top-selling product category based on the total revenue generated?
SELECT
	c.category,
    ROUND(SUM(t.quantity * c.price),2) AS total_rev
FROM transactions t
JOIN sustainable_clothing c
	ON t.product_id = c.product_id
GROUP BY c.category
ORDER BY ROUND(SUM(t.quantity * c.price),2) DESC;


-- 5. Which products had a higher quantity sold compared to the average quantity sold?
SELECT
	c.product_name,
    SUM(t.quantity)
FROM transactions t
JOIN sustainable_clothing c
	ON t.product_id = c.product_id
GROUP BY c.product_name
HAVING SUM(t.quantity) > (SELECT AVG(quantity) FROM transactions);


-- 6. What is the average revenue generated per day during the marketing campaigns?
SELECT
	m.campaign_id,
    m.campaign_name,
    ROUND(SUM(t.quantity * c.price)/30,2) AS total_rev
FROM marketing_campaigns m
JOIN transactions t
	ON m.product_id = t.product_id
JOIN sustainable_clothing c
	ON m.product_id = c.product_id
WHERE t.purchase_date BETWEEN m.start_date AND m.end_date 
GROUP BY m.campaign_id, m.campaign_name;


-- 7. What is the percentage contribution of each product to the total revenue?
WITH cte1 AS (
SELECT
	c.product_id,
    c.product_name,
    ROUND(SUM(t.quantity * c.price),2) AS total_rev
FROM transactions t
JOIN sustainable_clothing c
	ON t.product_id = c.product_id
GROUP BY c.product_id, c.product_name),
cte2 AS (
SELECT
    ROUND(SUM(t.quantity * c.price),2) AS overall_rev
FROM transactions t
JOIN sustainable_clothing c
	ON t.product_id = c.product_id)
SELECT
	*,
    ROUND(((total_rev/overall_rev) * 100),2) AS pct_cont
FROM cte1 
CROSS JOIN cte2;


-- 8. Compare the average quantity sold during marketing campaigns to outside the marketing campaigns
SELECT
	m.product_id,
    c.product_name,
	ROUND(AVG(CASE WHEN t.purchase_date BETWEEN m.start_date AND m.end_date THEN quantity END),2) AS marketing_quantity,
    ROUND(AVG(CASE WHEN t.purchase_date NOT BETWEEN m.start_date AND m.end_date THEN quantity END),2) AS non_marketing_quantity
FROM marketing_campaigns m
JOIN transactions t
	ON m.product_id = t.product_id
JOIN sustainable_clothing c
	ON m.product_id = c.product_id
GROUP BY m.product_id, c.product_name;


-- 9. Compare the revenue generated by products inside the marketing campaigns to outside the campaigns
SELECT
	m.product_id,
    c.product_name,
	ROUND(SUM(CASE WHEN t.purchase_date BETWEEN m.start_date AND m.end_date THEN quantity*price END),2) AS marketing_rev,
    ROUND(SUM(CASE WHEN t.purchase_date NOT BETWEEN m.start_date AND m.end_date THEN quantity*price END),2) AS non_marketing_rev
FROM marketing_campaigns m
JOIN transactions t
	ON m.product_id = t.product_id
JOIN sustainable_clothing c
	ON m.product_id = c.product_id
GROUP BY m.product_id, c.product_name;


-- 10. Rank the products by their average daily quantity sold
SELECT
    c.product_name,
    ROUND(AVG(t.quantity),2),
    DENSE_RANK() OVER(ORDER BY AVG(t.quantity) DESC) AS rankk
FROM transactions t
JOIN sustainable_clothing c
	ON t.product_id = c.product_id
GROUP BY c.product_name;
