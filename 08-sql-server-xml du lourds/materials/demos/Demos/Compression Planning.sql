
CREATE TABLE #RowSavings(
	[object_name] sysname,	
	[schema_name] sysname,
	[index_id] int, 
	[partition_number] int,
	[current_size(KB)] bigint,
	[Row_Compression_Size(KB)] bigint,
	[sample_size_with_current_compression_setting(KB)] bigint,
	[sample_size_with_requested_compression_setting(KB)] bigint
);
CREATE TABLE #PageSavings(
	[object_name] sysname,	
	[schema_name] sysname,
	[index_id] int, 
	[partition_number] int,
	[current_size(KB)] bigint,
	[Page_Compression_Size(KB)] bigint,
	[sample_size_with_current_compression_setting(KB)] bigint,
	[sample_size_with_requested_compression_setting(KB)] bigint
);

CREATE TABLE #Usage(
	[Schema_Name] sysname,
	[Table_Name] sysname, 
	[Index_Name] sysname,
	[Partition] int, 
	[Index_ID] int,
	[Index_Type] varchar(20),
	[Percent_Update] decimal(5,2),
	[Percent_Scan] decimal(5,2)
);


/*
Modified version of script found at https://technet.microsoft.com/en-us/library/dd894051(v=sql.100).aspx
*/
INSERT INTO #Usage
SELECT schema_name(o.schema_id) as [Schema_Name], 
	o.name AS [Table_Name], isnull(x.name,'') AS [Index_Name],
       i.[partition_number],
       i.[Index_ID], x.type_desc AS [Index_Type],
       i.[leaf_update_count] * 100.0 /
           (i.[range_scan_count] + i.[leaf_insert_count]
            + i.[leaf_delete_count] + i.[leaf_update_count]
            + i.[leaf_page_merge_count] + [i].[singleton_lookup_count]
           ) AS [Percent_Update],
		   i.[range_scan_count] * 100.0 /
           (i.[range_scan_count] + i.[leaf_insert_count]
            + i.[leaf_delete_count] + i.[leaf_update_count]
            + i.[leaf_page_merge_count] + i.[singleton_lookup_count]
           ) AS [Percent_Scan]
FROM sys.dm_db_index_operational_stats (db_id(), NULL, NULL, NULL) i
JOIN sys.objects o ON o.object_id = i.object_id
JOIN sys.indexes x ON x.object_id = i.object_id AND x.index_id = i.index_id
WHERE (i.[range_scan_count] + i.[leaf_insert_count]
       + i.[leaf_delete_count] + [leaf_update_count]
       + i.[leaf_page_merge_count] + i.[singleton_lookup_count]) != 0
AND objectproperty(i.[object_id],'IsUserTable') = 1;


DECLARE @SchemaName SYSNAME
DECLARE @TableName SYSNAME
DECLARE Tablelist CURSOR FAST_FORWARD FOR 
	SELECT DISTINCT [Schema_Name], [Table_Name]
	FROM #Usage;
OPEN TableList 
FETCH NEXT FROM TableList INTO @SchemaName, @TableName;
WHILE @@FETCH_STATUS = 0 BEGIN 
	INSERT INTO #RowSavings
	EXEC sp_estimate_data_compression_savings @SchemaName,
		@TableName, NULL, NULL, 'ROW';
	INSERT INTO #PageSavings
		EXEC sp_estimate_data_compression_savings @SchemaName,
		@TableName, NULL, NULL, 'PAGE';
	FETCH NEXT FROM TableList INTO @SchemaName, @TableName;
END;
CLOSE TableList;
DEALLOCATE TableList;


SELECT #Usage.[Schema_Name] AS [Schema], #Usage.[Table_Name] AS [Table],
	#Usage.[Index_Name] AS [Index],#Usage.[Index_Type]AS [Type],
	#Usage.[Partition],
	#RowSavings.[current_size(KB)] AS [SizeKB],
	#RowSavings.[Row_Compression_Size(KB)] AS [RowKB],
	#PageSavings.[Page_Compression_Size(KB)] AS [PageKB], 
	#Usage.Percent_Scan AS [%Scan], #Usage.Percent_Update AS [%Update]
FROM #Usage 
JOIN #RowSavings ON #Usage.[Schema_Name] = #RowSavings.[schema_name]
	AND #Usage.[Table_Name] = #RowSavings.[object_name] 
	AND #Usage.[Index_ID] = #RowSavings.[index_id]
	AND #Usage.[Partition] = #RowSavings.[partition_number]
JOIN #PageSavings ON #Usage.[Schema_Name] = #PageSavings.[schema_name]
	AND #Usage.[Table_Name] = #PageSavings.[object_name] 
	AND #Usage.[Index_ID] = #PageSavings.[index_id]
	AND #Usage.[Partition] = #PageSavings.[partition_number];


