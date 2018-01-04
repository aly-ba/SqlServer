SELECT name,
       timestamp,
       duration,
       cpu_time,
       physical_reads,
       logical_reads,
       row_count,
       object_name,
       statement,
       query_hash
FROM dbo.XEPerformanceStats WHERE OBJECT_NAME = 'GetClientTransactions'
ORDER BY timestamp;

SELECT name,
       timestamp,
       estimated_rows,
       estimated_cost,
       duration,
       cpu_time,
       recompile_count,
       object_name,
       CAST(showplan_xml AS XML) AS ExecutionPlan,
       database_name,
       query_hash 
FROM dbo.XEShowplanForCompile
WHERE object_name = 'GetClientTransactions'
ORDER BY timestamp;