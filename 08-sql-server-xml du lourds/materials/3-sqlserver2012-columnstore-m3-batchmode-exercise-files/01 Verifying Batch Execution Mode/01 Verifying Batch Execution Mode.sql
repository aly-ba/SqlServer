-- You can get the AdventureWorksDW2012 database used in these demos from http://bit.ly/9hBGub

USE [AdventureWorksDW2012]
GO

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

