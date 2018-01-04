/*
T-SQL Window Functions Class
Module 4
Demo 5
*/

USE AdventureWorks2014;
GO

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO


WITH Sales AS (
	SELECT SUM(TotalDue) AS TotalSales
	FROM Sales.SalesOrderHeader)
SELECT YEAR(OrderDate) AS OrderYear, 
	SUM(TotalDue) AS Sales,
	FORMAT(SUM(TotalDue)/TotalSales,'P') AS PercentOfSales
FROM Sales.SalesOrderHeader AS SOH
CROSS JOIN Sales
GROUP BY YEAR(OrderDate), TotalSales;

SELECT YEAR(OrderDate) AS OrderYear,
	SUM(TotalDue) AS Sales, 
	FORMAT(SUM(TotalDue)/SUM(SUM(TotalDue)) OVER(),'P') AS PercentOfSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate);







WITH Sales AS (
	SELECT CustomerID, SUM(TotalDue) AS CustomerSales
	FROM Sales.SalesOrderHeader
	GROUP BY CustomerID)
SELECT SOH.SalesOrderID, SOH.OrderDate, SOH.CustomerID, Sales.CustomerSales
FROM Sales.SalesOrderHeader AS SOH
JOIN Sales ON Sales.CustomerID = SOH.CustomerID;

SELECT SalesOrderID, OrderDate, CustomerID, 
	SUM(TotalDue) OVER(PARTITION BY CustomerID) AS CustomerSales
FROM Sales.SalesOrderHeader; 



	


	






