-- Module 6, Demo 2
-- WHERE and FROM Clause with DELETE

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- Validate which rows we are deleting
SELECT  [bec].[BusinessEntityID] ,
        [s].[Name]
FROM    [Person].[BusinessEntityContact] AS [bec]
        INNER JOIN [Sales].[Store] AS [s]
        ON [bec].[BusinessEntityID] = [s].[BusinessEntityID]
WHERE   [s].[Name] IN ( N'Clamps & Brackets Co.', N'Fitness Toys' );
GO

-- Delete rows
DELETE  [bec]
FROM    [Person].[BusinessEntityContact] AS [bec]
        INNER JOIN [Sales].[Store] AS [s]
        ON [bec].[BusinessEntityID] = [s].[BusinessEntityID]
WHERE   [s].[Name] IN ( N'Clamps & Brackets Co.', N'Fitness Toys' );
GO

-- Validate deletion
SELECT  [bec].[BusinessEntityID] ,
        [s].[Name]
FROM    [Person].[BusinessEntityContact] AS [bec]
        INNER JOIN [Sales].[Store] AS [s]
        ON [bec].[BusinessEntityID] = [s].[BusinessEntityID]
WHERE   [s].[Name] IN ( N'Clamps & Brackets Co.', N'Fitness Toys' );
GO

-- All other rows
SELECT  [bec].[BusinessEntityID] ,
        [s].[Name]
FROM    [Person].[BusinessEntityContact] AS [bec]
        INNER JOIN [Sales].[Store] AS [s]
        ON [bec].[BusinessEntityID] = [s].[BusinessEntityID];
GO