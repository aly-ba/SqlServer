-- Module 7, Demo 3
-- Updating Large-Value Data Types

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- Table schema of [Production].[Document]
EXEC [sys].[sp_help] '[Production].[Document]';
GO

-- nvarchar(max) data type that we'll be modifying
SELECT [DocumentSummary]
FROM [Production].[Document]
WHERE [DocumentNode] = 0x7BC0;
GO

-- Add description to end of current text
UPDATE [Production].[Document]
SET [DocumentSummary].WRITE ('2013 update pending.',NULL, NULL)
WHERE [DocumentNode] = 0x7BC0;
GO

-- After validation
SELECT [DocumentSummary]
FROM [Production].[Document]
WHERE [DocumentNode] = 0x7BC0;
GO

-- Use offset and length
UPDATE [Production].[Document]
SET [DocumentSummary].WRITE ('Pending review! ', 0, 0)
WHERE [DocumentNode] = 0x7BC0;
GO

-- After validation
SELECT [DocumentSummary]
FROM [Production].[Document]
WHERE [DocumentNode] = 0x7BC0;
GO

-- Use offset and length
UPDATE [Production].[Document]
SET [DocumentSummary].WRITE ('August ', 8, 0)
WHERE [DocumentNode] = 0x7BC0;
GO

-- After validation
SELECT [DocumentSummary]
FROM [Production].[Document]
WHERE [DocumentNode] = 0x7BC0;
GO