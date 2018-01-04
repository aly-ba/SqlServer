SELECT  q.query_id,
        q.last_execution_time,
        qt.query_sql_text,
		qsrt.avg_duration,
		qsrt.count_executions,
		qsrt.avg_cpu_time,
		qsrt.avg_logical_io_reads,
		qsrtsi.start_time		
FROM    sys.query_store_query q
        INNER JOIN sys.query_store_query_text qt ON qt.query_text_id = q.query_text_id
		INNER JOIN sys.query_store_plan qsp ON qsp.query_id = q.query_id
		INNER JOIN sys.query_store_runtime_stats qsrt ON qsrt.plan_id = qsp.plan_id
		INNER JOIN sys.query_store_runtime_stats_interval qsrtsi ON qsrtsi.runtime_stats_interval_id = qsrt.runtime_stats_interval_id
WHERE qt.query_sql_text LIKE '%dbo.TransitLog%'
	AND qt.query_sql_text LIKE '%COUNT%'
	AND qt.query_sql_text NOT LIKE '%sys.query_store_query%'