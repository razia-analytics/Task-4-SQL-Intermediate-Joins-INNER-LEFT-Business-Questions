CREATE DATABASE northwind;
USE northwind;
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
SELECT COUNT(*) AS total_orders
FROM orders;
SELECT COUNT(*) AS joined_orders
FROM orders o
INNER JOIN customers c
    ON o.CustomerID = c.CustomerID;
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
SELECT COUNT(*) AS inactive_customers
FROM customers c
LEFT JOIN orders o
    ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;
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
SELECT 
    o.ShipCountry,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_sales
FROM orders o
INNER JOIN order_details od
    ON o.OrderID = od.OrderID
WHERE o.ShipCountry = 'Germany'
  AND o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
GROUP BY o.ShipCountry;
SELECT 
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS wa_sales
FROM orders o
JOIN order_details od ON o.OrderID = od.OrderID
WHERE o.ShipRegion = 'WA';
SELECT 
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS wa_sales
FROM orders AS o
JOIN order_details AS od 
    ON o.OrderID = od.OrderID
WHERE 
    o.ShipRegion = 'WA'
    AND o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31';
