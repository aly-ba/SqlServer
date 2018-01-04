-- Demo: Module 2, Demo 2
-- SSDT UPDATE / DELETE demo

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- New row in [HumanResources].[Department]
UPDATE [HumanResources].[Department]
SET [Department].[GroupName] = N'Marketing'
WHERE [Department].[Name] = N'Copy Editing';
GO

-- Check modification
SELECT  [Department].[DepartmentID] ,
        [Department].[Name] ,
        [Department].[GroupName] ,
        [Department].[ModifiedDate]
FROM [HumanResources].[Department]
WHERE [Department].[Name] = N'Copy Editing';
GO

-- Delete row
DELETE FROM [HumanResources].[Department]
WHERE [Department].[Name] = N'Copy Editing';
GO

