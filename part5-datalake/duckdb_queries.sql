-- Q1: List all customers along with the total number of orders they have placed
SELECT 
    c.customer_name, 
    COUNT(o.order_id) AS total_orders
FROM 'customers.csv' c
LEFT JOIN 'orders.json' o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

-- Q2: Find the top 3 customers by total order value
SELECT 
    c.customer_name, 
    SUM(p.unit_price * o.quantity) AS total_order_value
FROM 'customers.csv' c
JOIN 'orders.json' o ON c.customer_id = o.customer_id
JOIN 'products.parquet' p ON o.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_order_value DESC
LIMIT 3;

-- Q3: List all products purchased by customers from Bangalore
SELECT DISTINCT 
    p.product_name
FROM 'products.parquet' p
JOIN 'orders.json' o ON p.product_id = o.product_id
JOIN 'customers.csv' c ON o.customer_id = c.customer_id
WHERE c.customer_city = 'Bangalore';

-- Q4: Join all three files to show: customer name, order date, product name, and quantity
SELECT 
    c.customer_name, 
    o.order_date, 
    p.product_name, 
    o.quantity
FROM 'orders.json' o
JOIN 'customers.csv' c ON o.customer_id = c.customer_id
JOIN 'products.parquet' p ON o.product_id = p.product_id;
