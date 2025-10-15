# Zepto Data Analysis Project

## Project Overview
This project involves performing data analysis on a sample Zepto e-commerce dataset using **PostgreSQL**. The goal is to extract meaningful insights about products, discounts, stock, and revenue patterns. This analysis is useful both for **business decision-making** and understanding **customer value trends**.

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

