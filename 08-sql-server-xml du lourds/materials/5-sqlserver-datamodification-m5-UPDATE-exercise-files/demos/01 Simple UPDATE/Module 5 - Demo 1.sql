-- Module 5, Demo 1
-- Simple Update

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- Updating ALL rows (* be careful *)
UPDATE [Production].[Product]
   SET [SellEndDate] = '12/31/2012',
       [ModifiedDate] = GETDATE();
GO

SELECT [ProductID], [SellEndDate], [ModifiedDate]
FROM [Production].[Product];
GO

-- Update rows that meet a specific condition
UPDATE [Production].[Product]
   SET [SellEndDate] = '12/31/2013',
       [ModifiedDate] = GETDATE()
WHERE [ProductID] = 324; 
GO

SELECT [ProductID], [SellEndDate], [ModifiedDate]
FROM [Production].[Product]
WHERE [ProductID] = 324; 
GO

-- Use DEFAULT and NULL
SELECT [SellEndDate], [ModifiedDate]
FROM [Production].[Product]
WHERE [ProductID] = 326;
GO

UPDATE [Production].[Product]
   SET [SellEndDate] = NULL,
       [ModifiedDate] = DEFAULT
WHERE [ProductID] = 326; 
GO

SELECT [SellEndDate], [ModifiedDate]
FROM [Production].[Product]
WHERE [ProductID] = 326;
GO



