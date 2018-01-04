SELECT  q.query_id,
        q.query_hash,
        q.initial_compile_start_time,
        q.last_compile_start_time,
        q.last_execution_time,
        qt.query_sql_text		
FROM    sys.query_store_query q
        INNER JOIN sys.query_store_query_text qt ON qt.query_text_id = q.query_text_id
WHERE qt.query_sql_text LIKE '%OriginStation%'