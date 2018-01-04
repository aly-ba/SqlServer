/****************************************************************
Course by: 	Pinal Dave  (http://blog.sqlauthority.com)
			Vinod Kumar (http://blogs.extremeExperts.com)

	Script - http://bit.ly/columnstoreindex

Scripts for SQL Server Performance: Query Tuning ©Pluralsight.

Description: Column Store Performance

****************************************************************/

USE AdventureWorks2012
GO
SET NOCOUNT ON

-- Create New Table Empty Table
SELECT *
INTO [Sales].[ColSalesOrderDetail]
FROM [Sales].[SalesOrderDetail]
WHERE 1 = 2
GO

-- Create clustered index
CREATE CLUSTERED INDEX [CL_ColSalesOrderDetail] 
ON [Sales].[ColSalesOrderDetail]
( [SalesOrderDetailID])
GO

-- Create Sample Data Table
-- WARNING: This Query may run upto 2-10 minutes based on your systems resources
-- Measure the Insert time in New Table
INSERT INTO [Sales].[ColSalesOrderDetail]
([SalesOrderID],[CarrierTrackingNumber],[OrderQty]
,[ProductID],[SpecialOfferID],[UnitPrice]
,[UnitPriceDiscount],[LineTotal],[rowguid],[ModifiedDate])
SELECT	[SalesOrderID],[CarrierTrackingNumber],[OrderQty]
		,[ProductID],[SpecialOfferID],[UnitPrice]
		,[UnitPriceDiscount],[LineTotal],[rowguid],[ModifiedDate]
FROM [Sales].[SalesOrderDetail]
GO 100

-- Performance Test
-- Comparing Regular Index with ColumnStore Index
SET STATISTICS IO ON
GO

-- Select Table with regular Index
SELECT ProductID, SUM(UnitPrice) SumUnitPrice, AVG(UnitPrice) AvgUnitPrice,
SUM(OrderQty) SumOrderQty, AVG(OrderQty) AvgOrderQty
FROM [Sales].[ColSalesOrderDetail]
GROUP BY ProductID
ORDER BY ProductID
GO

-- Table 'ColSalesOrderDetail'. Scan count 1, logical reads 342261, physical reads 0, read-ahead reads 0.
-- Create ColumnStore Index
CREATE NONCLUSTERED 
	COLUMNSTORE INDEX [IX_ColSalesOrderDetail_ColumnStore]
ON [Sales].[ColSalesOrderDetail]
(UnitPrice, OrderQty, ProductID)
GO

-- Select Table with Columnstore Index
SELECT ProductID, SUM(UnitPrice) SumUnitPrice, AVG(UnitPrice) AvgUnitPrice,
SUM(OrderQty) SumOrderQty, AVG(OrderQty) AvgOrderQty
FROM [Sales].[ColSalesOrderDetail]
GROUP BY ProductID
ORDER BY ProductID
GO

-- Cleanup
DROP TABLE [Sales].[ColSalesOrderDetail]
GO
-- Cleanup
DROP INDEX [IX_MySalesOrderDetail_ColumnStore] ON [dbo].[MySalesOrderDetail]
GO
TRUNCATE TABLE dbo.MySalesOrderDetail
GO
