-- Module 4, Demo 1
-- Basic Row Insert

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

INSERT  INTO [Production].[ProductCategory]
        ( [Name] )
VALUES  ( N'Software' );
GO

-- But what other columns were there?
SELECT  [ProductCategoryID] ,
        [Name] ,
        [rowguid] ,
        [ModifiedDate]
FROM [Production].[ProductCategory]
WHERE [Name] = N'Software';
GO

-- Properties of the [Production].[ProductCategory] table
EXEC sys.sp_help '[Production].[ProductCategory]';
GO
