-- You can get the AdventureWorksDW2012 database used in these demos from http://bit.ly/9hBGub

-- I'm using SQL Server 2012, version 11.0.3349 (SP1, CU3)

USE [master]
GO
CREATE DATABASE [AdventureWorksDW2012] ON 
( FILENAME = N'S:\SQLskills\AdventureWorksDW2012_Data.mdf' )
 FOR ATTACH;
GO

-- Pre-size your database to reduce auto-growth operations
USE [master]
GO
ALTER DATABASE [AdventureWorksDW2012] 
MODIFY FILE ( NAME = N'AdventureWorksDW2012_Data', 
SIZE = 10485760KB, FILEGROWTH = 1048576KB )
GO

USE [master]
GO
ALTER DATABASE [AdventureWorksDW2012] 
MODIFY FILE ( NAME = N'AdventureWorksDW2012_Log', 
SIZE = 1048576KB , FILEGROWTH = 1048576KB )
GO

-- Current row count in FactInternetSales
USE [AdventureWorksDW2012];
GO

SELECT COUNT(*) 
FROM [dbo].[FactInternetSales];
GO

ALTER TABLE [dbo].[FactInternetSalesReason] 
DROP CONSTRAINT [FK_FactInternetSalesReason_FactInternetSales]
GO

ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber]
GO

-- Drop additional nonclustered indexes, to minimize QO surface area
DROP INDEX [IX_FactIneternetSales_ShipDateKey] ON [dbo].[FactInternetSales]
GO

DROP INDEX [IX_FactInternetSales_CurrencyKey] ON [dbo].[FactInternetSales]
GO

DROP INDEX [IX_FactInternetSales_CustomerKey] ON [dbo].[FactInternetSales]
GO

DROP INDEX [IX_FactInternetSales_DueDateKey] ON [dbo].[FactInternetSales]
GO

DROP INDEX [IX_FactInternetSales_OrderDateKey] ON [dbo].[FactInternetSales]
GO

DROP INDEX [IX_FactInternetSales_ProductKey] ON [dbo].[FactInternetSales]
GO

DROP INDEX [IX_FactInternetSales_PromotionKey] ON [dbo].[FactInternetSales]
GO

-- Creating a clustered index with PAGE data compression
CREATE CLUSTERED INDEX [CI_FactInternetSales_OrderDateKey] 
ON [dbo].[FactInternetSales]
(
	[OrderDateKey] ASC
)WITH (DATA_COMPRESSION = PAGE) 
ON [PRIMARY]
GO


-- Increasing the number of rows by changing the executions below
SET NOCOUNT ON;

INSERT  dbo.FactInternetSales
        (ProductKey,
         OrderDateKey,
         DueDateKey,
         ShipDateKey,
         CustomerKey,
         PromotionKey,
         CurrencyKey,
         SalesTerritoryKey,
         SalesOrderNumber,
         SalesOrderLineNumber,
         RevisionNumber,
         OrderQuantity,
         UnitPrice,
         ExtendedAmount,
         UnitPriceDiscountPct,
         DiscountAmount,
         ProductStandardCost,
         TotalProductCost,
         SalesAmount,
         TaxAmt,
         Freight,
         CarrierTrackingNumber,
         CustomerPONumber,
         OrderDate,
         DueDate,
         ShipDate)
        SELECT  ProductKey,
                OrderDateKey,
                DueDateKey,
                ShipDateKey,
                CustomerKey,
                PromotionKey,
                CurrencyKey,
                SalesTerritoryKey,
                LEFT(CAST(NEWID() AS NVARCHAR(36)), 20),
                SalesOrderLineNumber,
                RevisionNumber,
                OrderQuantity,
                UnitPrice,
                ExtendedAmount,
                UnitPriceDiscountPct,
                DiscountAmount,
                ProductStandardCost,
                TotalProductCost,
                SalesAmount,
                TaxAmt,
                Freight,
                CarrierTrackingNumber,
                CustomerPONumber,
                OrderDate,
                DueDate,
                ShipDate
FROM dbo.FactInternetSales;
CHECKPOINT;
GO 10 -- Change this based on your test environment storage and time you want to wait (Row count = 61,847,552, 40 minutes)


