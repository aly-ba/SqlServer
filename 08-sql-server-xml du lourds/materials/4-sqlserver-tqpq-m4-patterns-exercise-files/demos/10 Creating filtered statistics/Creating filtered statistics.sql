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
WHERE   [charge].[charge_dt] = '1999-07-09 10:44:49.117';
GO

-- Where did the estimate come from? (see AVG_RANGE_ROWS)
DBCC SHOW_STATISTICS([charge], [_WA_Sys_00000005_0DAF0CB0]);
GO

-- Will FULLSCAN help?
UPDATE STATISTICS [dbo].[charge]([_WA_Sys_00000005_0DAF0CB0])
WITH FULLSCAN;
GO

-- What are the estimated rows? 
SELECT  [charge].[charge_no]
FROM    [dbo].[charge]
WHERE   [charge].[charge_dt] = '1999-07-09 10:44:49.117'
OPTION (RECOMPILE);
GO

-- Can we do better?
CREATE STATISTICS [charge_charge_dt_1999_07]
      ON [dbo].[charge] ([charge_dt])
WHERE [charge_dt] >= '1999-07-01 00:00:00.000' AND
	  [charge_dt] < '1999-08-01 00:00:00.000'
WITH FULLSCAN;

DBCC SHOW_STATISTICS([charge], [charge_charge_dt_1999_07]);
GO

-- What are the estimated rows now?
SELECT  [charge].[charge_no]
FROM    [dbo].[charge]
WHERE   [charge].[charge_dt] = '1999-07-09 10:44:49.117'
OPTION (RECOMPILE);
GO


-- Don't forget to restore to the original database...