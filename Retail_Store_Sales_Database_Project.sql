/* Project Title --
Retail Store Sales Database Project */

CREATE DATABASE Retail_Store_Sales_Database_Project;
USE Retail_Store_Sales_Database_Project;

/* Project Description --
Design and query a simple database for a retail store that tracks products, customers, and sales. 
This will showcase basic SQL skills: creating tables, inserting data, joining tables, filtering, grouping, and using aggregate functions. */

/* Database Schema --
We’ll use 3 tables:-

1️. Customer -

Column-	           Data Type
customer_id	       INT (PK)
first_name	       VARCHAR
last_name	       VARCHAR
email	           VARCHAR

2️. Product -

Column-	           Data Type
product_id	       INT (PK)
product_name	   VARCHAR
price	           DECIMAL
category	       VARCHAR

3️. Sales -

Column-        	   Data Type
sale_id	           INT (PK)
customer_id	       INT (FK)
product_id	       INT (FK)
quantity	       INT
sale_date	       DATE
*/

-- CREATE TABLE

CREATE TABLE Customer (customer_id INT PRIMARY KEY, first_name VARCHAR(50), last_name VARCHAR(50), email VARCHAR(100));

CREATE TABLE Product (product_id INT PRIMARY KEY, product_name VARCHAR(100), price DECIMAL(10,2), category VARCHAR(50));

CREATE TABLE Sales (sale_id INT PRIMARY KEY, customer_id INT, product_id INT, quantity INT, sale_date DATE,
  FOREIGN KEY (customer_id) REFERENCES Customer(customer_id), FOREIGN KEY (product_id) REFERENCES Product(product_id));

-- INSERT DATA

INSERT INTO Customer VALUES
(1, 'John', 'Doe', 'john@example.com'),
(2, 'Jane', 'Smith', 'jane@example.com'),
(3, 'Alice', 'Brown', 'alice@example.com');

INSERT INTO Product VALUES
(1, 'T-Shirt', 15.99, 'Clothing'),
(2, 'Jeans', 39.99, 'Clothing'),
(3, 'Mug', 5.99, 'Kitchen'),
(4, 'Notebook', 2.49, 'Stationery');

INSERT INTO Sales VALUES
(1, 1, 1, 2, '2024-01-15'),
(2, 2, 2, 1, '2024-02-10'),
(3, 1, 3, 4, '2024-02-18'),
(4, 3, 4, 5, '2024-03-02');

-- 1./ Show All Customers
SELECT * FROM Customer;

-- 2./ Show All Products in Clothing Category
SELECT * FROM Product WHERE category = 'Clothing';

-- 3./ List All Sales with Customer and Product Info
SELECT s.sale_id, c.first_name, c.last_name, p.product_name, s.quantity, s.sale_date
FROM Sales s
JOIN Customer c ON s.customer_id = c.customer_id
JOIN Product p ON s.product_id = p.product_id;

-- 4./ Calculate Total Sales Amount for Each Sale
SELECT s.sale_id, c.first_name, p.product_name, s.quantity, (s.quantity * p.price) AS total_amount
FROM Sales s
JOIN Customer c ON s.customer_id = c.customer_id
JOIN Product p ON s.product_id = p.product_id;

-- 5./ Find Total Revenue (Sum of All Sales)
SELECT SUM(s.quantity * p.price) AS total_revenue
FROM Sales s
JOIN Product p ON s.product_id = p.product_id;

-- 6./ Count Number of Sales per Customer
SELECT c.customer_id, c.first_name, c.last_name,
  COUNT(s.sale_id) AS total_sales
FROM Customer c
LEFT JOIN Sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 7./ Show Total Quantity Sold per Product
SELECT p.product_id, p.product_name,
  SUM(s.quantity) AS total_quantity_sold
FROM Product p
LEFT JOIN Sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name;

-- 8./ List Customers with No Sales
SELECT c.* FROM Customer c
LEFT JOIN Sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;

-- 9./ Show the Top-Selling Product (by Quantity Sold)
SELECT p.product_id, p.product_name, SUM(s.quantity) AS total_quantity_sold
FROM Sales s
JOIN Product p ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- 10./ Find the Customer Who Spent the Most (Highest Purchase Value)
SELECT c.customer_id, c.first_name, c.last_name, 
       SUM(s.quantity * p.price) AS total_spent
FROM Sales s
JOIN Customer c ON s.customer_id = c.customer_id
JOIN Product p ON s.product_id = p.product_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 1;

-- 11./ Show Monthly Sales Revenue
SELECT DATE_FORMAT(s.sale_date, '%Y-%m') AS sale_month,
       SUM(s.quantity * p.price) AS monthly_revenue
FROM Sales s
JOIN Product p ON s.product_id = p.product_id
GROUP BY sale_month
ORDER BY sale_month;

-- 12./ Show Product Sales by Category
SELECT p.category, SUM(s.quantity) AS total_quantity_sold,
       SUM(s.quantity * p.price) AS total_revenue
FROM Sales s
JOIN Product p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- 13./ Find the Most Recent Sale Date for Each Customer
SELECT c.customer_id, c.first_name, c.last_name, MAX(s.sale_date) AS last_purchase_date
FROM Customer c
JOIN Sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;
