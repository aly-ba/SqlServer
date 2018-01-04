USE [Credit];
GO

-- Introduce a member_no skew
UPDATE TOP (200000)
        dbo.[charge]
SET     [member_no] = 10000;
GO

CREATE PROCEDURE [dbo].[pr_providerreport] @member_no INT
AS 
SELECT  [charge].[charge_no],
        [charge].[provider_no],
        [charge].[category_no],
        [charge].[charge_dt],
        [charge].[charge_amt],
        [charge].[charge_code],
        [category].[category_desc]
FROM    [dbo].[charge] AS [charge]
INNER JOIN [dbo].[category] AS [category]
        ON [charge].[category_no] = [category].[category_no]
WHERE   [charge].[member_no] = @member_no;
GO

-- What is the member distribution?
SELECT  [result_set].[member_no],
        COUNT(*) AS [member_count]
FROM    (SELECT [charge].[charge_no],
                [charge].[provider_no],
                [charge].[category_no],
                [charge].[charge_dt],
                [charge].[charge_amt],
                [charge].[charge_code],
                [charge].[member_no],
                [category].[category_desc]
         FROM   [dbo].[charge] AS [charge]
         INNER JOIN [dbo].[category] AS [category]
                ON [charge].[category_no] = [category].[category_no]) AS [result_set]
GROUP BY [result_set].[member_no]
ORDER BY [member_count];

-- Clear cache
DBCC FREEPROCCACHE;

-- Show actual plan
EXECUTE [dbo].[pr_providerreport] @member_no = 1065;
GO

EXECUTE [dbo].[pr_providerreport] @member_no = 10000;
GO


-- Clear cache
DBCC FREEPROCCACHE;

-- Show actual plan
EXECUTE [dbo].[pr_providerreport] @member_no = 10000;
GO

EXECUTE [dbo].[pr_providerreport] @member_no = 1065;
GO