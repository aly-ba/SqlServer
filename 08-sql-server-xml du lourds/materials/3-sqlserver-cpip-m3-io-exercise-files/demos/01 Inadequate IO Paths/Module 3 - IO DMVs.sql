-- Triage based on sys.dm_io_virtual_file_stats
SELECT  [database_id],
        [file_id],
        [num_of_reads],
        [num_of_bytes_read],
        [io_stall_read_ms],
        [num_of_writes],
        [num_of_bytes_written],
        [io_stall_write_ms],
        [io_stall],
        [size_on_disk_bytes]
FROM    sys.[dm_io_virtual_file_stats](NULL, NULL)
ORDER BY [io_stall] DESC;
GO

-- Top I/O queries
SELECT  q.[query_hash],
        SUBSTRING(t.text, (q.[statement_start_offset] / 2) + 1,
                  ((CASE q.[statement_end_offset]
                      WHEN -1 THEN DATALENGTH(t.[text])
                      ELSE q.[statement_end_offset]
                    END - q.[statement_start_offset]) / 2) + 1),
        SUM(q.[total_logical_writes]) AS [total_logical_writes]
FROM    sys.[dm_exec_query_stats] AS q
CROSS APPLY sys.[dm_exec_sql_text](q.sql_handle) AS t
GROUP BY q.[query_hash],
        SUBSTRING(t.text, (q.[statement_start_offset] / 2) + 1,
                  ((CASE q.[statement_end_offset]
                      WHEN -1 THEN DATALENGTH(t.[text])
                      ELSE q.[statement_end_offset]
                    END - q.[statement_start_offset]) / 2) + 1)
ORDER BY SUM(q.[total_logical_writes]) DESC;
GO

-- What is the query execution plan of the top I/O query?
SELECT  p.[query_plan]
FROM    sys.[dm_exec_query_stats] AS q
CROSS APPLY sys.[dm_exec_query_plan](q.[plan_handle]) AS p
WHERE   q.[query_hash] = 0x187B11E674050171
GO


