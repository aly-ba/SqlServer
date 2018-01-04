-- Module 3, Demo 2
-- Catalog Views

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

-- All objects ordered by type and name
SELECT  [name] ,
        [object_id] ,
        [principal_id] ,
        [schema_id] ,
        [parent_object_id] ,
        [type] ,
        [type_desc] ,
        [create_date] ,
        [modify_date] ,
        [is_ms_shipped] ,
        [is_published] ,
        [is_schema_published]
FROM [sys].[objects] 
ORDER BY [type_desc], [name];
GO

-- All tables, ordered by name
SELECT  [name] ,
        [object_id] ,
        [principal_id] ,
        [schema_id] ,
        [parent_object_id] ,
        [type] ,
        [type_desc] ,
        [create_date] ,
        [modify_date] ,
        [is_ms_shipped] ,
        [is_published] ,
        [is_schema_published] ,
        [lob_data_space_id] ,
        [filestream_data_space_id] ,
        [max_column_id_used] ,
        [lock_on_bulk_load] ,
        [uses_ansi_nulls] ,
        [lock_escalation] ,
        [lock_escalation_desc] ,
        [is_filetable]	
FROM sys.[tables]
ORDER BY [name];
GO

-- Examine columns associated with a specific table
SELECT  [c].[name] ,
        [t].[name] ,
        [c].[max_length] ,
        [c].[precision] ,
        [c].[scale] ,
        [c].[collation_name] ,
        [c].[is_nullable] ,
        [c].[is_rowguidcol] ,
        [c].[is_identity] ,
        [c].[is_computed] ,
        [c].[is_xml_document] ,
        [c].[xml_collection_id] ,
        [c].[default_object_id] ,
        [c].[rule_object_id] ,
        [c].[is_sparse] ,
        [c].[is_column_set] 
FROM    [sys].[columns] AS [c]
        INNER JOIN [sys].[types] AS [t]
        ON [c].[system_type_id] = [t].[system_type_id]
WHERE   [c].[object_id] = OBJECT_ID('[Person].[Person]') AND
		[t].[system_type_id] = [t].[user_type_id]
ORDER BY [c].[column_id];
GO


