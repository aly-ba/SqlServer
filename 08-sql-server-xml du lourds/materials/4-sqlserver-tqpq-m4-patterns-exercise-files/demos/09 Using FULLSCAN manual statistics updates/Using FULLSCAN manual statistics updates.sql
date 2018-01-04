USE [Credit];
GO

-- Data modifications
UPDATE [dbo].[charge] SET [charge_dt] = DATEADD(day, 15, [charge_dt])
OUTPUT inserted.[charge_no],
       inserted.[charge_dt]
WHERE [charge_no] % 7999 = 0;
GO

-- What are the estimated rows?
SELECT  [charge].[charge_no]
FROM    [dbo].[charge]
WHERE   [charge].[charge_dt] = '1999-10-13 10:44:13.073';
GO

-- Where did the estimate come from? (see AVG_RANGE_ROWS)
DBCC SHOW_STATISTICS([charge], [_WA_Sys_00000005_0DAF0CB0]);
GO

-- Manual update of stats with default sampling
UPDATE STATISTICS [dbo].[charge]([_WA_Sys_00000005_0DAF0CB0]);
GO

DBCC SHOW_STATISTICS([charge], [_WA_Sys_00000005_0DAF0CB0]);
GO

-- What are the estimated rows? 
SELECT  [charge].[charge_no]
FROM    [dbo].[charge]
WHERE   [charge].[charge_dt] = '1999-10-13 10:44:13.073'
OPTION (RECOMPILE);
GO

-- Will FULLSCAN help?
UPDATE STATISTICS [dbo].[charge]([_WA_Sys_00000005_0DAF0CB0])
WITH FULLSCAN;
GO

-- What are the estimated rows? 
SELECT  [charge].[charge_no]
FROM    [dbo].[charge]
WHERE   [charge].[charge_dt] = '1999-10-13 10:44:13.073'
OPTION (RECOMPILE);
GO

DBCC SHOW_STATISTICS([charge], [_WA_Sys_00000005_0DAF0CB0]);
GO



-- Don't forget to restore to the original database...