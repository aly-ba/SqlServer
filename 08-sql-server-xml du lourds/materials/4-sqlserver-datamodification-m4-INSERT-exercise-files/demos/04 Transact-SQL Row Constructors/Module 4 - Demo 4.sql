-- Module 4, Demo 3
-- Transact-SQL Row Constructors

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

SELECT  [CultureID] ,
        [Name] ,
        [ModifiedDate]
FROM    [Production].[Culture];
GO

-- Insert three rows in one statement
INSERT INTO [Production].[Culture]
           ([CultureID]
           ,[Name]
           ,[ModifiedDate])
     VALUES
           (N'af', N'Afrikaans', DEFAULT),
           (N'hy', N'Armenian', DEFAULT),
		   (N'sd', N'Sindhi', DEFAULT);
GO

SELECT  [CultureID] ,
        [Name] ,
        [ModifiedDate]
FROM    [Production].[Culture]
ORDER BY [ModifiedDate];
GO


-- How many of these rows get inserted?
INSERT INTO [Production].[Culture]
           ([CultureID]
           ,[Name]
           ,[ModifiedDate])
     VALUES
           (N'tg', N'Tajik', DEFAULT),
           (N'hy', N'Armenian', DEFAULT),
		   (N'yi', N'Yiddish', DEFAULT);
GO

SELECT  [CultureID] ,
        [Name] ,
        [ModifiedDate]
FROM    [Production].[Culture]
ORDER BY [ModifiedDate];
GO

-- Not just limited to multiple row inserts
SELECT [CultureID], [Name]
FROM
	(VALUES
           (N'tg', N'Tajik'),
           (N'hy', N'Armenian'),
		   (N'yi', N'Yiddish'))
	AS [Culture] ([CultureID], [Name]);
GO