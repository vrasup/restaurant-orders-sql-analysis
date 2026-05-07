-- View the menu_items table and write a query to find the number of items on the menu
SELECT 
	COUNT(DISTINCT item_name) AS no_of_items
FROM menu_items;

-- What are the least and most expensive items on the menu?
SELECT
	item_name,
    price,
    'cheapest' AS category
FROM menu_items
WHERE price = (SELECT MIN(price) FROM menu_items)
UNION ALL
SELECT 
	item_name,
    price,
    'Most Expensive' AS category
FROM menu_items
WHERE price = (SELECT MAX(price) FROM menu_items AS category);

-- How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
-- COUNT OF ITALIAN DISH
SELECT
	COUNT(*) AS total_Italian_dish
FROM menu_items
WHERE category = 'Italian';

-- LOWEST AND HIGHEST ITALIAN MENU
SELECT
	item_name,
    price,
    category,
    'Lowest Price' AS price_category
FROM menu_items
WHERE category = 'Italian'
		AND price = (SELECT MIN(price) FROM menu_items WHERE category = 'Italian')
UNION ALL
SELECT
	item_name,
    price,
    category,
    'Highest Price' AS price_category
FROM menu_items
WHERE category = 'Italian'
		AND price = (SELECT MAX(price) FROM menu_items WHERE category = 'Italian');

-- How many dishes are in each category? What is the average dish price within each category?
SELECT 
	category,
    COUNT(menu_item_id) AS total_dishes,
    ROUND(AVG(price),2) AS avg_dish_price
FROM menu_items
GROUP BY category;
    







