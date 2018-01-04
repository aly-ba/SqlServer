-- You can get the AdventureWorksDW2012 database used in these demos from http://bit.ly/9hBGub

-- Run this memory grant query in a separate window
SELECT  [session_id],
        [request_id],
        [scheduler_id],
        [dop],
        [request_time],
        [grant_time],
        [requested_memory_kb],
        [granted_memory_kb],
        [required_memory_kb]
FROM    sys.[dm_exec_query_memory_grants];
GO

USE [AdventureWorksDW2012]
GO

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
)WITH (DROP_EXISTING = ON) ON [PRIMARY]
GO

-- Reduced columns

CREATE NONCLUSTERED COLUMNSTORE INDEX [NCI_FactInternetSales] ON [dbo].[FactInternetSales]
(
	[ProductKey],
	[OrderDateKey],
	[DueDateKey],
	[ShipDateKey],
	[CustomerKey],
	[PromotionKey],
	[CurrencyKey]
)WITH (DROP_EXISTING = ON) ON [PRIMARY]
GO

-- Reduced max degree of parallelism

CREATE NONCLUSTERED COLUMNSTORE INDEX [NCI_FactInternetSales] ON [dbo].[FactInternetSales]
(
	[ProductKey],
	[OrderDateKey],
	[DueDateKey],
	[ShipDateKey],
	[CustomerKey],
	[PromotionKey],
	[CurrencyKey]
)WITH (DROP_EXISTING = ON,
		MAXDOP = 1) ON [PRIMARY]
GO

-- Resource Governor

-- Check on workload group
SELECT  [group_id],
        [name],
        [importance],
        [request_max_memory_grant_percent],
        [request_max_cpu_time_sec],
        [request_memory_grant_timeout_sec],
        [max_dop],
        [group_max_requests],
        [pool_id]
FROM sys.resource_governor_workload_groups;
