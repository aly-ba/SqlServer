USE [Credit];
GO

-- What are the estimated rows?
SELECT  [charge].[charge_no]
FROM    [dbo].[charge]
WHERE   [charge].[charge_dt] = '1999-06-17 10:49:37.260';
GO

-- What is the stats object name and column?
SELECT  [s].[object_id],
        [s].[name],
        [s].[auto_created],
        [s].[user_created],
        [s].[no_recompute],
        [s].[has_filter],
        [s].[filter_definition],
        COL_NAME([s].[object_id], [sc].[column_id]) AS [col_name]
FROM    [sys].[stats] AS s
INNER JOIN [sys].[stats_columns] AS [sc]
        ON [s].[stats_id] = [sc].[stats_id] AND
           [s].[object_id] = [sc].[object_id]
WHERE   [s].[object_id] = OBJECT_ID('charge');

-- Examine the stats 
SELECT  [s].[name],
        [p].[object_id],
        [p].[stats_id],
        [p].[last_updated],
        [p].[rows],
        [p].[rows_sampled],
        [p].[steps],
        [p].[unfiltered_rows],
        [p].[modification_counter]
FROM    [sys].[stats] AS s
CROSS APPLY sys.dm_db_stats_properties
	([s].object_id, [s].stats_id) AS [p]
WHERE   [s].[object_id] = OBJECT_ID('charge');

-- Modify charge_dt values
UPDATE TOP (10)
        [dbo].[charge]
SET     [charge].[charge_dt] = '1999-06-17 10:49:37.260'
WHERE   [charge_no] < 100;
GO

-- Examine the stats 
SELECT  [s].[name],
        [p].[object_id],
        [p].[stats_id],
        [p].[last_updated],
        [p].[rows],
        [p].[rows_sampled],
        [p].[steps],
        [p].[unfiltered_rows],
        [p].[modification_counter]
FROM    [sys].[stats] AS s
CROSS APPLY sys.dm_db_stats_properties([s].object_id, [s].stats_id) AS [p]
WHERE   [s].[object_id] = OBJECT_ID('charge');
