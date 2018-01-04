/*
T-SQL Window Functions
Module 3
Demo 3
*/

USE AdventureWorks2014;
GO

--Top
SELECT TOP(10) CustomerID, SalesOrderID, 
	FORMAT(OrderDate, 'yyyy-MM-dd') AS OrderDate, 
	ROW_NUMBER() OVER(ORDER BY SalesOrderID) AS RowNum
FROM Sales.SalesOrderHeader;


--Different Query Order
SELECT TOP(10) CustomerID, SalesOrderID, 
	FORMAT(OrderDate, 'yyyy-MM-dd') AS OrderDate, 
	ROW_NUMBER() OVER(ORDER BY SalesOrderID) AS RowNum
FROM Sales.SalesOrderHeader
ORDER BY CustomerID;

--Use a CTE
WITH Sales AS (
	SELECT TOP(10) CustomerID, SalesOrderID, 
		FORMAT(OrderDate, 'yyyy-MM-dd') AS OrderDate 
	FROM Sales.SalesOrderHeader
	ORDER BY CustomerID)
SELECT CustomerID, SalesOrderID, OrderDate, 
	ROW_NUMBER() OVER(ORDER BY SalesOrderID) AS RowNum
FROM Sales;


--Distinct 
SELECT DISTINCT ProductID 
FROM Sales.SalesOrderDetail;

--Add ROW_NUMBER
SELECT DISTINCT ProductID, 
	ROW_NUMBER() OVER(ORDER BY ProductID) AS RowNum 
FROM Sales.SalesOrderDetail;

--Use CTE
WITH Products AS (
	SELECT DISTINCT ProductID 
	FROM Sales.SalesOrderDetail)
SELECT ProductID, 
	ROW_NUMBER() OVER(ORDER BY ProductID) AS RowNum
FROM Products;

