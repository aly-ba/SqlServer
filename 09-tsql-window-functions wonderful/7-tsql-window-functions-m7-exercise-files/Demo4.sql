/*
T-SQL Window Functions Class
Module 7
Demo 4
*/

USE AdventureWorks2014;
GO
SET STATISTICS IO ON;
GO

--Framing
--Default frame
SELECT CustomerID, SalesOrderID, TotalDue,
	FIRST_VALUE(TotalDue) 
	OVER(PARTITION BY CustomerID ORDER BY SalesOrderID) AS FirstOrder
FROM Sales.SalesOrderHeader;

--Specify the frame
SELECT CustomerID, SalesOrderID, TotalDue,
	FIRST_VALUE(TotalDue) 
	OVER(PARTITION BY CustomerID ORDER BY SalesOrderID
	ROWS UNBOUNDED PRECEDING) AS FirstOrder
FROM Sales.SalesOrderHeader;



--LAG and LEAD
SELECT CustomerID, SalesOrderID, TotalDue, 
	LAG(SalesOrderID) OVER(PARTITION BY CustomerID ORDER BY SalesOrderID) AS PrevOrder
FROM Sales.SalesOrderHeader;

--Use Variable for the offset
DECLARE @Offset INT = 1;
SELECT CustomerID, SalesOrderID, TotalDue, 
	LAG(SalesOrderID, @Offset) OVER(ORDER BY SalesOrderID) AS PrevOrder
FROM Sales.SalesOrderHeader;


--Index
SELECT CustomerID, SalesOrderID, TotalDue, 
	LAG(TotalDue) OVER(PARTITION BY CustomerID ORDER BY SalesOrderID) AS PrevTotal
FROM Sales.SalesOrderHeader;


CREATE NONCLUSTERED INDEX [IDX_ForPerformanceDemo] ON [Sales].[SalesOrderHeader]
	([CustomerID],[SalesOrderID]) INCLUDE ([TotalDue]) 
GO

SELECT CustomerID, SalesOrderID, TotalDue, 
	LAG(TotalDue) OVER(PARTITION BY CustomerID ORDER BY SalesOrderID) AS PrevTotal
FROM Sales.SalesOrderHeader;

--Clean up
DROP INDEX IDX_ForPerformanceDemo ON Sales.SalesOrderHeader;
