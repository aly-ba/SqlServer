SELECT * FROM 
(SELECT qsq.query_id, qsrt.avg_duration, 
	5+10*(DATEDIFF(hour,'2017-04-27 00:00:00', qsrsi.start_time)) AS CostThreshold
	FROM sys.query_store_query qsq 
	INNER JOIN sys.query_store_query_text qsqt ON qsqt.query_text_id = qsq.query_text_id
	INNER JOIN sys.query_store_plan qsp ON qsp.query_id = qsq.query_id
	INNER JOIN sys.query_store_runtime_stats qsrt ON qsrt.plan_id = qsp.plan_id
	INNER JOIN sys.query_store_runtime_stats_interval qsrsi ON qsrsi.runtime_stats_interval_id = qsrt.runtime_stats_interval_id
WHERE qsq.query_id IN (36, 140, 141, 142, 143)
	AND qsrsi.start_time >= '2017-04-27 00:00:00' AND qsrsi.start_time < '2017-04-27 09:00:00'
) AS RawStats
PIVOT (
	avg(avg_duration)
	FOR query_id IN ([36], [140], [141], [142], [143])
) AS QueryPerformanceOverTime
