-- View the order_details table. What is the date range of the table?

SELECT 
	MIN(order_date) AS start_date,
    MAX(order_date) AS end_date
FROM order_details;

-- How many orders were made within this date range? How many items were ordered within this date range?
SELECT 
	COUNT(*) AS total_orders,
    COUNT(item_id) AS total_items_placed
FROM order_details
WHERE order_date >= (SELECT MIN(order_date) from order_details)
	AND order_date <= (SELECT MAX(order_date) from order_details);

-- Which orders had the most number of items?

WITH tc AS(
SELECT 
	order_id,
	COUNT(item_id) AS items_totals
FROM order_details
GROUP BY order_id
),
max_order AS(
	SELECT
		MAX(items_totals) AS max_order
	FROM tc
)
SELECT
	t.order_id,
    t.items_totals,
    m.max_order
FROM tc t
CROSS JOIN max_order m
WHERE t.items_totals = m.max_order;

-- How many orders had more than 12 items?
SELECT
	COUNT(*) AS ordered_count
FROM(
SELECT
	order_id,
    COUNT(item_id) AS total_items
FROM order_details
GROUP BY order_id
HAVING COUNT(item_id) > 12) as TF;
