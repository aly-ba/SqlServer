SELECT  er.session_id,
        er.start_time,
        er.status,
        er.command,
        er.blocking_session_id,
        er.wait_type,
        er.wait_time,
        er.wait_resource,
        er.cpu_time,
        er.total_elapsed_time,
        er.logical_reads,
        OBJECT_NAME(st.objectid, st.dbid) AS ObjectName,
        SUBSTRING(st.text, (er.statement_start_offset / 2) + 1, ((CASE statement_end_offset
                                                                    WHEN -1 THEN DATALENGTH(st.text)
                                                                    ELSE er.statement_end_offset
                                                                  END - er.statement_start_offset) / 2) + 1) AS StatementText
FROM    sys.dm_exec_sessions es
        INNER JOIN sys.dm_exec_requests er ON er.session_id = es.session_id
        CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) st
WHERE   es.is_user_process = 1;









SELECT  qs.creation_time,
        qs.last_execution_time,
        qs.execution_count,
        qs.min_worker_time,
        qs.max_worker_time,
		(qs.total_worker_time/qs.execution_count) AS AvgWorkerTime,
        qs.min_logical_reads,
        qs.max_logical_reads,
		(qs.total_logical_reads/qs.execution_count) AS AvgLogicalReads,
        qs.min_elapsed_time,
        qs.max_elapsed_time,
		(qs.total_elapsed_time/qs.execution_count) AS AvgElapsedTime,
        qs.min_rows,
        qs.max_rows,
        OBJECT_NAME(st.objectid, st.dbid) AS ObjectName,
        SUBSTRING(st.text, (qs.statement_start_offset / 2) + 1, ((CASE statement_end_offset
                                                                    WHEN -1 THEN DATALENGTH(st.text)
                                                                    ELSE qs.statement_end_offset
                                                                  END - qs.statement_start_offset) / 2) + 1) AS statement_text
FROM    sys.dm_exec_query_stats qs
			CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st;



SELECT  qs.creation_time,
        qs.last_execution_time,
        qs.execution_count,
        qs.min_worker_time,
        qs.max_worker_time,
		(qs.total_worker_time/qs.execution_count) AS AvgWorkerTime,
        qs.min_logical_reads,
        qs.max_logical_reads,
		(qs.total_logical_reads/qs.execution_count) AS AvgLogicalReads,
        qs.min_elapsed_time,
        qs.max_elapsed_time,
		(qs.total_elapsed_time/qs.execution_count) AS AvgElapsedTime,
        qs.min_rows,
        qs.max_rows,
		qp.query_plan
FROM    sys.dm_exec_query_stats qs
			CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp;