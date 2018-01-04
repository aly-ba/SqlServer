USE [Credit];
GO

-- Most often, auto-updates of statistics are good enough
-- BUT - there are exceptions, so manual updates may be necessary

-- Let's use this new index for a simple query
-- Show the actual plan
SELECT [charge_no]
FROM [dbo].[charge]
WHERE [charge_dt] = '1999-06-17 10:49:37.260'
OPTION (RECOMPILE);
GO

-- See auto-generated stats
EXEC sp_helpstats 'charge';
GO

-- What does the histogram look like?
-- What were rows sampled versus total rows?
DBCC SHOW_STATISTICS([charge], [_WA_Sys_00000005_0DAF0CB0]);
GO

-- What if we do a full sampling?
UPDATE STATISTICS dbo.[charge] ([_WA_Sys_00000005_0DAF0CB0]) 
WITH FULLSCAN;
GO

-- What does the histogram look like?
DBCC SHOW_STATISTICS([charge], [_WA_Sys_00000005_0DAF0CB0]);
GO

-- RESAMPLE updates statistics using the most recent sampling
-- What if we do a full sampling?
UPDATE STATISTICS dbo.[charge] ([_WA_Sys_00000005_0DAF0CB0]) 
WITH RESAMPLE;
GO

-- What does the histogram look like?
DBCC SHOW_STATISTICS([charge], [_WA_Sys_00000005_0DAF0CB0]);
GO

-- Updating by a specific sample number (percent or rows allowed)
UPDATE STATISTICS dbo.[charge] ([_WA_Sys_00000005_0DAF0CB0]) 
WITH SAMPLE 20 PERCENT;
GO

-- What does the histogram look like?
DBCC SHOW_STATISTICS([charge], [_WA_Sys_00000005_0DAF0CB0]);
GO

-- Modify table, non-updating update
UPDATE [dbo].[charge]
SET [charge_dt] = [charge_dt];
GO

-- Execute UPDATE STATISTICS against all user-defined and internal tables in the current database
-- sp_updatestats updates only the statistics that require updating...
-- Default sampling example
EXEC sp_updatestats;

-- What does the histogram look like?
DBCC SHOW_STATISTICS([charge], [_WA_Sys_00000005_0DAF0CB0]);
GO