-- Module 5, Demo 6
-- Updating Views

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- Check the definition of the view
EXEC sys.sp_helptext '[Sales].[vSalesPerson]';
GO

-- "Before" state
SELECT  [JobTitle]
FROM    [Sales].[vSalesPerson]
WHERE   [BusinessEntityID] = 283;
GO

-- Modify the value
UPDATE  [Sales].[vSalesPerson]
SET     [JobTitle] = 'Senior Sales Representative'
WHERE   [BusinessEntityID] = 283;
GO

-- "After" state
SELECT  [JobTitle]
FROM    [Sales].[vSalesPerson]
WHERE   [BusinessEntityID] = 283;
GO

-- Will this work?
UPDATE  [Sales].[vSalesPerson]
SET     [JobTitle] = 'Senior Sales Representative' ,
        [SalesQuota] = 1000000
WHERE   [BusinessEntityID] = 283;
GO