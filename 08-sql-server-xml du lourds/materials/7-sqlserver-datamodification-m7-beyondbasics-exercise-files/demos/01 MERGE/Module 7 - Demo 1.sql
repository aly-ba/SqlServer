-- Module 7, Demo 1
-- MERGE

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- Let's create a new staging table
SELECT  [TransactionID] ,
        [ProductID] ,
        [ReferenceOrderID] ,
        [ReferenceOrderLineID] ,
        [TransactionDate] ,
        [TransactionType] ,
        [Quantity] ,
        [ActualCost] ,
        [ModifiedDate]
INTO    [Production].[TransactionHistoryStaging]
FROM    [Production].[TransactionHistory];
GO

-- Create some variations in staging that must
-- eventually be reflected in the "live" version
DELETE  [Production].[TransactionHistoryStaging]
WHERE   [TransactionID] BETWEEN 100000 AND 100004;
GO

UPDATE  [Production].[TransactionHistoryStaging]
SET     [Quantity] = 10 ,
        [ModifiedDate] = GETDATE()
WHERE   [TransactionID] = 100019;
GO

INSERT  INTO [Production].[TransactionHistoryStaging]
        ( [ProductID] ,
          [ReferenceOrderID] ,
          [ReferenceOrderLineID] ,
          [TransactionDate] ,
          [TransactionType] ,
          [Quantity] ,
          [ActualCost] ,
          [ModifiedDate]
        )
VALUES  ( 328 ,
          72592 ,
          1 ,
          '2012-09-04 14:40:33.040' ,
          N'W' ,
          99 ,
          0.21 ,
          GETDATE()
        );
GO


-- Now perform I/U/D on [Production].[TransactionHistory]
-- based on [Production].[TransactionHistoryStaging]
MERGE INTO [Production].[TransactionHistory] AS [t]
    USING [Production].[TransactionHistoryStaging] AS [s]
    ON [t].[TransactionID] = [s].TransactionID
    WHEN MATCHED AND 
	( [t].[Quantity] <> [s].[Quantity] )
        THEN
	UPDATE
          SET
            [t].[Quantity] = [s].[Quantity] ,
            [t].[ModifiedDate] = [s].[ModifiedDate]
    WHEN NOT MATCHED BY TARGET 
        THEN
INSERT  (
          [ProductID] ,
          [ReferenceOrderID] ,
          [ReferenceOrderLineID] ,
          [TransactionDate] ,
          [TransactionType] ,
          [Quantity] ,
          [ActualCost] ,
          [ModifiedDate]
        ) VALUES
        ( [s].[ProductID] ,
          [s].[ReferenceOrderID] ,
          [s].[ReferenceOrderLineID] ,
          [s].[TransactionDate] ,
          [s].[TransactionType] ,
          [s].[Quantity] ,
          [s].[ActualCost] ,
          [s].[ModifiedDate]
        )
    WHEN NOT MATCHED BY SOURCE 
        THEN
DELETE;
GO

-- Where the rows removed?
SELECT  COUNT(*) AS [rowcount]
FROM    [Production].[TransactionHistory]
WHERE   [TransactionID] BETWEEN 100000 AND 100004;
GO

-- Was the row updated to Quantity "10"?
SELECT  [Quantity] ,
        [ModifiedDate]
FROM    [Production].[TransactionHistory]
WHERE   [TransactionID] = 100019;
GO

-- Was the new row inserted?
SELECT  [ModifiedDate]
FROM    [Production].[TransactionHistory]
WHERE   [TransactionID] = 213443;

-- Another method for comparing table contents
SELECT  [TransactionID] ,
        [ProductID] ,
        [ReferenceOrderID] ,
        [ReferenceOrderLineID] ,
        [TransactionDate] ,
        [TransactionType] ,
        [Quantity] ,
        [ActualCost] ,
        [ModifiedDate]
FROM    [Production].[TransactionHistory]
EXCEPT
SELECT  [TransactionID] ,
        [ProductID] ,
        [ReferenceOrderID] ,
        [ReferenceOrderLineID] ,
        [TransactionDate] ,
        [TransactionType] ,
        [Quantity] ,
        [ActualCost] ,
        [ModifiedDate]
FROM    [Production].[TransactionHistoryStaging];
GO

SELECT  [TransactionID] ,
        [ProductID] ,
        [ReferenceOrderID] ,
        [ReferenceOrderLineID] ,
        [TransactionDate] ,
        [TransactionType] ,
        [Quantity] ,
        [ActualCost] ,
        [ModifiedDate]
FROM    [Production].[TransactionHistoryStaging]
EXCEPT
SELECT  [TransactionID] ,
        [ProductID] ,
        [ReferenceOrderID] ,
        [ReferenceOrderLineID] ,
        [TransactionDate] ,
        [TransactionType] ,
        [Quantity] ,
        [ActualCost] ,
        [ModifiedDate]
FROM    [Production].[TransactionHistory];
GO

SELECT  [TransactionID] ,
        [ProductID] ,
        [ReferenceOrderID] ,
        [ReferenceOrderLineID] ,
        [TransactionDate] ,
        [TransactionType] ,
        [Quantity] ,
        [ActualCost] ,
        [ModifiedDate]
FROM    [Production].[TransactionHistoryStaging]
INTERSECT
SELECT  [TransactionID] ,
        [ProductID] ,
        [ReferenceOrderID] ,
        [ReferenceOrderLineID] ,
        [TransactionDate] ,
        [TransactionType] ,
        [Quantity] ,
        [ActualCost] ,
        [ModifiedDate]
FROM    [Production].[TransactionHistory];
GO


