-- You can get the AdventureWorksDW2012 database used in these demos from http://bit.ly/9hBGub

USE [AdventureWorksDW2012]
GO

-- Drop and recreate based on an existing index
-- Show execution plan to see DOP
CREATE NONCLUSTERED COLUMNSTORE INDEX [NCI_FactInternetSales] 
ON [dbo].[FactInternetSales]
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
)WITH (DROP_EXISTING = ON) ON [PRIMARY]
GO

-- Example of reducing MAXDOP (lower will likely be slower, but lower memory grant)
CREATE NONCLUSTERED COLUMNSTORE INDEX [NCI_FactInternetSales] 
ON [dbo].[FactInternetSales]
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
)WITH (DROP_EXISTING = ON, MAXDOP = 2) ON [PRIMARY]
GO

-- We'll cover table partitioning syntax later in this course