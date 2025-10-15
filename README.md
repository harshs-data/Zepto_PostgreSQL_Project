Zepto Dataset Analysis Using PostgreSQL
Project Overview

This project performs a comprehensive data analysis on a dataset of Zepto products using PostgreSQL. The analysis includes data cleaning, exploration, and business insights, such as best-value products, stock status, revenue estimation, discount analysis, and inventory planning.

The project demonstrates how SQL can be leveraged for data-driven decision making in e-commerce.

Table of Contents

Project Overview

Setup Instructions

Database Schema

Data Exploration Queries

Data Cleaning Queries

Business Insight Queries

Insights

Setup Instructions

Install PostgreSQL on your machine.

Create a new database:

CREATE DATABASE zepto_db;


Connect to the database:

\c zepto_db


Run the SQL script zepto_analysis.sql containing all table creation, data exploration, cleaning, and analysis queries.

Database Schema

Table: zepto

Column Name	Data Type	Description
sku_id	SERIAL	Primary Key
Category	VARCHAR(120)	Product Category
name	VARCHAR(150)	Product Name
mrp	NUMERIC(8,2)	Maximum Retail Price (in ₹)
discountPercent	NUMERIC(5,2)	Discount percentage offered
availableQuantity	INTEGER	Quantity available in stock
discountedSellingPrice	NUMERIC(8,2)	Selling price after discount (in ₹)
weightInGms	INTEGER	Weight of the product in grams
outOfStock	BOOLEAN	Stock availability
quantity	INTEGER	Number of units sold
Data Exploration Queries
-- Count of rows
SELECT COUNT(*) FROM zepto;

-- Sample data
SELECT * FROM zepto LIMIT 10;

-- Null values check
SELECT * FROM zepto
WHERE name IS NULL OR category IS NULL OR mrp IS NULL
      OR discountpercent IS NULL OR availablequantity IS NULL
      OR discountedsellingprice IS NULL OR weightingms IS NULL
      OR outofstock IS NULL OR quantity IS NULL;

-- Distinct product categories
SELECT DISTINCT category FROM zepto ORDER BY category;

-- Products in stock vs out of stock
SELECT outofstock, COUNT(sku_id)
FROM zepto 
GROUP BY outofstock;

-- Duplicate product names
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;

Data Cleaning Queries
-- Delete products with price = 0
DELETE FROM zepto WHERE mrp = 0;

-- Convert paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
    discountedsellingprice = discountedsellingprice / 100.0;

SELECT mrp, discountedsellingprice FROM zepto;

Business Insight Queries
1. Top 10 Best-Value Products
SELECT DISTINCT name, mrp, discountpercent
FROM zepto
ORDER BY discountpercent DESC
LIMIT 10;


Insight: Helps customers find bargains and businesses identify heavily promoted products.

2. High MRP but Out of Stock
SELECT DISTINCT name, mrp, category, outofstock
FROM zepto
WHERE mrp > 300 AND outofstock = TRUE
ORDER BY mrp DESC;


Insight: Products that need urgent restocking due to high demand.

3. Estimated Revenue per Category
SELECT category, SUM(discountedsellingprice * quantity) AS estimated_revenue
FROM zepto
GROUP BY category
ORDER BY estimated_revenue DESC;


Insight: Shows which categories generate the most revenue.

4. High-Priced Products with Low Discount
SELECT DISTINCT name, category, mrp, discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;


Insight: These are popular products with limited discounts.

5. Top 5 Categories by Average Discount
SELECT category, ROUND(AVG(discountpercent),2) AS avg_discountpercent
FROM zepto
GROUP BY category
ORDER BY avg_discountpercent DESC
LIMIT 5;


Insight: Identifies categories where discounts are highest.

6. Price per Gram for Products above 100g
SELECT DISTINCT name, weightingms, discountedsellingprice,
ROUND(discountedsellingprice / weightingms, 2) AS price_per_gram
FROM zepto
WHERE weightingms > 100
ORDER BY price_per_gram;


Insight: Helps customers and businesses assess value per gram.

7. Group Products by Weight Category
SELECT DISTINCT name, weightingms,
CASE 
    WHEN weightingms < 1000 THEN 'Low'
    WHEN weightingms > 5000 THEN 'Medium'
    ELSE 'High'
END AS weight_category
FROM zepto;


Count of Products per Weight Category:

SELECT 
CASE 
    WHEN weightingms < 1000 THEN 'Low'
    WHEN weightingms > 5000 THEN 'Medium'
    ELSE 'High'
END AS weight_category,
COUNT(*) AS count_products
FROM zepto
GROUP BY weight_category;


Insight: Helps in packaging and inventory planning.

8. Total Inventory Weight per Category
SELECT category, SUM(weightingms * availablequantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;


Insight: Useful for warehouse storage and identifying bulky product categories.

Conclusion & Insights

SQL provides powerful data exploration, cleaning, and business insights capabilities.

Businesses can optimize inventory, discounts, and revenue strategies based on this analysis.

Customers benefit from insights like best-value products and popular items.
