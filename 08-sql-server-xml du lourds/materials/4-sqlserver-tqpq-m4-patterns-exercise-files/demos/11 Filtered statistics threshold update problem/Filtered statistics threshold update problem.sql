USE [Credit];
GO

CREATE STATISTICS [charge_charge_dt_1999_07]
ON [dbo].[charge] ([charge_dt])
WHERE [charge_dt] >= '1999-09-01 00:00:00.000' AND
[charge_dt] < '1999-09-02 00:00:00.000'
WITH FULLSCAN;

-- How many rows apply to these stats?
SELECT  [charge].[charge_no],
        [charge_dt]
FROM    [dbo].[charge]
WHERE   [charge_dt] >= '1999-09-01 00:00:00.000' AND
        [charge_dt] < '1999-09-02 00:00:00.000'
GO

-- Let's update 50% of qualifying rows
UPDATE TOP (6720)
        [dbo].[charge]
SET     [charge_dt] = DATEADD(mi, 10, [charge_dt])
WHERE   [charge_dt] >= '1999-09-01 00:00:00.000' AND
        [charge_dt] < '1999-09-02 00:00:00.000'
GO

-- Let's see if auto-updates kick off after executing

 -- Undocumented trace flag to show stats used in query plan
DBCC TRACEON (8666)

SET STATISTICS XML ON;

SELECT  [charge].[charge_no]
FROM    [dbo].[charge]
WHERE   [charge_dt] = '1999-09-01 10:53:38.897';

SET STATISTICS XML OFF;

DBCC TRACEOFF (8666)


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
WHERE   [s].[object_id] = OBJECT_ID('charge') AND
        [s].[name] = 'charge_charge_dt_1999_07';

-- Let's keep updating rows until auto-update stats kicks off for the filtered stats
WHILE (SELECT   [p].[modification_counter]
       FROM     [sys].[stats] AS s
       CROSS APPLY sys.dm_db_stats_properties
	   ([s].object_id, [s].stats_id) AS [p]
       WHERE    [s].[object_id] = OBJECT_ID('charge') AND
                [s].[name] = 'charge_charge_dt_1999_07') > 0 
    BEGIN

        UPDATE TOP (6720)
                [dbo].[charge]
        SET     [charge_dt] = DATEADD(mi, 10, [charge_dt])
        WHERE   [charge_dt] >= '1999-09-01 00:00:00.000' AND
                [charge_dt] < '1999-09-02 00:00:00.000'

        SELECT  [charge].[charge_no]
        FROM    [dbo].[charge]
        WHERE   [charge_dt] = '1999-09-01 10:53:38.897';

        SELECT  [p].[modification_counter] AS modification_counter
        FROM    [sys].[stats] AS s
        CROSS APPLY sys.dm_db_stats_properties
		([s].object_id, [s].stats_id) AS [p]
        WHERE   [s].[object_id] = OBJECT_ID('charge') AND
                [s].[name] = 'charge_charge_dt_1999_07'

    END   

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
WHERE   [s].[object_id] = OBJECT_ID('charge') AND
        [s].[name] = 'charge_charge_dt_1999_07';

-- Don't forget to restore to the original database...