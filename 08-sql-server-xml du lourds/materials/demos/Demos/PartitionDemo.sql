--Module 6: Partitioning
USE CompressionTest;
GO
--Drop objects if they exist
IF OBJECT_ID('SalesOrderHeader') IS NOT NULL DROP TABLE SalesOrderHeader;
IF EXISTS(SELECT * FROM sys.partition_schemes WHERE name = 'psDates') DROP PARTITION SCHEME psDates;
IF EXISTS(SELECT * FROM sys.partition_functions WHERE name = 'pfDates') DROP PARTITION FUNCTION pfDates;

--Create objects for partitioning
CREATE PARTITION FUNCTION [pfDates] (DATETIME)
AS RANGE RIGHT FOR VALUES('2011-01-01','2012-01-01','2013-01-01','2014-01-01','2015-01-01')

CREATE PARTITION SCHEME [psDates] 
AS PARTITION [pfDates]
ALL TO ('PRIMARY');

--Create partitioned table
CREATE TABLE [SalesOrderHeader](
	[SalesOrderID] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[CustomerID] [int] NOT NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[SubTotal] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
CONSTRAINT [PK_SalesOrderHeader_SalesOrderID] PRIMARY KEY CLUSTERED 
(
	[SalesOrderID] ASC,
	[OrderDate] ASC
) ON psDates(OrderDate)
);

--aligned
CREATE INDEX IX_SalesOrderHeaderSalesPersonID ON SalesOrderHeader 
(SalesPersonID);

-- not aligned
CREATE INDEX IX_SalesOrderHeaderTerritoryID ON SalesOrderHeader
(TerritoryID)
ON 'PRIMARY';

--Insert rows
INSERT INTO SalesOrderHeader( [SalesOrderID]
      ,[OrderDate]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[TerritoryID]
      ,[SubTotal]
      ,[TaxAmt]
      ,[Freight]
)
SELECT [SalesOrderID]
      ,[OrderDate]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[TerritoryID]
      ,[SubTotal]
      ,[TaxAmt]
      ,[Freight]
FROM AdventureWorks2014.sales.SalesOrderHeader;


--View compression level and size of partitions
SELECT  OBJECT_NAME(i.Object_ID) AS TableName, i.name as IndexName,
		p.partition_number as PartNum, rv.value AS RangeVal,
        p.rows, dps.in_row_used_page_count * 8 AS SizeKB,
		p.data_compression_desc AS CompressType
FROM    sys.destination_data_spaces AS dds
JOIN sys.data_spaces AS ds ON dds.data_space_id = ds.data_space_id
JOIN sys.partition_schemes AS ps ON dds.partition_scheme_id = ps.data_space_id
JOIN sys.partition_functions AS pf ON ps.function_id = pf.function_id
LEFT JOIN sys.partition_range_values AS rv ON pf.function_id = rv.function_id
	AND dds.destination_id = 
		CASE pf.boundary_value_on_right WHEN 0 THEN rv.boundary_id
			ELSE rv.boundary_id + 1 END
LEFT JOIN sys.indexes AS i ON dds.partition_scheme_id = i.data_space_id
LEFT JOIN sys.partitions AS p ON i.object_id = p.object_id
	AND i.index_id = p.index_id
    AND dds.destination_id = p.partition_number
LEFT JOIN sys.dm_db_partition_stats AS dps ON p.object_id = dps.object_id
    AND p.partition_id = dps.partition_id
WHERE OBJECT_NAME(i.object_id) = 'SalesOrderHeader' AND p.partition_number IS NOT NULL
ORDER BY TableName, indexName, PartNum;

--Add compression to specific partitions
ALTER INDEX PK_SalesOrderHeader_SalesOrderID 
ON SalesOrderHeader REBUILD PARTITION = 1 WITH(DATA_COMPRESSION = PAGE);
ALTER INDEX PK_SalesOrderHeader_SalesOrderID 
ON SalesOrderHeader REBUILD PARTITION = 2 WITH(DATA_COMPRESSION = PAGE);
ALTER INDEX PK_SalesOrderHeader_SalesOrderID 
ON SalesOrderHeader REBUILD PARTITION = 3 WITH(DATA_COMPRESSION = ROW);
ALTER INDEX PK_SalesOrderHeader_SalesOrderID 
ON SalesOrderHeader REBUILD PARTITION = 4 WITH(DATA_COMPRESSION = ROW);

ALTER INDEX IX_SalesOrderHeaderSalesPersonID 
ON SalesOrderHeader REBUILD PARTITION = 1 WITH(DATA_COMPRESSION = PAGE);
ALTER INDEX IX_SalesOrderHeaderSalesPersonID 
ON SalesOrderHeader REBUILD PARTITION = 2 WITH(DATA_COMPRESSION = PAGE);
ALTER INDEX IX_SalesOrderHeaderSalesPersonID 
ON SalesOrderHeader REBUILD PARTITION = 3 WITH(DATA_COMPRESSION = ROW);
ALTER INDEX IX_SalesOrderHeaderSalesPersonID 
ON SalesOrderHeader REBUILD PARTITION = 4 WITH(DATA_COMPRESSION = ROW);
ALTER INDEX IX_SalesOrderHeaderTerritoryID
ON SalesOrderHeader REBUILD WITH(DATA_COMPRESSION = ROW);

--View compression level and size of partitions
SELECT  OBJECT_NAME(i.Object_ID) AS TableName, i.name as IndexName,
		p.partition_number as PartNum, rv.value AS RangeVal,
        p.rows, dps.in_row_used_page_count * 8 AS SizeKB,
		p.data_compression_desc AS CompressType
FROM    sys.destination_data_spaces AS dds
JOIN sys.data_spaces AS ds ON dds.data_space_id = ds.data_space_id
JOIN sys.partition_schemes AS ps ON dds.partition_scheme_id = ps.data_space_id
JOIN sys.partition_functions AS pf ON ps.function_id = pf.function_id
LEFT JOIN sys.partition_range_values AS rv ON pf.function_id = rv.function_id
	AND dds.destination_id = 
		CASE pf.boundary_value_on_right WHEN 0 THEN rv.boundary_id
			ELSE rv.boundary_id + 1 END
LEFT JOIN sys.indexes AS i ON dds.partition_scheme_id = i.data_space_id
LEFT JOIN sys.partitions AS p ON i.object_id = p.object_id
	AND i.index_id = p.index_id
    AND dds.destination_id = p.partition_number
LEFT JOIN sys.dm_db_partition_stats AS dps ON p.object_id = dps.object_id
    AND p.partition_id = dps.partition_id
WHERE OBJECT_NAME(i.object_id) = 'SalesOrderHeader' AND p.partition_number IS NOT NULL
ORDER BY TableName, indexName, PartNum;
