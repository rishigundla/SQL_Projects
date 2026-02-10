-- Count the Cities & States of customers who ordered during the given period.

SELECT
  YEAR(order_purchase_timestamp) AS order_year,
  COUNT(DISTINCT customer_city) AS unique_cities,
  COUNT(DISTINCT customer_state) AS unique_states
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY order_year
ORDER BY order_year;

-- Can we see some kind of monthly seasonality in terms of the no. of orders being placed?

SELECT 
  DATE_FORMAT(order_purchase_timestamp, 'yyyy-MM') AS order_year_month,
  COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_year_month
ORDER BY order_year_month DESC;

-- During what time of the day, do the Brazilian customers mostly place their orders? (Dawn, Morning, Afternoon or Night)
-- 0-6 hrs : Dawn
-- 7-12 hrs : Morning
-- 13-18 hrs : Afternoon
-- 19-23 hrs : Night

SELECT
  CASE
    WHEN HOUR(order_purchase_timestamp) BETWEEN 0 AND 6 THEN 'Dawn'
    WHEN HOUR(order_purchase_timestamp) BETWEEN 7 AND 12 THEN 'Morning'
    WHEN HOUR(order_purchase_timestamp) BETWEEN 13 AND 18 THEN 'Afternoon'
    WHEN HOUR(order_purchase_timestamp) BETWEEN 19 AND 23 THEN 'Night'
  END AS time_of_day,
  COUNT(order_id) AS total_orders
FROM orders
GROUP BY time_of_day
ORDER BY total_orders DESC;


-- How are the customers distributed across all the states?

SELECT 
  customer_state,
  COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;



-- Get the % increase in the cost of orders from year 2017 to 2018 (include months between Jan to Aug only). 
-- You can use the "payment_value" column in the payments table to get the cost of orders.

WITH yearly_total AS (
                    SELECT 
                      DATE_FORMAT(o.order_purchase_timestamp, 'yyyy') AS order_year,
                      ROUND(SUM(p.payment_value),1) AS total_payment
                    FROM orders o
                    JOIN payments p
                    ON o.order_id = p.order_id
                    WHERE YEAR(o.order_purchase_timestamp) IN ('2017','2018') AND MONTH(o.order_purchase_timestamp) BETWEEN 1 AND 8
                    GROUP BY order_year)
SELECT
  order_year,
  total_payment,
  LEAD(total_payment) OVER (ORDER BY order_year DESC) AS previous_year_payment,
  ROUND(((total_payment - previous_year_payment)/previous_year_payment)*100,2) AS pct_increase
FROM yearly_total;


-- Calculate the Total & Average value of order price for each state.
-- Calculate the Total & Average value of order freight for each state.

SELECT
  c.customer_state,
  ROUND(SUM(i.freight_value),1) AS total_freight,
  ROUND(AVG(i.freight_value),1) AS avg_freight,
  ROUND(SUM(i.price),1) AS total_price,
  ROUND(AVG(i.price),1) AS avg_price
FROM 
customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items i
ON o.order_id = i.order_id
GROUP BY c.customer_state;


-- Find the no. of days taken to deliver each order from the order’s purchase date as delivery time. 
-- Also, calculate the difference (in days) between the estimated & actual delivery date of an order. 
-- Do this in a single query. You can calculate the delivery time and the difference between the estimated & actual delivery date using the given formula:
-- time_to_deliver = order_delivered_customer_date - order_purchase_timestamp
-- diff_estimated_delivery = order_delivered_customer_date - order_estimated_delivery_date

SELECT 
  *,
  DATE_DIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) AS time_to_deliver,
  DATE_DIFF(DAY, order_estimated_delivery_date, order_delivered_customer_date) AS diff_estimated_delivery
FROM orders
WHERE order_status = 'delivered';


-- Find out the top 5 states with the highest average freight value.

WITH 
top_states AS (
                    SELECT
                      c.customer_state,
                      ROUND(AVG(i.freight_value),1) AS avg_freight
                    FROM 
                    customers c
                    JOIN orders o
                    ON c.customer_id = o.customer_id
                    JOIN order_items i
                    ON o.order_id = i.order_id
                    GROUP BY c.customer_state
                    ORDER BY avg_freight DESC),
top_states_rnk AS (
                  SELECT 
                    *,
                    RANK() OVER (ORDER BY avg_freight DESC) AS rank_avg_freight
                  FROM top_states)
SELECT 
  customer_state,
  avg_freight
FROM top_states_rnk
WHERE rank_avg_freight <= 5;


-- Find out the top 5 states with the highest average delivery time.

WITH top_states AS (
                    SELECT 
                      c.customer_state,
                      ROUND(AVG(DATE_DIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date)),1) AS avg_time_to_deliver
                    FROM orders o
                    JOIN customers c
                    ON o.customer_id = c.customer_id
                    WHERE order_status = 'delivered'
                    GROUP BY c.customer_state
                    ORDER BY avg_time_to_deliver DESC),
top_states_rnk AS (
                    SELECT
                    *,
                    RANK() OVER (ORDER BY avg_time_to_deliver DESC) AS rank_avg_time_to_deliver
                    FROM top_states)
SELECT 
    customer_state,
    avg_time_to_deliver
FROM top_states_rnk
WHERE rank_avg_time_to_deliver <= 5;


-- Find the month on month no. of orders placed using different payment types.

SELECT 
  DATE_FORMAT(o.order_purchase_timestamp, 'yyyy-MM') AS year_month,
  p.payment_type,
  COUNT(DISTINCT o.order_id) AS no_of_orders
FROM orders o
JOIN payments p
ON o.order_id = p.order_id
GROUP BY year_month, payment_type
ORDER BY year_month DESC;


-- Find the no. of orders placed on the basis of the payment installments that have been paid.

SELECT 
  p.payment_installments,
  COUNT(DISTINCT o.order_id) AS no_of_orders
FROM orders o
JOIN payments p
ON o.order_id = p.order_id
GROUP BY payment_installments
ORDER BY payment_installments;



