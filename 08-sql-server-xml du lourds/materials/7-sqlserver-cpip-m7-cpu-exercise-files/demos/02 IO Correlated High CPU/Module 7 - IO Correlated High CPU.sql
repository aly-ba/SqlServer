USE Credit;
GO

-- Investigate the IO/CPU of this simple query
EXEC sp_executesql N'SELECT charge_no FROM dbo.charge
	WHERE charge_dt = @charge_dt', N'@charge_dt datetime',
    @charge_dt = '1999-07-20 10:49:11.833';
GO

-- What LIOs, PIOs, CPU time do we see?
SELECT  t.text,
        s.total_logical_reads,
        s.total_physical_reads,
        s.total_worker_time,
        p.query_plan
FROM    sys.dm_exec_query_stats s
CROSS APPLY sys.dm_exec_query_plan(s.plan_handle) p
CROSS APPLY sys.dm_exec_sql_text(s.plan_handle) t
WHERE   t.text LIKE '%WHERE charge_dt%';
GO

-- Adding index
CREATE NONCLUSTERED INDEX NCL_charge_charge_dt 
ON [dbo].[charge] ([charge_dt]);
GO

-- Test again
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
GO

EXEC sp_executesql N'SELECT charge_no FROM dbo.charge
	WHERE charge_dt = @charge_dt', N'@charge_dt datetime',
    @charge_dt = '1999-07-20 10:49:11.833';
GO

-- What LIOs, PIOs, CPU time do we see?
SELECT  t.text,
        s.total_logical_reads,
        s.total_physical_reads,
        s.total_worker_time,
        p.query_plan
FROM    sys.dm_exec_query_stats s
CROSS APPLY sys.dm_exec_query_plan(s.plan_handle) p
CROSS APPLY sys.dm_exec_sql_text(s.plan_handle) t
WHERE   t.text LIKE '%WHERE charge_dt%';
GO

-- Cleanup
DROP INDEX NCL_charge_charge_dt ON [dbo].[charge];
GO