-- Module 5, Demo 3
-- Defaults

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- What is the last modified date?
SELECT  [EmailAddress] ,
        [ModifiedDate]
FROM    [Person].[EmailAddress]
WHERE   [BusinessEntityID] = 18935;

-- Update without designating DEFAULT keyword
UPDATE  [Person].[EmailAddress]
SET     [EmailAddress] = 'chelsea77@adventure-works.com'
WHERE   [BusinessEntityID] = 18935;

-- Did the modified date change?
SELECT  [EmailAddress] ,
        [ModifiedDate]
FROM    [Person].[EmailAddress]
WHERE   [BusinessEntityID] = 18935;

-- Update with DEFAULT keyword
UPDATE  [Person].[EmailAddress]
SET     [EmailAddress] = 'chelsea77@adventure-works.com' ,
        [ModifiedDate] = DEFAULT
WHERE   [BusinessEntityID] = 18935;

-- Did the modified date change?
SELECT  [EmailAddress] ,
        [ModifiedDate]
FROM    [Person].[EmailAddress]
WHERE   [BusinessEntityID] = 18935;