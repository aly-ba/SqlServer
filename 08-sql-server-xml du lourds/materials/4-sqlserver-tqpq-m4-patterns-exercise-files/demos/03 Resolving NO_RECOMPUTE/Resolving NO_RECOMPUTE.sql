USE [Credit];
GO

-- What indexes already exist for this table?
EXEC sp_helpindex 'charge';
GO

-- Create a new index
CREATE INDEX [charge_charge_dt] ON
[dbo].[charge] ([charge_dt])
WITH (STATISTICS_NORECOMPUTE = ON);
GO

-- Check no_recompute status
SELECT  [object_id],
        [name],
        [stats_id],
        [no_recompute]
FROM [sys].[stats]
WHERE [object_id] = objecT_id('charge');
GO

-- Let's use this new index for a simple query
-- Show the actual plan
SELECT [charge_no]
FROM [dbo].[charge]
WHERE [charge_dt] = '1999-06-17 10:49:37.260';
GO

-- Estimated rows = 32

-- What does the histogram look like?
DBCC SHOW_STATISTICS([charge], [charge_charge_dt]);
GO

-- Let's skew the distribution (be prepared to restore after this demo)
UPDATE [dbo].[charge]
SET [charge_dt] = GETDATE();
GO

-- Is auto-update stats enabled?
SELECT  [name],
        [database_id],
        [is_auto_create_stats_on],
        [is_auto_update_stats_on],
        [is_auto_update_stats_async_on],
        [is_parameterization_forced]
FROM sys.[databases];

-- Let's use this new index for a simple query
-- Show the actual plan
SELECT [charge_no]
FROM [dbo].[charge]
WHERE [charge_dt] = '1999-06-17 10:49:37.260'
OPTION (RECOMPILE);

-- What does the histogram look like?
DBCC SHOW_STATISTICS([charge], [charge_charge_dt]);
GO

-- Let's change the index setting
CREATE NONCLUSTERED INDEX [charge_charge_dt] ON [dbo].[charge]
(
	[charge_dt] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = ON)
ON [PRIMARY]
GO

-- Check no_recompute status
SELECT  [object_id],
        [name],
        [stats_id],
        [no_recompute]
FROM [sys].[stats]
WHERE [object_id] = objecT_id('charge');
GO

-- What does the histogram look like?
DBCC SHOW_STATISTICS([charge], [charge_charge_dt]);
GO

-- Let's update the table again
UPDATE TOP (320500) [dbo].[charge]
SET [charge_dt] = '1999-06-19 10:49:37.260';
GO


UPDATE TOP (32) [dbo].[charge]
SET [charge_dt] = '1999-06-17 10:49:37.260';
GO

-- Let's use this new index for a simple query
-- Show the actual plan
SELECT [charge_no]
FROM [dbo].[charge]
WHERE [charge_dt] = '1999-06-17 10:49:37.260'
OPTION (RECOMPILE);


-- What does the histogram look like?
DBCC SHOW_STATISTICS([charge], [charge_charge_dt]);
GO

-- What if we do a full sampling?
UPDATE STATISTICS dbo.[charge] ([charge_charge_dt]) 
WITH FULLSCAN;
GO

-- What does the histogram look like?
DBCC SHOW_STATISTICS([charge], [charge_charge_dt]);
GO

-- Now what is the estimate?
SELECT [charge_no]
FROM [dbo].[charge]
WHERE [charge_dt] = '1999-06-17 10:49:37.260'
OPTION (RECOMPILE);

-- Don't forget to restore the database back to it's original form