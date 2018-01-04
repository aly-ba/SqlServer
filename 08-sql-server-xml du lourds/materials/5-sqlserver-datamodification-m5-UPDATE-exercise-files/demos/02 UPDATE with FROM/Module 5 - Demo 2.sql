-- Module 5, Demo 2
-- UPDATE with FROM

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- Start with understanding which rows will be impacted
SELECT  [p].[BusinessEntityID] ,
        [p].[EmailPromotion]
FROM    [Person].[Person] AS [p]
        INNER JOIN [Person].[BusinessEntityAddress] AS [bea]
        ON bea.[BusinessEntityID] = p.[BusinessEntityID]
        INNER JOIN [Person].[Address] AS [a]
        ON a.[AddressID] = bea.[AddressID]
WHERE   [a].[City] = 'Darmstadt';


-- UPDATE with FROM
UPDATE  [p]
SET     [EmailPromotion] = 2
FROM    [Person].[Person] AS [p]
        INNER JOIN [Person].[BusinessEntityAddress] AS [bea]
        ON bea.[BusinessEntityID] = p.[BusinessEntityID]
        INNER JOIN [Person].[Address] AS [a]
        ON a.[AddressID] = bea.[AddressID]
WHERE   [a].[City] = 'Darmstadt';

-- Validate changes
SELECT  [p].[BusinessEntityID] ,
        [p].[EmailPromotion]
FROM    [Person].[Person] AS [p]
        INNER JOIN [Person].[BusinessEntityAddress] AS [bea]
        ON bea.[BusinessEntityID] = p.[BusinessEntityID]
        INNER JOIN [Person].[Address] AS [a]
        ON a.[AddressID] = bea.[AddressID]
WHERE   [a].[City] = 'Darmstadt';
