Zepto Dataset Analysis Using PostgreSQL
Project Overview

This project performs a comprehensive data analysis on a dataset of Zepto products using PostgreSQL. The analysis includes data cleaning, exploration, and business insights, such as best-value products, stock status, revenue estimation, discount analysis, and inventory planning.

The project demonstrates how SQL can be leveraged for data-driven decision making in e-commerce.

Zepto Data Analysis Project
Database Schema
Table Definition

SQL

CREATE TABLE zepto (
    sku_id SERIAL PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountedSellingPrice NUMERIC(8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);
Data Exploration
Count of Rows

SQL

SELECT count(*) FROM zepto;
Sample Data

SQL

SELECT * FROM zepto
LIMIT 10;
Check for Null Values

SQL

SELECT * FROM zepto
WHERE name IS NULL
OR category IS NULL
OR mrp IS NULL
OR discountPercent IS NULL
OR discountedSellingPrice IS NULL
OR weightInGms IS NULL
OR availableQuantity IS NULL
OR outOfStock IS NULL
OR quantity IS NULL;
Distinct Product Categories

SQL

SELECT DISTINCT category
FROM zepto
ORDER BY category;
Products In Stock vs. Out of Stock

SQL

SELECT outOfStock, COUNT(sku_id)
FROM zepto
GROUP BY outOfStock;
Product Names Present Multiple Times

SQL

SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;
Data Cleaning
Delete Products with Zero Price

SQL

DELETE FROM zepto
WHERE mrp = 0;
Convert Paise to Rupees

SQL

UPDATE zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;
Data Analysis
Q1. Find the top 10 best-value products based on the discount percentage.

SQL

SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;
Q2. What are the Products with High MRP but Out of Stock?

SQL

SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE AND mrp > 300
ORDER BY mrp DESC;
Q3. Calculate Estimated Revenue for each category.

SQL

SELECT category,
    SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;
Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.

SQL

SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;
Q5. Identify the top 5 categories offering the highest average discount percentage.

SQL

SELECT category,
    ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;
Q6. Find the price per gram for products above 100g and sort by best value.

SQL

SELECT DISTINCT name, weightInGms, discountedSellingPrice,
    ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;
Q7. Group the products into categories like Low, Medium, Bulk.

SQL

SELECT DISTINCT name, weightInGms,
    CASE WHEN weightInGms < 1000 THEN 'Low'
         WHEN weightInGms < 5000 THEN 'Medium'
         ELSE 'Bulk'
    END AS weight_category
FROM zepto;
Q8. What is the Total Inventory Weight Per Category?

SQL

SELECT category,
    SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;
