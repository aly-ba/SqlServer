/*
T-SQL Window Functions Class
Module 4
Demo 4
*/

USE AdventureWorks2014;
GO

--Enable CLR configuration
EXEC sp_configure 'clr enabled',1;
RECONFIGURE;
GO

--Add DLL to SQL 
CREATE ASSEMBLY CustomAggregate FROM
 'C:\UDFAggregate\CustomAggregate.dll' WITH PERMISSION_SET = SAFE; 
GO

--Create the UDF
CREATE Aggregate Median (@Value INT) RETURNS INT
EXTERNAL NAME CustomAggregate.Median;

GO
--The detail count for each order
SELECT SalesOrderID, COUNT(*) AS DetailCount
FROM Sales.SalesOrderDetail
WHERE SalesOrderID BETWEEN 43660 AND 43670
GROUP BY SalesOrderID
ORDER BY COUNT(*);




--What is the median detail count?
WITH Details AS (	
	SELECT SalesOrderID, COUNT(*) AS DetailCount
	FROM Sales.SalesOrderDetail
	WHERE SalesOrderID BETWEEN 43660 AND 43670
	GROUP BY SalesOrderID)
SELECT dbo.Median(DetailCount) AS MedianCount
FROM Details;




--Display the details with the median
SELECT SalesOrderID, COUNT(*) AS DetailCount,
	dbo.MEDIAN(COUNT(*)) OVER() AS MedianDetailCount
FROM Sales.SalesOrderDetail
WHERE SalesOrderID BETWEEN 43660 AND 43670
GROUP BY SalesOrderID;


--Clean up
DROP AGGREGATE dbo.Median;
DROP ASSEMBLY CustomAggregate;
EXEC sp_configure 'clr enabled', 0;
RECONFIGURE;
