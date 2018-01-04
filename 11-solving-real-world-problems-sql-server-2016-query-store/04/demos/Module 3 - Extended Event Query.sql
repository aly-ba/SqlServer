SELECT timestamp, duration, cpu_time, logical_reads, query_hash, statement FROM dbo.XEPerformanceStats
	WHERE timestamp >= '2017-03-04 15:00:00'
		AND timestamp < '2017-03-04 16:00:00';


























WITH    AggregatedStats
          AS (SELECT    SUM(duration/1000) AS TotalDuration,
                        SUM(cpu_time/1000) AS TotalCPU,
                        SUM(logical_reads) AS TotalReads,
                        query_hash
              FROM      dbo.XEPerformanceStats
              WHERE     timestamp >= '2017-03-04 15:00:00'
                        AND timestamp < '2017-03-04 16:00:00'
                        AND query_hash != 0
              GROUP BY  query_hash
             )
    SELECT  TotalDuration,
            TotalCPU,
            TotalReads,
            AggregatedStats.query_hash,
            QueryStatement.statement
    FROM    AggregatedStats
            INNER JOIN (SELECT  query_hash,
                                statement,
                                ROW_NUMBER() OVER (PARTITION BY query_hash ORDER BY (SELECT 1)) AS RowNo
                        FROM    dbo.XEPerformanceStats
                       ) QueryStatement ON QueryStatement.query_hash = AggregatedStats.query_hash
                                           AND RowNo = 1
ORDER BY TotalCPU DESC;

























SELECT    SUM(duration/1000) AS TotalDuration,
                        SUM(cpu_time/1000) AS TotalCPU,
                        SUM(logical_reads) AS TotalReads
              FROM      dbo.XEPerformanceStats
              WHERE     timestamp >= '2017-03-04 15:00:00'
                        AND timestamp < '2017-03-04 16:00:00'
                        AND query_hash != 0
