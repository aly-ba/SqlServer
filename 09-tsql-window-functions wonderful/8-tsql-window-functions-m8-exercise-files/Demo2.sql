/*
T-SQL Window Functions Class
Module 8
Demo 2
*/

USE PL_SampleData; 
GO


--Find the grade at 90%
SELECT Grade, 
	PERCENTILE_DISC(0.9) WITHIN GROUP(ORDER BY GRADE) OVER() AS GradeAt90D,
	PERCENTILE_CONT(0.9) WITHIN GROUP(ORDER BY GRADE) OVER() AS GradeAt90C
FROM Grades;

--Use distinct or group by 
WITH GradeAt90 AS (
	SELECT Grade, 
		PERCENTILE_DISC(0.9) WITHIN GROUP(ORDER BY GRADE) OVER() AS GradeAt90D,
		PERCENTILE_CONT(0.9) WITHIN GROUP(ORDER BY GRADE) OVER() AS GradeAt90C
	FROM Grades)
SELECT GradeAt90D, GradeAt90C 
FROM GradeAt90
GROUP BY GradeAt90D, GradeAt90C;



USE AdventureWorks2014;
GO


--Find the median sales
WITH Sales AS (
	SELECT YEAR(OrderDate) AS OrderYear, 
		MONTH(OrderDate) AS OrderMonth,
		SUM(TotalDue) AS TotalSales 
	FROM Sales.SalesOrderHeader
	GROUP BY YEAR(OrderDate), MONTH(OrderDate))
SELECT OrderYear, OrderMonth, TotalSales,
	PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY TotalSales) 
		OVER(PARTITION BY OrderYear) AS PercentileCont,
	PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY TotalSales) 
		OVER(PARTITION BY OrderYear) AS PercentileDisc
FROM Sales;


--Return the month
WITH Sales AS (
	SELECT YEAR(OrderDate) AS OrderYear, 
		MONTH(OrderDate) AS OrderMonth,
		SUM(TotalDue) AS TotalSales 
	FROM Sales.SalesOrderHeader
	GROUP BY YEAR(OrderDate), MONTH(OrderDate)),
Median AS (
	SELECT DISTINCT OrderYear, 
		PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY TotalSales) 
			OVER(PARTITION BY OrderYear) AS MedianSales
	FROM Sales)
SELECT Median.OrderYear, OrderMonth, MedianSales
FROM Median 
JOIN Sales ON Median.OrderYear = Sales.OrderYear 
	AND Sales.TotalSales = Median.MedianSales;






	

