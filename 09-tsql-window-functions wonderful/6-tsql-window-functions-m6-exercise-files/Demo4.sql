/*
T-SQL Window Functions Class
Module 6
Demo 4
*/

USE AdventureWorks2014;
GO

SET STATISTICS IO ON;
GO

--Objective: Running total for each customer

CREATE INDEX IDX_ForPerformanceDemo ON 
	Sales.SalesOrderHeader
	(CustomerID, SalesOrderID) INCLUDE(TotalDue);


--Cross apply and subquery
SELECT CustomerID, SalesOrderID, TotalDue, 
	rt.Total AS RunningTotal
FROM Sales.SalesOrderHeader AS OuterQuery 
CROSS APPLY 
	(SELECT SUM(TotalDue) AS Total
	FROM Sales.SalesOrderHeader AS InnerQuery
	WHERE InnerQuery.CustomerID = OuterQuery.CustomerID AND
		InnerQuery.SalesOrderID <= OuterQuery.SalesOrderID
	)  rt
ORDER BY CustomerID, SalesOrderID;







--Cursor. 

--Just kidding!


--Accumulating Window Aggregate
--Default frame
SELECT CustomerID, SalesOrderID, TotalDue,
	SUM(TotalDue) OVER(PARTITION BY CustomerID 
		ORDER BY SalesOrderID) AS RunningTotal
FROM Sales.SalesOrderHeader
ORDER BY CustomerID, SalesOrderID;

--Specify RANGE
SELECT CustomerID, SalesOrderID, TotalDue,
	SUM(TotalDue) OVER(PARTITION BY CustomerID 
		ORDER BY SalesOrderID
		RANGE UNBOUNDED PRECEDING) AS RunningTotal
FROM Sales.SalesOrderHeader;

--Specify ROWS
SELECT CustomerID, SalesOrderID, TotalDue,
	SUM(TotalDue) OVER(
		PARTITION BY CustomerID ORDER BY SalesOrderID
		ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM Sales.SalesOrderHeader;

SET STATISTICS IO OFF;
SET STATISTICS TIME ON;
GO
--Default frame which is actually RANGE
SELECT CustomerID, SalesOrderID, TotalDue,
	SUM(TotalDue) OVER(ORDER BY SalesOrderID) AS RunningTotal
FROM Sales.SalesOrderHeader;

--Specify ROWS
SELECT CustomerID, SalesOrderID, TotalDue,
	SUM(TotalDue) OVER(ORDER BY SalesOrderID
		ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM Sales.SalesOrderHeader;

--Clean up
DROP INDEX IDX_ForPerformanceDemo ON 
	Sales.SalesOrderHeader;
