-- You can get the AdventureWorksDW2012 database used in these demos from http://bit.ly/9hBGub

USE [AdventureWorksDW2012]
GO


-- Row execution mode
SELECT  f.[ProductKey],
        ISNULL(SUM(f.SalesAmount),0.00) AS [TotalSalesAmount]
FROM    dbo.[FactInternetSales] AS f
WHERE f.[ProductKey] NOT IN
	(SELECT ProductKey
	 FROM dbo.[DimProduct] 
	 WHERE [WeightUnitMeasureCode] IS NULL)
GROUP BY f.[ProductKey]
ORDER BY f.[ProductKey];
GO


-- Re-write to batch execution mode
SELECT  f.[ProductKey],
        ISNULL(SUM(f.SalesAmount),0.00) AS [TotalSalesAmount]
FROM    dbo.[FactInternetSales] AS f
INNER JOIN dbo.[DimProduct] AS p ON
	f.[ProductKey] = p.[ProductKey]
WHERE p.[WeightUnitMeasureCode] IS NOT NULL
GROUP BY f.[ProductKey]
ORDER BY f.[ProductKey];
GO


-- CTE alternative
WITH [Sales]
AS
	(SELECT [ProductKey],
			ISNULL(SUM([SalesAmount]),0.00) AS [TotalSalesAmount]
	FROM    dbo.[FactInternetSales] AS f
	GROUP BY [ProductKey])
SELECT	s.[ProductKey],
		s.[TotalSalesAmount]
FROM [Sales] AS s
WHERE s.[ProductKey] NOT IN
	(SELECT ProductKey
	 FROM dbo.[DimProduct] 
	 WHERE [WeightUnitMeasureCode] IS NULL)
ORDER BY s.ProductKey;
GO
