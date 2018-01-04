USE [master];
GO

SELECT  [name],
        [database_id],
        [is_auto_create_stats_on],
        [is_auto_update_stats_on],
        [is_auto_update_stats_async_on]
FROM sys.[databases];
