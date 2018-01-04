-- Demo: Module 2, Demo 1
-- SSMS INSERT demo

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- New row in [HumanResources].[Department]
INSERT  INTO [HumanResources].[Department]
        ( [Name], [GroupName] )
VALUES  ( N'Copy Editing', N'Publications' );
GO

-- Check for the new row
SELECT  [DepartmentID] ,
        [Name] ,
        [GroupName] ,
        [ModifiedDate]
FROM [HumanResources].[Department]
WHERE [Name] = N'Copy Editing';
GO