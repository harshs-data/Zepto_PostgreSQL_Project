# Zepto Data Analysis Project

## Project Overview
This project involves performing data analysis on a sample Zepto e-commerce dataset using **PostgreSQL**. The goal is to extract meaningful insights about products, discounts, stock, and revenue patterns. This analysis is useful both for **business decision-making** and understanding **customer value trends**.

<img src="https://github.com/harshs-data/Zepto_PostgreSQL_Project/blob/main/zepto_data_analysis.png" alt="Zepto Data Analysis" width="500"/>

## Dataset Description
The dataset consists of product information with the following columns:

- `sku_id` : Unique identifier for each product
- `Category` : Product category (e.g., Beverages, Snacks)
- `name` : Product name
- `mrp` : Maximum Retail Price (in paise, later converted to rupees)
- `discountPercent` : Discount percentage on the product
- `availableQuantity` : Number of items available in stock
- `discountedSellingPrice` : Price after discount (in paise, later converted to rupees)
- `weightInGms` : Weight of the product in grams
- `outOfStock` : Boolean indicating if product is out of stock
- `quantity` : Number of items sold (used for revenue calculation)

## Tools and Technologies
- **Database**: PostgreSQL
- **Querying**: SQL (including JOINs, Aggregations, Window Functions, CASE statements)
- **Environment**: pgAdmin / psql command-line

## Database Setup
```sql
DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto(
    sku_id SERIAL PRIMARY KEY, 
    Category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp NUMERIC(8,2),
    discountPercent NUMERIC(5,2),
    availableQuantity INTEGER,
    discountedSellingPrice NUMERIC(8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);
```

## Data Exploration
```sql
-- Count of rows
SELECT COUNT(*) FROM zepto;

-- Sample data
SELECT * FROM zepto LIMIT 10;

-- Check for null values
SELECT * FROM zepto
WHERE name IS NULL OR category IS NULL OR mrp IS NULL
   OR discountpercent IS NULL OR availablequantity IS NULL
   OR discountedsellingprice IS NULL OR weightingms IS NULL
   OR outofstock IS NULL OR quantity IS NULL;

-- Distinct product categories
SELECT DISTINCT category FROM zepto ORDER BY category;

-- Products in stock vs out of stock
SELECT outofstock, COUNT(sku_id) FROM zepto GROUP BY outofstock;

-- Products appearing multiple times
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;
```

## Data Cleaning
```sql
-- Delete products with MRP = 0
DELETE FROM zepto WHERE mrp = 0;

-- Convert prices from paise to rupees
UPDATE zepto
SET mrp = mrp / 100.0,
    discountedsellingprice = discountedsellingprice / 100.0;
```

## Business Insight Queries
### 1. Top 10 Best-Value Products (Highest Discounts)
``` sql
SELECT DISTINCT name, mrp, discountpercent
FROM zepto 
ORDER BY discountpercent DESC
LIMIT 10;
```
**Helps customers find bargains and businesses understand which products are heavily promoted.**

## 2. High MRP Products Out of Stock
``` sql
SELECT DISTINCT name, mrp, category, outofstock
FROM zepto
WHERE mrp > 300 AND outofstock = TRUE
ORDER BY mrp DESC;
```
**Shows products that may need restocking due to high demand.**

## 3. Estimated Revenue per Category
``` sql
SELECT category, SUM(discountedsellingprice * quantity) AS estimated_revenue
FROM zepto
GROUP BY category
ORDER BY estimated_revenue DESC;
```
**Shows products that may need restocking due to high demand.**

## 4. High MRP & Low Discount Products
``` sql
SELECT DISTINCT name, category, mrp, discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;
```
**Indicates popular products that sell well even with low discounts.**

## 5. Top 5 Categories with Highest Average Discounts
``` sql
SELECT category, ROUND(AVG(discountpercent),2) AS avg_discountpercent
FROM zepto
GROUP BY category
ORDER BY avg_discountpercent DESC
LIMIT 5;
```
**Helps identify categories with the largest price cuts.**

## 6. Price per Gram for Products Above 100g
``` sql
SELECT DISTINCT name, weightingms, discountedsellingprice,
ROUND(discountedsellingprice/weightingms,2) AS price_per_gram
FROM zepto
WHERE weightingms > 100
ORDER BY price_per_gram;
```
**Shows best value products for bulk buyers.**

## 7. Categorize Products by Weight
``` sql
SELECT DISTINCT name, weightingms,
CASE 
    WHEN weightingms < 1000 THEN 'Low'
    WHEN weightingms > 5000 THEN 'Medium'
    ELSE 'High'
END AS weight_category
FROM zepto;
```
**Useful for inventory and packaging management.**

## 8. Total Inventory Weight per Category
``` sql
SELECT category, SUM(weightingms * availablequantity) AS total_weight
FROM zepto 
GROUP BY category
ORDER BY total_weight;
```
**Helps in warehouse planning and handling bulky product categories.**

## Conclusion
Through this Zepto Data Analysis project, we successfully explored, cleaned, and analyzed a sample e-commerce dataset using PostgreSQL. Key takeaways include:

- Identification of best-value products and high-demand items for better pricing and inventory decisions.
- Insights into revenue distribution across categories, enabling strategic business planning.
- Understanding discount patterns and product popularity to optimize marketing and sales strategies.
- Categorization of products by weight and calculation of inventory metrics to support warehouse management.

Overall, this project demonstrates how SQL-based analysis can provide actionable insights for e-commerce businesses, helping improve decision-making, operational efficiency, and customer satisfaction.


