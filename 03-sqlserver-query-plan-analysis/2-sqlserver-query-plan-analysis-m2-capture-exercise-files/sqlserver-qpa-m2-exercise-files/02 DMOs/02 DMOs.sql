USE [Credit];
GO

-- Clearing the plan cache (don't do this in production)
DBCC FREEPROCCACHE;
GO

-- Execute this query
SELECT  [payment_wide].[member_no]
FROM    [dbo].[payment_wide]
WHERE   [payment_wide].[expr_dt] = '2000-10-12 10:41:34.757';

-- sys.dm_exec_cached_plans
SELECT  [size_in_bytes],
        [cacheobjtype],
        [objtype],
        [plan_handle]
FROM    sys.dm_exec_cached_plans;

-- Let's find our plan based on query text
SELECT  [cp].[size_in_bytes],
        [cp].[cacheobjtype],
        [cp].[objtype],
        [cp].[plan_handle],
        [dest].[text]
FROM    [sys].[dm_exec_cached_plans] AS cp
CROSS APPLY [sys].[dm_exec_sql_text]([cp].[plan_handle]) AS dest
WHERE   [dest].[text] LIKE '%payment_wide%';

-- sys.dm_exec_query_plan 
SELECT  [dbid],
        [query_plan]
FROM    sys.dm_exec_query_plan(0x060005007583A9125022B9FF0200000001000000000000000000000000000000000000000000000000000000);
GO

-- sys.dm_exec_text_query_plan
SELECT  [dbid],
        [query_plan]
FROM    sys.dm_exec_text_query_plan(0x060005007583A9125022B9FF0200000001000000000000000000000000000000000000000000000000000000,
                                    0, -1);
GO


