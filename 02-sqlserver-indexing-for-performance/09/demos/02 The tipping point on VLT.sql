-------------------------------------------------------------------------------
-- "That doesn't happen on a big database..."
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Demo: The tipping point on an even larger table
-------------------------------------------------------------------------------

-- NOTE: This is an "enlarged" version of AdventureWorksDW2008
-- FactInternetSales has 30,923,776 rows
USE [AdventureWorksDW2008_ModifiedSalesKey]; 
GO

-- Review table definition and indexes:
EXEC [sp_help] '[dbo].[factinternetsales]';
GO

-------------------------------------------------------------------------------
-- Let's estimate the tipping point:
-------------------------------------------------------------------------------

-- How many pages are there in this table? 
-- We need to review the leaf level of the CL index (1)
SELECT [index_depth] AS [D]
    , [index_level] AS [L]
    , [page_count] AS [Pages]
	, [page_count]/4 AS [Selective]   
	, [page_count]/3 AS [SCAN]        
FROM [sys].[dm_db_index_physical_stats]
    (DB_ID (N'AdventureWorksDW2008_ModifiedSalesKey')					        
    , OBJECT_ID (N'AdventureWorksDW2008_ModifiedSalesKey.dbo.factinternetsales')
    , 1												                   
    , NULL											                   
    , 'DETAILED')									                   
WHERE [index_level] = 0;									
GO

-- Verify the number of pages in the leaf level of the clustered index for the
-- factinternetsales table (index_id = 1)

-- 475,752 pages / 30,923,776 rows
-- Average number of rows / page:
SELECT 30923776.0 / 475752;

-- Selective enough:
SELECT 475752.0 / 4; -- = 118,938 
SELECT 118938.0 / 30923776 * 100; -- = (0.3846% of the table)

-- NOT Selective enough:
SELECT 475752.0 / 3; -- = 158,584
SELECT 158584.0 / 30923776 * 100; -- = (0.5128% of the table)
GO

-------------------------------------------------------------------------------
-- Tipping point: Sum of Sales by Customer
-------------------------------------------------------------------------------

-- Use these to get some insight into what's happening:
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- NOTE: I/Os alone are not the ONLY way to understand
-- what's going on. We'll add graphical showplan as well.
-- Use Query, Include Actual Execution Plan

-- The tipping point for lookups of customer sales
-- Scenario 1-----------------------------------
SELECT [c].[CustomerKey], [c].[LastName], sum([s].[SalesAmount])
FROM [dbo].[FactInternetSales] AS [s]
	INNER JOIN [dbo].[DimCustomer] AS [c]
		ON [s].[CustomerKey] = [c].[CustomerKey]
WHERE [c].[CustomerKey] < 11043 
GROUP BY [c].[CustomerKey], [c].[LastName]
OPTION (MAXDOP 1);
GO  -- Estimated rows: 138,695
	-- Actual rows: 134,144

SELECT [c].[CustomerKey], [c].[LastName], sum([s].[SalesAmount])
FROM [dbo].[FactInternetSales] AS [s]
	INNER JOIN [dbo].[DimCustomer] AS [c]
		ON [s].[CustomerKey] = [c].[CustomerKey]
WHERE [c].[CustomerKey] < 11044 
GROUP BY [c].[CustomerKey], [c].[LastName]
OPTION (MAXDOP 1);
GO	-- Estimated rows: 141,505
	-- Actual rows: 135,680

SELECT 140000 / 30923776.00 * 100; -- = 0.4527 % of the table
GO
-- Scenario 1-----------------------------------


-- If we actually look at time - are they RIGHT?
-- I bet we can do better!
-- Scenario 2-----------------------------------
SELECT [c].[CustomerKey], [c].[LastName], sum([s].[SalesAmount])
FROM [dbo].[FactInternetSales] AS [s]
	INNER JOIN [dbo].[DimCustomer] AS [c]
		ON [s].[CustomerKey] = [c].[CustomerKey]
WHERE [c].[CustomerKey] < 11044 
GROUP BY [c].[CustomerKey], [c].[LastName]
OPTION (MAXDOP 1);
GO

SELECT [c].[CustomerKey], [c].[LastName], sum([s].[SalesAmount])
FROM [dbo].[FactInternetSales] AS [s] WITH (FORCESEEK)
	INNER JOIN [dbo].[DimCustomer] AS [c]
		ON [s].[CustomerKey] = [c].[CustomerKey]
WHERE [c].[CustomerKey] < 11044
GROUP BY [c].[CustomerKey], [c].[LastName]
OPTION (MAXDOP 1);
GO
-- Scenario 2-----------------------------------


-- So maybe this should be a general rule?
-- Scenario 3-----------------------------------
SELECT [c].[CustomerKey], [c].[LastName], sum([s].[SalesAmount])
FROM [dbo].[FactInternetSales] AS [s]
	INNER JOIN [dbo].[DimCustomer] AS [c]
		ON [s].[CustomerKey] = [c].[CustomerKey]
WHERE [c].[CustomerKey] < 15000
GROUP BY [c].[CustomerKey], [c].[LastName]
OPTION (MAXDOP 1);
GO

SELECT [c].[CustomerKey], [c].[LastName], sum([s].[SalesAmount])
FROM [dbo].[FactInternetSales] AS [s] WITH (FORCESEEK)
	INNER JOIN [dbo].[DimCustomer] AS [c]
		ON [s].[CustomerKey] = [c].[CustomerKey]
WHERE [c].[CustomerKey] < 15000
GROUP BY [c].[CustomerKey], [c].[LastName]
OPTION (MAXDOP 1);
GO
-- Scenario 3-----------------------------------


-- What if we let SQL Server use multiple processors/cores
-- Scenario 4-----------------------------------
SELECT [c].[CustomerKey], [c].[LastName], sum([s].[SalesAmount])
FROM [dbo].[FactInternetSales] AS [s]
	INNER JOIN [dbo].[DimCustomer] AS [c]
		ON [s].[CustomerKey] = [c].[CustomerKey]
WHERE [c].[CustomerKey] < 11038 
GROUP BY [c].[CustomerKey], [c].[LastName];
GO	-- Estimated rows: 124,644
	-- Actual rows: 123,392

SELECT [c].[CustomerKey], [c].[LastName], sum([s].[SalesAmount])
FROM [dbo].[FactInternetSales] AS [s] 
	INNER JOIN [dbo].[DimCustomer] AS [c]
		ON [s].[CustomerKey] = [c].[CustomerKey]
WHERE [c].[CustomerKey] < 11039 
GROUP BY [c].[CustomerKey], [c].[LastName];
GO	-- Estimated rows: 127,454
	-- Actual rows: 124,928

SELECT 126000 / 30923776.00 * 100; -- = 0.4075 % of the table
GO
-- Scenario 4-----------------------------------
