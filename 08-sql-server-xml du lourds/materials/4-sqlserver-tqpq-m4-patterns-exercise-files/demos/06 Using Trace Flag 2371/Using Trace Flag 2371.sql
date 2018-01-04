USE [Credit];
GO

-- Default auto-update algorithm example

-- Create a new demo table (1.6 million rows)
SELECT  [charge_no],
        [member_no],
        [provider_no],
        [category_no],
        [charge_dt],
        [charge_amt],
        [statement_no],
        [charge_code]
INTO    [dbo].[charge_demo]
FROM    [dbo].[charge];


-- Sample query
SELECT  [charge_no]
FROM    [dbo].[charge_Demo]
WHERE   [charge_dt] = '1999-06-17 10:49:37.260';
GO

-- See auto-generated stats
EXEC sp_helpstats 'charge_demo';
GO

-- Examine the stats
DBCC SHOW_STATISTICS([charge_demo], [_WA_Sys_00000005_5CD6CB2B]);
GO

-- Create an XEvent session tracking auto-updates

-- Add 10% more (160,000)
INSERT  [dbo].[charge_Demo]
        ([member_no],
         [provider_no],
         [category_no],
         [charge_dt],
         [charge_amt],
         [statement_no],
         [charge_code])
        SELECT TOP (160000)
                [member_no],
                [provider_no],
                [category_no],
                [charge_dt],
                [charge_amt],
                [statement_no],
                [charge_code]
        FROM    [dbo].[charge];

-- Sample query
SELECT  [charge_no]
FROM    [dbo].[charge_Demo]
WHERE   [charge_dt] = '1999-06-17 10:49:37.260';
GO

-- Add 10% more + 500 (160,000)
INSERT  [dbo].[charge_Demo]
        ([member_no],
         [provider_no],
         [category_no],
         [charge_dt],
         [charge_amt],
         [statement_no],
         [charge_code])
        SELECT TOP (160500)
                [member_no],
                [provider_no],
                [category_no],
                [charge_dt],
                [charge_amt],
                [statement_no],
                [charge_code]
        FROM    [dbo].[charge];

-- Sample query
SELECT  [charge_no]
FROM    [dbo].[charge_Demo]
WHERE   [charge_dt] = '1999-06-17 10:49:37.260';
GO

-- Now let's compare with trace flag 2371 
DBCC TRACEON(2371, -1);
GO

DBCC TRACESTATUS;
GO

-- Create a new demo table (1.6 million rows)
SELECT  [charge_no],
        [member_no],
        [provider_no],
        [category_no],
        [charge_dt],
        [charge_amt],
        [statement_no],
        [charge_code]
INTO    [dbo].[charge_demo_tf]
FROM    [dbo].[charge];


-- Sample query
SELECT  [charge_no]
FROM    [dbo].[charge_Demo_tf]
WHERE   [charge_dt] = '1999-06-17 10:49:37.260';
GO

SELECT OBJECT_ID('charge_Demo_tf')

-- See auto-generated stats
EXEC sp_helpstats 'charge_demo_tf';
GO

-- Add 10% more + 500 (160,000)
INSERT  [dbo].[charge_Demo_tf]
        ([member_no],
         [provider_no],
         [category_no],
         [charge_dt],
         [charge_amt],
         [statement_no],
         [charge_code])
        SELECT TOP (160000)
                [member_no],
                [provider_no],
                [category_no],
                [charge_dt],
                [charge_amt],
                [statement_no],
                [charge_code]
        FROM    [dbo].[charge];

-- Sample query
SELECT  [charge_no]
FROM    [dbo].[charge_Demo_tf]
WHERE   [charge_dt] = '1999-06-17 10:49:37.260';
GO


-- Add more
INSERT  [dbo].[charge_Demo_tf]
        ([member_no],
         [provider_no],
         [category_no],
         [charge_dt],
         [charge_amt],
         [statement_no],
         [charge_code])
        SELECT TOP (160000)
                [member_no],
                [provider_no],
                [category_no],
                [charge_dt],
                [charge_amt],
                [statement_no],
                [charge_code]
        FROM    [dbo].[charge];

-- Sample query
SELECT  [charge_no]
FROM    [dbo].[charge_Demo_tf]
WHERE   [charge_dt] = '1999-06-17 10:49:37.260';
GO

-- Add 80000 rows
INSERT  [dbo].[charge_Demo_tf]
        ([member_no],
         [provider_no],
         [category_no],
         [charge_dt],
         [charge_amt],
         [statement_no],
         [charge_code])
        SELECT TOP (80000)
                [member_no],
                [provider_no],
                [category_no],
                [charge_dt],
                [charge_amt],
                [statement_no],
                [charge_code]
        FROM    [dbo].[charge];

-- Sample query
SELECT  [charge_no]
FROM    [dbo].[charge_Demo_tf]
WHERE   [charge_dt] = '1999-06-17 10:49:37.260';
GO

-- Cleanup
-- Now let's compare with trace flag 2371 
DBCC TRACEOFF(2371, -1);
GO

DBCC TRACESTATUS;
GO

DROP TABLE [dbo].[charge_Demo_tf];
DROP TABLE [dbo].[charge_Demo];
GO
