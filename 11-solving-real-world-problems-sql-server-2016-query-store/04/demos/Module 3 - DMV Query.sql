WAITFOR DELAY '00:00:30'

SELECT  creation_time,
        last_execution_time,
        total_worker_time,
        total_logical_reads,
        total_elapsed_time,
        OBJECT_NAME(st.objectid, st.dbid) AS ObjectName,
        SUBSTRING(st.text, (qs.statement_start_offset / 2) + 1, ((CASE statement_end_offset
                                                                    WHEN -1 THEN DATALENGTH(st.text)
                                                                    ELSE qs.statement_end_offset
                                                                  END - qs.statement_start_offset) / 2) + 1) AS statement_text
FROM    sys.dm_exec_query_stats qs
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st;