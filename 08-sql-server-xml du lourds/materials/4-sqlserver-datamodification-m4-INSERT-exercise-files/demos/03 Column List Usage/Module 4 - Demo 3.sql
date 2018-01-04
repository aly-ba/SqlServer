-- Module 4, Demo 2
-- Column List

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- Create a new version of the [Production].[ProductCategory] table
CREATE TABLE [Production].[ProductCategoryV2]
    (
      [ProductCategoryID] [int] NOT NULL ,
      [Name] [dbo].[Name] NOT NULL ,
      [rowguid] [uniqueidentifier] NOT NULL ,
      [ModifiedDate] [datetime] NOT NULL
    )
ON  [PRIMARY];
GO

-- Will this work?
INSERT  INTO [Production].[ProductCategoryV2]
VALUES  ( N'Appliances' );
GO

-- What about this?
INSERT  INTO [Production].[ProductCategoryV2]
VALUES  ( 1, N'Appliances', NEWID(), GETDATE() );
GO

SELECT  [ProductCategoryID] ,
        [Name] ,
        [rowguid] ,
        [ModifiedDate] ,
        [Enabled]
FROM    [Production].[ProductCategoryV2];
GO

-- Now let's modify the original table definition
ALTER TABLE [Production].[ProductCategoryV2]
ADD [Enabled] BIT NULL;
GO

-- Now will this work?
INSERT  INTO [Production].[ProductCategoryV2]
VALUES  ( 1, N'E-Books', NEWID(), GETDATE() );
GO

-- And this?
INSERT  INTO [Production].[ProductCategoryV2]
VALUES  ( 1, N'E-Books', NEWID(), GETDATE(), 1 );
GO

SELECT  [ProductCategoryID] ,
        [Name] ,
        [rowguid] ,
        [ModifiedDate] ,
        [Enabled]
FROM    [Production].[ProductCategoryV2];
GO

-- Best practice? Reference your columns
-- Switching to our original table
EXEC sys.sp_help '[Production].[ProductCategory]';
GO

INSERT INTO [Production].[ProductCategory]
           ([Name])
     VALUES
           (N'Music');
GO

-- Cleanup
DROP TABLE [Production].[ProductCategoryV2];
GO
