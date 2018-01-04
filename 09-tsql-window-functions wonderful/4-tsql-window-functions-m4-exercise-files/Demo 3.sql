/*
T-SQL Window Functions Class
Module 4
Demo 3
*/

USE AdventureWorks2014; 
GO

--Typical aggregate query
SELECT CustomerID, SUM(TotalDue) AS CustomerSales
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2014-01-01' AND OrderDate < '2015-01-01'
GROUP BY CustomerID;

--Add a grand total
SELECT CustomerID, SUM(TotalDue) AS CustomerSales,
	SUM(TotalDue) OVER() AS TotalSales
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2014-01-01' AND OrderDate < '2015-01-01'
GROUP BY CustomerID;


--CTE first
WITH Totals AS (
	SELECT CustomerID, SUM(TotalDue) AS CustomerSales
	FROM Sales.SalesOrderHeader
	WHERE OrderDate >= '2014-01-01' AND OrderDate < '2015-01-01'
	GROUP BY CustomerID)
SELECT CustomerID, CustomerSales, 
	SUM(CustomerSales) OVER() TotalSales
FROM Totals;




--The window aggregate applies to the aggregate or a group by column
SELECT CustomerID, SUM(TotalDue) AS CustomerSales,
	SUM(SUM(TotalDue)) OVER() AS TotalSales
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2014-01-01' AND OrderDate < '2015-01-01'
GROUP BY CustomerID;




--Row number
SELECT CustomerID, SUM(TotalDue) AS CustomerSales,
	ROW_NUMBER() OVER(ORDER BY SUM(TotalDue)) AS RowNum
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2014-01-01' AND OrderDate < '2015-01-01'
GROUP BY CustomerID;


--DISTINCT

--Get a distinct list of customers and a count
--Here are the customers
SELECT DISTINCT CustomerID 
FROM Sales.SalesOrderHeader;


--Add Count
SELECT DISTINCT CustomerID, 
	COUNT(*) OVER() AS CountOfCustomers 
FROM Sales.SalesOrderHeader;

--Try adding distinct to count
SELECT DISTINCT CustomerID, 
	COUNT(DISTINCT CustomerID) OVER() AS CountOfCustomers 
FROM Sales.SalesOrderHeader;


--Solution 1: Find distinct list first
WITH Customers AS (
	SELECT DISTINCT CustomerID 
	FROM Sales.SalesOrderHeader)
SELECT CustomerID, COUNT(*) OVER() AS CountOfCustomers
FROM Customers;

--Solution 2: Use GROUP BY
SELECT CustomerID, 
	COUNT(*) OVER() AS CountOfCustomers
FROM Sales.SalesOrderHeader
GROUP BY CustomerID;




