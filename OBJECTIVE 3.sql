-- Combine the menu_items and order_details tables into a single table
SELECT 
	m.menu_item_id,
    m.item_name,
    m.category,
    m.price,
    o.order_details_id,
    o.order_id,
    o.order_date,
    o.order_time
FROM menu_items m 
JOIN order_details o
	ON m.menu_item_id = o.item_id
LIMIT 5;

-- What were the least and most ordered items? What categories were they in?
WITH base AS(
SELECT
	m.item_name,
    m.category,
    COUNT(item_id) AS order_count
FROM menu_items m
JOIN order_details o
	ON m.menu_item_id = o.item_id
GROUP BY m.category, m.item_name
),
ranked AS(
SELECT
	item_name,
    category,
    order_count,
	DENSE_RANK() OVER( ORDER BY order_count ASC) AS min_ranked,
    DENSE_RANK() OVER( ORDER BY order_count DESC) AS max_ranked
FROM base
)
SELECT
	item_name,
    category,
    order_Count,
    CASE WHEN min_ranked = 1 THEN 'Least Order'
		WHEN max_ranked = 1 THEN 'Most Order' 
    END AS order_Category
FROM ranked
WHERE min_ranked = 1
OR max_ranked = 1;

-- What were the top 5 orders that spent the most money?
SELECT
	o.order_id,
    SUM(m.price) AS total_spent
FROM menu_items m
JOIN order_details o
	ON m.menu_item_id = o.item_id
GROUP BY o.order_id
ORDER BY total_spent DESC
limit 5;

-- View the details of the highest spend order. Which specific items were purchased?
WITH order_totals AS (
SELECT
	o.order_id,
	SUM(m.price) AS total_spent
FROM menu_items m
JOIN order_details o
	ON m.menu_item_id = o.item_id
GROUP BY o.order_id
),
top_order as(
SELECT 
	order_id,
    total_spent
FROM order_totals
ORDER BY total_spent DESC
LIMIT 1
)
SELECT
	t.order_id,
    m.item_name,
    t.total_spent
FROM top_order t
JOIN order_details o1
	ON t.order_id = o1.order_id
JOIN menu_items m
	ON o1.item_id = m.menu_item_id;
    
-- BONUS: View the details of the top 5 highest spend orders
SELECT
	o.order_id,
    SUM(m.price) AS total_spent
FROM menu_items m
JOIN order_details o
	ON m.menu_item_id  = o.item_id
GROUP BY o.order_id
ORDER BY total_spent DESC
LIMIT 5;
    
