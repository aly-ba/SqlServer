-- Module 5, Demo 4
-- Compound Assignment Operators

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- What is the quantity for each row?
SELECT   [ProductID] ,
        [LocationID] ,
        [Shelf] ,
        [Bin] ,
        [Quantity] 
FROM [Production].[ProductInventory]
WHERE [ProductID] = 316;
GO

-- Double the quantity
UPDATE [Production].[ProductInventory]
SET [Quantity] *= 2
WHERE [ProductID] = 316;
GO

-- What is the new quantity for each row?
SELECT   [ProductID] ,
        [LocationID] ,
        [Shelf] ,
        [Bin] ,
        [Quantity] 
FROM [Production].[ProductInventory]
WHERE [ProductID] = 316;
GO