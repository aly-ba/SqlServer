USE [Credit];
GO

-- Doing this to bring down the available memory grant 
-- EstimatedAvailableMemoryGrant
EXEC sp_configure 'max server memory', 500;
RECONFIGURE;
GO

-- Skewed statistics can often cause spills
-- We'll build in an over-estimate
UPDATE STATISTICS [dbo].[charge]
WITH ROWCOUNT = 1000000000000, PAGECOUNT = 10000000000000;
GO

-- Run this in three separate query windows (sessions)
WHILE 1 = 1 
    BEGIN
        SELECT  [member].[member_no],
                [member].[lastname],
                [member].[firstname],
                [region].[region_no],
                [region].[region_name],
                [provider].[provider_name],
                [category].[category_desc],
                [charge].[charge_no],
                [charge].[provider_no],
                [charge].[category_no],
                [charge].[charge_dt],
                [charge].[charge_amt],
                [charge].[charge_code]
        FROM    [dbo].[provider],
                [dbo].[member],
                [dbo].[region],
                [dbo].[category],
                [dbo].[charge]
        WHERE   [member].[member_no] = [charge].[member_no] AND
                [region].[region_no] = [member].[region_no] AND
                [provider].[provider_no] = [charge].[provider_no] AND
                [category].[category_no] = [charge].[category_no]
        OPTION  (HASH JOIN);
    END

-- Check this in a 4th query window
SELECT  [session_id],
        [request_id],
        [scheduler_id],
        [dop],
        [request_time],
        [grant_time],
        [requested_memory_kb],
        [granted_memory_kb],
        [required_memory_kb],
        [used_memory_kb],
        [max_used_memory_kb],
        [query_cost],
        [timeout_sec],
        [resource_semaphore_id],
        [queue_id],
        [wait_order],
        [is_next_candidate],
        [wait_time_ms],
        [plan_handle],
        [sql_handle],
        [group_id],
        [pool_id],
        [is_small],
        [ideal_memory_kb]
FROM    [sys].[dm_exec_query_memory_grants];
GO 


-- Cleanup
ALTER INDEX ALL ON [dbo].[charge] REBUILD;
GO

EXEC sp_configure 'max server memory', 4000;
RECONFIGURE;
GO