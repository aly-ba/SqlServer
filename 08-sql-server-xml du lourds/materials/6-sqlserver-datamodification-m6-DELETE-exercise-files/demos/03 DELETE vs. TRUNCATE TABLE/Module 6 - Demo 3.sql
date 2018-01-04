-- Module 6, Demo 3
-- DELETE vs. TRUNCATE TABLE

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- Create two new tables based on the same source table
SELECT  [PurchaseOrderID] ,
        [PurchaseOrderDetailID] ,
        [DueDate] ,
        [OrderQty] ,
        [ProductID] ,
        [UnitPrice] ,
        [LineTotal] ,
        [ReceivedQty] ,
        [RejectedQty] ,
        [StockedQty] ,
        [ModifiedDate]
INTO    [Purchasing].[PurchaseOrderDetailV2]
FROM    [Purchasing].[PurchaseOrderDetail];
GO

SELECT  [PurchaseOrderID] ,
        [PurchaseOrderDetailID] ,
        [DueDate] ,
        [OrderQty] ,
        [ProductID] ,
        [UnitPrice] ,
        [LineTotal] ,
        [ReceivedQty] ,
        [RejectedQty] ,
        [StockedQty] ,
        [ModifiedDate]
INTO    [Purchasing].[PurchaseOrderDetailV3]
FROM    [Purchasing].[PurchaseOrderDetail];
GO

-- Validate row counts
SELECT  COUNT(*) AS [rowcount]
FROM    [Purchasing].[PurchaseOrderDetailV3];
GO

SELECT  COUNT(*) AS [rowcount]
FROM    [Purchasing].[PurchaseOrderDetailV2];
GO

-- What is the recovery model of my Adventureworks2012 database?
SELECT  [recovery_model_desc]
FROM    sys.databases
WHERE   name = N'AdventureWorks2012';
GO

-- Assumes you're doing this on a test environment
-- Writes dirty pages (in buffer cache and modified) for the 
-- current database to disk
CHECKPOINT;
GO

-- Undocumented function to read log records
SELECT  [Current LSN] ,
        [Operation] ,
        [Context] ,
        [Transaction ID] ,
        [Log Record Fixed Length] ,
        [Log Record Length]
FROM    ::
        fn_dblog(NULL, NULL); 
GO

-- Deleting all records from [Purchasing].[PurchaseOrderDetailV2]
DELETE  [Purchasing].[PurchaseOrderDetailV2];
GO

-- How many records?
SELECT  [Current LSN] ,
        [Operation] ,
        [Context] ,
        [Transaction ID] ,
        [Log Record Fixed Length] ,
        [Log Record Length]
FROM    ::
        fn_dblog(NULL, NULL);
GO

-- Assumes you're doing this on a test environment
-- Writes dirty pages (in buffer cache and modified) for the 
-- current database to disk
CHECKPOINT;
GO

-- How many records?
SELECT  [Current LSN] ,
        [Operation] ,
        [Context] ,
        [Transaction ID] ,
        [Log Record Fixed Length] ,
        [Log Record Length]
FROM    ::
        fn_dblog(NULL, NULL);
GO

TRUNCATE TABLE [Purchasing].[PurchaseOrderDetailV3];
GO

-- How many records?
SELECT  [Current LSN] ,
        [Operation] ,
        [Context] ,
        [Transaction ID] ,
        [Log Record Fixed Length] ,
        [Log Record Length]
FROM    ::
        fn_dblog(NULL, NULL);
GO