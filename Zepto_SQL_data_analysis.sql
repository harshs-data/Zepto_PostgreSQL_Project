drop table if exists zepto;

create table zepto(
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

--data exploration

--count of rows
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
LIMIT 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR 
category IS NULL
OR 
mrp IS NULL
OR 
discountpercent IS NULL
OR 
availablequantity IS NULL
OR 
discountedsellingprice IS NULL
OR 
weightingms IS NULL
OR 
outofstock IS NULL
OR 
quantity IS NULL;

--diff products categories
SELECT DISTINCT category 
      FROM zepto
	  ORDER BY category;

--product in stock vs out of stock
SELECT outofstock, COUNT(sku_id)
      FROM zepto 
	  GROUP BY outofstock;

--products name present multiple times
SELECT name, count(sku_id) AS "Number of SKUs"
      FROM zepto
	  GROUP BY name
	  HAVING COUNT(sku_id) > 1
	  ORDER BY COUNT(sku_id) DESC;

--DATA CLEANING

--del products with price = 0
SELECT * FROM zepto
WHERE mrp = 0;

DELETE FROM zepto
WHERE mrp = 0;

--convert paise into rupees (in col mrp and discountedsellingprice)
UPDATE zepto
SET mrp = mrp/100.0,
    discountedsellingprice = discountedsellingprice/100.0;

SELECT mrp, discountedsellingprice FROM zepto;

Certainly. Here are the questions from the image in a copyable text format.

--BUSINESS INSIGHT QUERIES

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountpercent
FROM zepto 
ORDER BY discountpercent DESC
LIMIT 10;
----So, this is usefull for both customers looking for barganes and for businesses to know which products are being heavily promoted. 


-- Q2. What are the Products with High MRP but Out of Stock.
SELECT DISTINCT name, mrp, category, outofstock
FROM zepto
WHERE mrp > 300 and outofstock = True
ORDER BY mrp DESC;
----So, these are products which company needs to restock, if customers buying them frequently.


-- Q3. Calculate Estimated Revenue for each category
SELECT category, sum(discountedsellingprice * quantity) AS estimated_revenue
FROM zepto
GROUP BY category
ORDER BY estimated_revenue DESC;
----So, company got the most of the revenue from 'Packaged Food' category.


-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, category, mrp, discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent < 10
ORDER BY mrp DESC, discountpercent DESC;
----So, these are already popular enough and selling well that's why discount on them is less.


-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category, ROUND(avg(discountpercent),2) as avg_discountpercent
FROM zepto
GROUP BY category
ORDER BY avg_discountpercent DESC LIMIT 5;
----So, it will helpfull to check which categories cuts are high.


-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightingms, discountedsellingprice,
ROUND(discountedsellingprice/weightingms,2) AS price_per_gram
FROM zepto
where weightingms > 100
ORDER BY price_per_gram;

-- Q7. Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightingms,
CASE 
    WHEN weightingms < 1000 THEN 'Low'
	WHEN weightingms > 5000 THEN 'Medium'
	ELSE 'High'
END AS weight_category
FROM zepto;


-- Q8. What is the Total Inventory Weight Per Category
SELECT category, sum(weightingms * availablequantity) AS total_weight
FROM zepto 
GROUP BY category
ORDER BY total_weight;
----This is very gratefull in warehouse planning and identifying bulky product category.
