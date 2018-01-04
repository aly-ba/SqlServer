-- Module 7, Demo 2
-- Data Modifications with CTEs

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- The rows we wish to change, using SQL Server 2012's OFFSET and FETCH
SELECT  [WorkOrderID] ,
        [ProductID] ,
        [OperationSequence] ,
        [LocationID] ,
        [ActualResourceHrs] ,
        [PlannedCost] ,
        [ActualCost] ,
        [ModifiedDate]
FROM    [Production].[WorkOrderRouting]
ORDER BY [WorkOrderID] 
	OFFSET 50 ROWS
	FETCH NEXT 5 ROWS ONLY;
GO

-- OFFSET and FETCH can't be specified directly in 
-- INSERT, UPDATE, MERGE, and DELETE statements
UPDATE  [Production].[WorkOrderRouting]
SET     [ActualCost] *= 1.2
ORDER BY [WorkOrderID] 
	OFFSET 50 ROWS
	FETCH NEXT 5 ROWS ONLY;
GO

-- Use a CTE instead
WITH [CTE_WorkOrderRouting]
AS
	(SELECT  [WorkOrderID] ,
			[ProductID] ,
			[OperationSequence] ,
			[LocationID] ,
			[ActualResourceHrs] ,
			[PlannedCost] ,
			[ActualCost] ,
			[ModifiedDate]	
	FROM [Production].[WorkOrderRouting]
	ORDER BY [WorkOrderID] 
	OFFSET 50 ROWS
	FETCH NEXT 5 ROWS ONLY)
UPDATE  [CTE_WorkOrderRouting]
SET     [ActualCost] *= 1.2 ,
        [ModifiedDate] = GETDATE();
GO

-- The rows we wish to change, using SQL Server 2012's OFFSET and FETCH
SELECT  [WorkOrderID] ,
        [ProductID] ,
        [OperationSequence] ,
        [LocationID] ,
        [ActualResourceHrs] ,
        [PlannedCost] ,
        [ActualCost] ,
        [ModifiedDate]
FROM    [Production].[WorkOrderRouting]
ORDER BY [WorkOrderID] 
	OFFSET 50 ROWS
	FETCH NEXT 5 ROWS ONLY;
GO