-- You can get the AdventureWorksDW2012 database used in these demos from http://bit.ly/9hBGub

USE [AdventureWorksDW2012]
GO


-- Scalar aggregate - row mode
SELECT  SUM(f.[SalesAmount]) AS [TotalSalesAmount]
FROM    [dbo].[FactInternetSales] AS f;
GO

-- Scalar aggregate - batch mode
WITH [IntermediateResult] 
AS (
	SELECT  YEAR([OrderDate]) AS [OrderDateYear], 
			SUM(f.[SalesAmount]) AS [TotalSalesAmount]
	FROM    [dbo].[FactInternetSales] AS f
	GROUP BY YEAR([OrderDate]) 
 ) 
SELECT SUM([TotalSalesAmount])
FROM IntermediateResult;
GO
