USE [Credit];
GO

-- Example query
SELECT [charge_no]
FROM [dbo].[charge]
WHERE [charge_dt] = '1999-06-17 10:49:37.260';

-- What stats exist for this table?
EXEC sp_helpstats 'charge';
GO

-- What does the histogram look like?
DBCC SHOW_STATISTICS([charge], [_WA_Sys_00000005_0DAF0CB0]);
GO

SELECT  [object_id],
        [name],
        [stats_id],
        [auto_created],
        [user_created],
        STATS_DATE(object_id, stats_id) AS [stats_date]
FROM    [sys].[stats]
WHERE   [object_id] = OBJECT_ID('charge');
GO