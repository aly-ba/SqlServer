-- You can get the AdventureWorksDW2012 database used in these demos from http://bit.ly/9hBGub

USE [AdventureWorksDW2012]
GO


-- Used page allocation
SELECT  [partition_id],
		SUM([in_row_used_page_count]) AS [in_row_used_page_count],
        SUM([lob_used_page_count]) AS [lob_used_page_count],
        SUM([row_count]) AS [row_count]
FROM    sys.[dm_db_partition_stats]
WHERE   [object_id] = OBJECT_ID('FactInternetSales') AND
		[index_id] = INDEXPROPERTY
			(OBJECT_ID('FactInternetSales'),
			'NCI_FactInternetSales', 
			'IndexId')
GROUP BY [partition_id];
GO


-- Segment information
SELECT  [partition_id],
        [hobt_id],
        [column_id],
        [segment_id],
        [encoding_type],
        [row_count],
        [primary_dictionary_id],
        [secondary_dictionary_id],
        [min_data_id],
        [max_data_id],
        [on_disk_size]
FROM    sys.[column_store_segments]
WHERE [partition_id] = 72057594046513152;


-- All columns for the same segment have the same number of rows
SELECT  [partition_id],
        [hobt_id],
        [column_id],
        [segment_id],
        [row_count],
        [on_disk_size]
FROM    sys.[column_store_segments]
WHERE [segment_id] = 1;
GO

-- Columnstore dictionary meta-data
SELECT  [partition_id],
        [hobt_id],
        [column_id],
        [dictionary_id], 
        [type],
        [entry_count],
        [on_disk_size]
FROM    sys.column_store_dictionaries;


-- What's up with column_id 9?

-- Let's verify the index vs. column ID
SELECT  [object_id],
        [index_id],
        [index_column_id],
        [column_id],
        [key_ordinal],
        [partition_ordinal],
        [is_descending_key],
        [is_included_column]
FROM sys.[index_columns] AS ic
WHERE object_id = OBJECT_ID('FactInternetSales') AND
	  index_id = INDEXPROPERTY
			(OBJECT_ID('FactInternetSales'),
			'NCI_FactInternetSales', 
			'IndexId');
GO


-- Table columns
SELECT  [name],
        [column_id]
FROM sys.[columns] AS c
WHERE [object_id] = OBJECT_ID('FactInternetSales');
GO


-- How compression-friendly is it?
SELECT COUNT(DISTINCT [SalesOrderNumber])
FROM dbo.[FactInternetSales] AS fis;
GO


-- Compare that to CurrencyKey
SELECT COUNT(DISTINCT [CurrencyKey])
FROM dbo.[FactInternetSales] AS fis;
GO


-- Columnstore dictionary meta-data
SELECT  [partition_id],
        [hobt_id],
        [column_id], 
        [type],
        [entry_count],
        [on_disk_size]
FROM    sys.column_store_dictionaries
WHERE [column_id] = 7;
GO
