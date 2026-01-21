## Northwind SQL Analysis

This SQL script performs an analysis on the **Northwind database**, covering orders, customers, products, categories, and sales performance. The queries are organized to provide insights into customer activity, product performance, category revenue, and country/region sales.

![SQL](https://github.com/user-attachments/assets/a6447c50-c4ac-43ae-a9e1-6256973cbd40)

## **1. Database Setup**

CREATE DATABASE northwind;
USE northwind;

**Creates the `northwind'database and sets it as the active database for queries.**

## **2. Orders and Customers**

### a. Retrieve Orders with Customer Info
SELECT 
    o.OrderID,
    o.OrderDate,
    o.CustomerID,
    c.CompanyName,
    c.ContactName,
    c.City,
    c.Country
FROM orders o
INNER JOIN customers c
    ON o.CustomerID = c.CustomerID;

* Lists all orders along with the associated customer details.
* Helps link **orders to customers** for further analysis.

### b. Count Total Orders

SELECT COUNT(*) AS total_orders
FROM orders;

* Counts the **total number of orders** in the database.

### c. Count Orders That Successfully Join with Customers

SELECT COUNT(*) AS joined_orders
FROM orders o
INNER JOIN customers c
    ON o.CustomerID = c.CustomerID;

* Confirms how many orders have **valid associated customers**.

## **3. Identify Inactive Customers**

### a. Customers Without Orders

SELECT 
    c.CustomerID,
    c.CompanyName,
    c.ContactName,
    c.City,
    c.Country
FROM customers c
LEFT JOIN orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

* Lists customers who have **never placed an order**.

### b. Count of Inactive Customers

SELECT COUNT(*) AS inactive_customers
FROM customers c
LEFT JOIN orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

* Provides the **number of inactive customers** in the system.

## **4. Top Customers by Number of Orders**

SELECT 
    c.CustomerID,
    c.CompanyName,
    COUNT(o.OrderID) AS total_orders
FROM customers c
INNER JOIN orders o
    ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY total_orders DESC
LIMIT 10;

* Shows the **top 10 customers** with the most orders.
* Useful for identifying **high-value or loyal customers**.

## **5. Product Revenue and Sales**

### a. Product-Level Revenue and Units Sold

SELECT 
    p.ProductID,
    p.ProductName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_revenue,
    SUM(od.Quantity) AS total_units_sold
FROM products p
INNER JOIN order_details od
    ON p.ProductID = od.ProductID
INNER JOIN orders o
    ON od.OrderID = o.OrderID
GROUP BY p.ProductID, p.ProductName
ORDER BY total_revenue DESC;

* Calculates **total revenue** and **total units sold** for each product.
* Helps identify **best-selling and highest-revenue products**.

### b. Top 3 Products by Revenue

SELECT 
    p.ProductName,
    SUM(od.Quantity) AS total_units_sold,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_revenue
FROM order_details AS od
JOIN products AS p
    ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY total_revenue DESC
LIMIT 3;

* Returns the **three highest revenue-generating products**.

## **6. Category Revenue Analysis**

### a. Revenue and Units Sold per Category

SELECT 
    c.CategoryID,
    c.CategoryName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS category_revenue,
    SUM(od.Quantity) AS total_units_sold
FROM categories c
INNER JOIN products p
    ON c.CategoryID = p.CategoryID
INNER JOIN order_details od
    ON p.ProductID = od.ProductID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY category_revenue DESC;

* Calculates **total revenue** and **units sold** for each product category.
* Useful for understanding which **product types drive the most sales**.

### b. Revenue Percentage by Category

SELECT 
    c.CategoryName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS revenue,
    ROUND(
        100 * SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) /
        (SELECT SUM(UnitPrice * Quantity * (1 - Discount)) FROM order_details),
    2) AS revenue_percentage
FROM categories c
JOIN products p ON c.CategoryID = p.CategoryID
JOIN order_details od ON p.ProductID = od.ProductID
GROUP BY c.CategoryName
ORDER BY revenue DESC;

* Shows **how much each category contributes to total sales** as a percentage.
* Highlights **key categories for revenue concentration**.

## **7. Regional Sales Analysis**

### a. Germany Sales in 1997

SELECT 
    o.ShipCountry,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_sales
FROM orders o
INNER JOIN order_details od
    ON o.OrderID = od.OrderID
WHERE o.ShipCountry = 'Germany'
  AND o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
GROUP BY o.ShipCountry;

* Calculates **total sales shipped to Germany in 1997**.

### b. Sales in Washington (WA)

SELECT 
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS wa_sales
FROM orders o
JOIN order_details od ON o.OrderID = od.OrderID
WHERE o.ShipRegion = 'WA';

* Shows total sales for **all orders shipped to Washington**.

### c. WA Sales in 1997

SELECT 
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS wa_sales
FROM orders AS o
JOIN order_details AS od 
    ON o.OrderID = od.OrderID
WHERE 
    o.ShipRegion = 'WA'
    AND o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31';

* Filters **Washington sales specifically for the year 1997**.

This README gives a **comprehensive understanding** of the queries and their purposes.


