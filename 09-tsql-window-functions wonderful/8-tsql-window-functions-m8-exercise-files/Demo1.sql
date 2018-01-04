/*
T-SQL Window Functions Class
Module 8
Demo 1
*/

USE PL_SampleData;
GO

SELECT * FROM grades;

--Using the statistical functions
SELECT StudentID, Grade, 
	FORMAT(PERCENT_RANK() OVER(ORDER BY Grade),'P') AS PercentRank,
	FORMAT(CUME_DIST() OVER(ORDER BY Grade),'P') AS CumeDist
FROM grades;

--PERCENT_RANK = (Rank -1)/(N -1)
--CUME_DIST = Rank/N


--Add rank
SELECT StudentID, Grade, 
	RANK() OVER(ORDER BY Grade) AS Rnk,
	FORMAT(PERCENT_RANK() OVER(ORDER BY Grade),'P') AS PercentRank,
	FORMAT(CUME_DIST() OVER(ORDER BY Grade),'P') AS CumeDist
FROM grades;


--Use distinct values and compare to formulas
WITH DistinctGrades AS (
	SELECT Grade 
	FROM grades 
	GROUP BY Grade)
SELECT Grade,	
	FORMAT((RANK() OVER(ORDER BY Grade) -1)/CAST((COUNT(*) OVER() -1) AS FLOAT),'P') AS CalcPR,
	FORMAT(PERCENT_RANK() OVER(ORDER BY Grade),'P') AS PercentRank,
	FORMAT(RANK() OVER(ORDER BY Grade)/CAST(COUNT(*) OVER() AS FLOAT),'P') AS CalcCD,
	FORMAT(CUME_DIST() OVER(ORDER BY Grade),'P') AS CumeDist
FROM DistinctGrades;


USE AdventureWorks2014;
GO
--Partition the data
WITH Sales AS(
	SELECT YEAR(OrderDate) AS OrderYear, 
		MONTH(OrderDate) AS OrderMonth,
		SUM(TotalDue) AS TotalSales
	FROM Sales.SalesOrderHeader
	GROUP BY YEAR(OrderDate),MONTH(OrderDate))
SELECT OrderYear, OrderMonth,
	TotalSales, 
	FORMAT(PERCENT_RANK() OVER(PARTITION BY OrderYear ORDER BY OrderMonth),'P') AS PercentRank,
	FORMAT(CUME_DIST() OVER(PARTITION BY OrderYear ORDER BY OrderMonth),'P') AS CumeDist
FROM Sales;



















WITH Sales AS (
	SELECT MONTH(OrderDate) AS OrderMonth,
		SUM(TotalDue) AS TotalSales
	FROM Sales.SalesOrderHeader
	WHERE OrderDate >= '2012-01-01' AND OrderDate < '2013-01-01'
	GROUP BY MONTH(OrderDate)
)
SELECT OrderMonth, TotalSales, 
	PERCENT_RANK() OVER(ORDER BY OrderMonth) AS PercentRank,
	CUME_DIST() OVER(ORDER BY OrderMonth) AS CumeDist
FROM Sales;

