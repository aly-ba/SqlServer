SELECT TOP(5) qsp.query_id
	FROM sys.query_store_query qsq 
	INNER JOIN sys.query_store_query_text qsqt ON qsqt.query_text_id = qsq.query_text_id
	INNER JOIN sys.query_store_plan qsp ON qsp.query_id = qsq.query_id
	INNER JOIN sys.query_store_runtime_stats qsrt ON qsrt.plan_id = qsp.plan_id
	INNER JOIN sys.query_store_runtime_stats_interval qsrsi ON qsrsi.runtime_stats_interval_id = qsrt.runtime_stats_interval_id
WHERE qsrsi.start_time >= '2017-04-27 00:00:00' AND qsrsi.start_time < '2017-04-27 09:00:00'
GROUP BY qsp.query_id
ORDER BY SUM(qsrt.count_executions) DESC;