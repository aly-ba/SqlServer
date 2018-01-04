-- You can get the AdventureWorksDW2012 database used in these demos from http://bit.ly/9hBGub

USE [AdventureWorksDW2012];
GO

-- OrderDateKey
SELECT  s.[column_id],
        s.[min_data_id],
        s.[max_data_id],
        s.[segment_id]
FROM    [sys].[column_store_segments] AS [s]
WHERE   s.[column_id] = 2
ORDER BY s.[column_id],
        s.[min_data_id],
        s.[max_data_id],
        s.[segment_id]; 


DBCC TRACEON(3605, -1); 
GO 

DBCC TRACEON(646, -1); 
GO 

 
SELECT  [OrderDateKey],
		[ProductKey],
		[PromotionKey],
        SUM(OrderQuantity) AS [Total_OrderQuantity]
FROM    [dbo].[FactInternetSales]
GROUP BY [OrderDateKey], [ProductKey], [PromotionKey]
HAVING  [OrderDateKey] BETWEEN 20080101 AND 20080729
OPTION (RECOMPILE); 


DBCC TRACEOFF(3605, -1); 
GO 

DBCC TRACEOFF(646, -1); 
GO 
