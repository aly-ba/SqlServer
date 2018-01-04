-- Module 5, Demo 4
-- Updating with Sub-Query Values

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- What is the minimum list price for a specific product?
SELECT  MIN([ListPrice]) AS MinListPrice
FROM    [Production].[ProductListPriceHistory]
WHERE   [ProductID] = 707;
GO

-- What is the current list price of another product
SELECT  [ListPrice]
FROM    [Production].[ProductListPriceHistory]
WHERE   [ProductID] = 708
        AND [EndDate] IS NULL;
GO

-- Update product 708 to have 707's minimum price
-- What is the current list price of another product
UPDATE  [Production].[ProductListPriceHistory]
SET     [ListPrice] = ( SELECT  MIN([ListPrice])
                        FROM    [Production].[ProductListPriceHistory]
                        WHERE   [ProductID] = 707
                      )
WHERE   [ProductID] = 708
        AND [EndDate] IS NULL;
GO

-- Validate both match
SELECT  MIN([ListPrice]) AS MinListPrice
FROM    [Production].[ProductListPriceHistory]
WHERE   [ProductID] = 707;
GO

SELECT  [ListPrice]
FROM    [Production].[ProductListPriceHistory]
WHERE   [ProductID] = 708
        AND [EndDate] IS NULL;
GO

-- Will this work?
UPDATE  [Production].[ProductListPriceHistory]
SET     [ListPrice] = ( SELECT  [ListPrice]
                        FROM    [Production].[ProductListPriceHistory]
                        WHERE   [ProductID] = 707
                      )
WHERE   [ProductID] = 708
        AND [EndDate] IS NULL;
GO