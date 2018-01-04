-- Module 7, Demo 5
-- OUTPUT Clause

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- INSERT with OUTPUT
INSERT  INTO [Production].[UnitMeasure]
        ( [UnitMeasureCode], [Name] )
OUTPUT  INSERTED.[UnitMeasureCode], INSERTED.[Name], INSERTED.[ModifiedDate]
VALUES  ( N'apc', N'attoparsec' );
GO

-- DELETE with OUTPUT and table variable
DECLARE @DeletedUnitMeasure TABLE
    (
      [UnitMeasureCode] NCHAR(3) ,
      [Name] NVARCHAR(50)
    )

DELETE  FROM [Production].[UnitMeasure]
OUTPUT  DELETED.[UnitMeasureCode] ,
        DELETED.[Name]
        INTO @DeletedUnitMeasure
WHERE   [UnitMeasureCode] = N'apc';

SELECT  [UnitMeasureCode] ,
        [Name]
FROM    @DeletedUnitMeasure;
GO

-- UPDATE with OUTPUT
UPDATE [Production].[UnitMeasure]
   SET [Name] = N'Box'
OUTPUT INSERTED.[Name] AS [NewName],
DELETED.[Name] AS [OldName]
 WHERE [UnitMeasureCode] =N'BOX';
GO