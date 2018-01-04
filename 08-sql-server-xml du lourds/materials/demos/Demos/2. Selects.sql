-- Compare select performance 


USE AdventureWorks2014;
GO

--How large is each table/index?
SELECT OBJECT_NAME(i.[object_id]) AS TableName,
	i.name AS IndexName, SUM(s.used_page_count) IndexPages,
	FORMAT(1 - SUM(s.used_page_count) * 1.0/CASE WHEN i.name LIKE 'IX%' THEN 131819 ELSE 143645 END, 'P') AS PercentSaved
FROM sys.dm_db_partition_stats  AS s 
JOIN sys.indexes AS i
ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
WHERE OBJECT_NAME(i.[object_id]) LIKE 'bigTransactionHistory%'
	AND OBJECT_NAME(i.[object_id]) <> 'bigTransactionHistoryTEST'
GROUP BY i.[object_id],i.name
ORDER BY IndexPages Desc;


SET STATISTICS IO ON;
GO
--How many pages?
SELECT SUM(Quantity) AS ItemsPurchased
FROM bigTransactionHistory;

SELECT SUM(Quantity) AS ItemsPurchased
FROM bigTransactionHistoryROW;

SELECT SUM(Quantity) AS ItemsPurchased
FROM bigTransactionHistoryPAGE;

--How many pages in memory?
SELECT COUNT(*)AS cached_pages_count   
    ,name ,index_id 
FROM sys.dm_os_buffer_descriptors AS bd   
    INNER JOIN   
    (  
        SELECT object_name(object_id) AS name   
            ,index_id ,allocation_unit_id  
        FROM sys.allocation_units AS au  
            INNER JOIN sys.partitions AS p   
                ON au.container_id = p.hobt_id   
                    AND (au.type = 1 OR au.type = 3)  
        UNION ALL  
        SELECT object_name(object_id) AS name     
            ,index_id, allocation_unit_id  
        FROM sys.allocation_units AS au  
            INNER JOIN sys.partitions AS p   
                ON au.container_id = p.partition_id   
                    AND au.type = 2  
    ) AS obj   
        ON bd.allocation_unit_id = obj.allocation_unit_id  
WHERE database_id = DB_ID()  AND name LIKE 'bigTransactionHistory%'
GROUP BY name, index_id   
ORDER BY cached_pages_count DESC;



--loops
--3:31
DECLARE @Count INT = 0;
WHILE @Count < 100 BEGIN 
	DBCC DROPCLEANBUFFERS;	
	SELECT SUM(Quantity) AS ItemsPurchased
	FROM bigTransactionHistory;
	SET @Count += 1;
END;

GO

--3:04
DECLARE @Count INT = 0;
WHILE @Count < 100 BEGIN 
	DBCC DROPCLEANBUFFERS;
	SELECT SUM(Quantity) AS ItemsPurchased
	FROM bigTransactionHistoryROW;
	SET @Count += 1;
END;

GO

--3:18
DECLARE @Count INT = 0;
WHILE @Count < 100 BEGIN 
	DBCC DROPCLEANBUFFERS;
	SELECT SUM(Quantity) AS ItemsPurchased
	FROM bigTransactionHistoryPage;
	SET @Count += 1;
END;

