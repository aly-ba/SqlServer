-- You can get the AdventureWorksDW2012 database used in these demos from http://bit.ly/9hBGub

USE [AdventureWorksDW2012]
GO

-- Row count = 61,847,552
SELECT  COUNT(*) AS [rowcount]
FROM    dbo.[FactInternetSales];
GO

-- Simulate a "cold" cache (test environment, not recommended for production)
DBCC DROPCLEANBUFFERS;

-- Our "before" query
-- (Show execution plan)
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
ORDER BY p.[ProductLine], f.[SalesTerritoryKey], f.[CustomerKey]
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
GO

-- Creating the following nonclustered indexes for a later comparison
-- Will take a few minutes to run so I'll pause the video
CREATE NONCLUSTERED INDEX [NCI_FactInternetSales_ProductKey] 
ON [dbo].[FactInternetSales]
([ProductKey] ASC)
INCLUDE ( [SalesAmount]) ON [PRIMARY];
GO

CREATE NONCLUSTERED INDEX [NCI_DimProduct_ProductKey_ProductLine] ON [dbo].[DimProduct]
(    [ProductKey] ASC,
     [ProductLine] ASC
)ON [PRIMARY];
GO

-- Will take a few minutes to run so I'll pause the video
CREATE NONCLUSTERED COLUMNSTORE INDEX [NCI_FactInternetSales] ON [dbo].[FactInternetSales]
(
	[ProductKey],
	[OrderDateKey],
	[DueDateKey],
	[ShipDateKey],
	[CustomerKey],
	[PromotionKey],
	[CurrencyKey],
	[SalesTerritoryKey],
	[SalesOrderNumber],
	[SalesOrderLineNumber],
	[RevisionNumber],
	[OrderQuantity],
	[UnitPrice],
	[ExtendedAmount],
	[UnitPriceDiscountPct],
	[DiscountAmount],
	[ProductStandardCost],
	[TotalProductCost],
	[SalesAmount],
	[TaxAmt],
	[Freight],
	[CarrierTrackingNumber],
	[CustomerPONumber],
	[OrderDate],
	[DueDate],
	[ShipDate]
)WITH (DROP_EXISTING = OFF) ON [PRIMARY]
GO

-- Simulate a "cold" cache (test environment, not recommended for production)
DBCC DROPCLEANBUFFERS;

-- Our "after" query
-- (Show execution plan)
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

-- What about comparing a covering traditional set of indexes vs. columnstore?
SELECT  p.[ProductLine],
        SUM(f.SalesAmount) AS [TotalSalesAmount]
FROM    [dbo].[FactInternetSales] AS [f]
INNER JOIN [dbo].[DimProduct] AS [p]
        ON f.[ProductKey] = p.[ProductKey]
GROUP BY p.[ProductLine]
ORDER BY p.[ProductLine];

-- Traditional covered?
SELECT  p.[ProductLine],
        SUM(f.SalesAmount) AS [TotalSalesAmount]
FROM    [dbo].[FactInternetSales] AS [f]
INNER JOIN [dbo].[DimProduct] AS [p]
        ON f.[ProductKey] = p.[ProductKey]
GROUP BY p.[ProductLine]
ORDER BY p.[ProductLine]
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX);
