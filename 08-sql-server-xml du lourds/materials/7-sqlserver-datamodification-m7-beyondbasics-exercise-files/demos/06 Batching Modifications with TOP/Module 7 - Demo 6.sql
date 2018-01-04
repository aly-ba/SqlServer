-- Module 7, Demo 6
-- Batching Modifications with TOP

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- What rows are we looking to modify?
SELECT  [WorkOrderID] ,
        [ProductID] ,
        [OperationSequence] ,
        [LocationID] ,
        [ScheduledStartDate] ,
        [ScheduledEndDate] ,
        [ActualStartDate] ,
        [ActualEndDate] ,
        [ActualResourceHrs] ,
        [PlannedCost] ,
        [ActualCost] ,
        [ModifiedDate]
FROM    [Production].[WorkOrderRouting]
WHERE   [ModifiedDate] < '2012-09-5 00:00:00.000';
GO

-- Enable row count msgs so you can see the batch updates
SET NOCOUNT OFF;
GO

-- Imagine for a much large table, do you want one large UPDATE?
-- Or several small UPDATEs which can be restarted if necessary?
WHILE ( SELECT  COUNT(*)
        FROM    [Production].[WorkOrderRouting]
        WHERE   [ModifiedDate] < '2012-09-5 00:00:00.000'
      ) > 0 
    BEGIN
        UPDATE TOP ( 500 )
                [Production].[WorkOrderRouting]
        SET     [ActualCost] = [ActualCost] * 1.05 ,
                [ModifiedDate] = GETDATE()
        WHERE   [ModifiedDate] < '2012-09-5 00:00:00.000';
    END
GO