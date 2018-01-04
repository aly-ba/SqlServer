-- You can get the AdventureWorksDW2012 database used in these demos from http://bit.ly/9hBGub

USE [AdventureWorksDW2012];
GO

-- Create a sub-set of the larger Fact table for demonstration purposes
SELECT TOP 2000000 *
INTO dbo.[FactInternetSales_PartitionDemo]
FROM dbo.[FactInternetSales];
GO

CREATE PARTITION FUNCTION [pf_DueDate](datetime) AS RANGE LEFT FOR VALUES (N'2005-07-13T00:00:00', N'2005-08-13T00:00:00', N'2005-09-13T00:00:00', N'2005-10-13T00:00:00', N'2005-11-13T00:00:00', N'2005-12-13T00:00:00', N'2006-01-13T00:00:00', N'2006-02-13T00:00:00', N'2006-03-13T00:00:00', N'2006-04-13T00:00:00', N'2006-05-13T00:00:00', N'2006-06-13T00:00:00', N'2006-07-13T00:00:00', N'2006-08-13T00:00:00', N'2006-09-13T00:00:00', N'2006-10-13T00:00:00', N'2006-11-13T00:00:00', N'2006-12-13T00:00:00', N'2007-01-13T00:00:00', N'2007-02-13T00:00:00');
GO

CREATE PARTITION SCHEME [ps_DueDate] AS PARTITION [pf_DueDate] TO ([PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY]);
GO

CREATE CLUSTERED INDEX [CI_FactInternetSales_PartitionDemo] ON [dbo].[FactInternetSales_PartitionDemo]
(
	[DueDate]
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [ps_DueDate]([DueDate]);
GO

-- Create the columnstore index
CREATE NONCLUSTERED COLUMNSTORE INDEX [NCI_FactInternetSales_PartitionDemo] ON [dbo].[FactInternetSales_PartitionDemo]
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
)
WITH (DROP_EXISTING = OFF);
GO

-- Create staging table
CREATE TABLE [dbo].[staging_FactInternetSales_PartitionDemo](
	[ProductKey] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[DueDateKey] [int] NOT NULL,
	[ShipDateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[PromotionKey] [int] NOT NULL,
	[CurrencyKey] [int] NOT NULL,
	[SalesTerritoryKey] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesOrderLineNumber] [tinyint] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [float](53) NOT NULL,
	[DiscountAmount] [float](53) NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CustomerPONumber] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[ShipDate] [datetime] NULL
) ON [PRIMARY];
GO

CREATE CLUSTERED INDEX [staging_FactInternetSales_PartitionDemo_CI_FactInternetSales_PartitionDemo] ON [dbo].[staging_FactInternetSales_PartitionDemo]
(
	[DueDate] ASC
)WITH (PAD_INDEX = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];
GO

CREATE NONCLUSTERED COLUMNSTORE INDEX [staging_FactInternetSales_PartitionDemo_NCI_FactInternetSales_PartitionDemo] ON [dbo].[staging_FactInternetSales_PartitionDemo]
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
)WITH (DROP_EXISTING = OFF) ON [PRIMARY];
GO

ALTER TABLE [dbo].[staging_FactInternetSales_PartitionDemo]  WITH CHECK ADD  CONSTRAINT [chk_staging_FactInternetSales_PartitionDemo_partition_1] CHECK  ([DueDate]<=N'2005-07-13T00:00:00');
GO

ALTER TABLE [dbo].[staging_FactInternetSales_PartitionDemo] CHECK CONSTRAINT [chk_staging_FactInternetSales_PartitionDemo_partition_1];
GO

-- "Before" count
SELECT COUNT(*)
FROM dbo.[FactInternetSales_PartitionDemo] 

ALTER TABLE [AdventureWorksDW2012].[dbo].[FactInternetSales_PartitionDemo] SWITCH PARTITION 1 TO [AdventureWorksDW2012].[dbo].[staging_FactInternetSales_PartitionDemo];
GO


-- "After" count
SELECT COUNT(*)
FROM dbo.[FactInternetSales_PartitionDemo] 

-- "Staging" table
SELECT COUNT(*)
FROM dbo.[staging_FactInternetSales_PartitionDemo]

-- And likewise, I could drop the columnstore index on the staging table, modify data, add back the index and then switch it into the Fact table that's covered by the index

-- Demo cleanup 
DROP TABLE dbo.[staging_FactInternetSales_PartitionDemo];
GO

DROP TABLE dbo.[FactInternetSales_PartitionDemo];
GO

DROP PARTITION SCHEME  [ps_DueDate];
GO

DROP PARTITION FUNCTION  [pf_DueDate];
GO



