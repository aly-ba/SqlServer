-- You can get the AdventureWorksDW2012 database used in these demos from http://bit.ly/9hBGub

USE [AdventureWorksDW2012]
GO

-- Parallelism used to execute the query?
SELECT  p.[ProductLine],
		f.[SalesTerritoryKey],
		f.[CustomerKey],
        AVG(f.[SalesAmount]) AS [AvgSalesAmount],
        SUM(f.[SalesAmount]) AS [TotalSalesAmount]
FROM    dbo.[FactInternetSales] AS [f]
INNER JOIN dbo.[DimProduct] AS [p]
        ON f.[ProductKey] = p.[ProductKey]
WHERE   p.[Size] IS NOT NULL AND
		f.[UnitPriceDiscountPct] = 0
GROUP BY p.[ProductLine], f.[SalesTerritoryKey], f.[CustomerKey]
ORDER BY p.[ProductLine], f.[SalesTerritoryKey], f.[CustomerKey];
GO

-- Configuring server level MAXDOP
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
GO

EXEC sp_configure 'max degree of parallelism', 1;
RECONFIGURE;
GO

-- What is the plan shape now?
SELECT  p.[ProductLine],
		f.[SalesTerritoryKey],
		f.[CustomerKey],
        AVG(f.[SalesAmount]) AS [AvgSalesAmount],
        SUM(f.[SalesAmount]) AS [TotalSalesAmount]
FROM    dbo.[FactInternetSales] AS [f]
INNER JOIN dbo.[DimProduct] AS [p]
        ON f.[ProductKey] = p.[ProductKey]
WHERE   p.[Size] IS NOT NULL AND
		f.[UnitPriceDiscountPct] = 0
GROUP BY p.[ProductLine], f.[SalesTerritoryKey], f.[CustomerKey]
ORDER BY p.[ProductLine], f.[SalesTerritoryKey], f.[CustomerKey];
GO

EXEC sp_configure 'max degree of parallelism', 0;
RECONFIGURE;
GO

EXEC sp_configure 'show advanced options', 0;
RECONFIGURE;
GO

