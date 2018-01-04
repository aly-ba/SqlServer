-- Module 3, Demo 3
-- Catalog Views (2)

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

-- All objects ordered by type and name
SELECT  OBJECT_NAME([object_id]) AS [object_name],
        [name] AS [column_name],
        [column_id] ,
        [seed_value] ,
        [increment_value] ,
        [last_value] ,
        [is_not_for_replication] ,
        [is_computed] ,
        [is_sparse] ,
        [is_column_set] 
FROM [sys].[identity_columns] AS ic
ORDER BY OBJECT_NAME([object_id]);
GO

-- Computed columns
SELECT  OBJECT_NAME([object_id]) AS [object_name],
        [name] AS [column_name],
        [column_id] ,
        [definition] ,
        [is_persisted] 
FROM [sys].[computed_columns];
GO

-- Primary or unique key constraints
SELECT  OBJECT_NAME([kc].[parent_object_id]) AS [parent_object_name],
	    COL_NAME([kc].[parent_object_id],[ic].[column_id]) AS [column_name],
		[kc].[name] ,
		[kc].[parent_object_id] ,
        [kc].[unique_index_id],
        [kc].[type_desc] ,
        [kc].[is_system_named]
FROM [sys].[key_constraints] AS kc
INNER JOIN [sys].[index_columns] AS ic ON
	[kc].[parent_object_id] = [ic].[object_id] AND
    [kc].[unique_index_id] = [ic].[index_id]  
ORDER BY OBJECT_NAME([kc].[parent_object_id]);
GO

-- Check constraints
SELECT  OBJECT_NAME([parent_object_id]) AS [parent_object_name],
		[name] ,
		COL_NAME([parent_object_id],[parent_column_id]) AS [column_name],
		[parent_object_id] ,
        [parent_column_id] ,
        [definition] ,
        [is_system_named]
FROM [sys].[check_constraints] AS cc;
GO

-- Default constraints
SELECT  OBJECT_NAME([parent_object_id]) AS [parent_object_name],
		[name] ,
		COL_NAME([parent_object_id],[parent_column_id]) AS [column_name],
        [parent_object_id] ,
        [parent_column_id] ,
        [definition] ,
        [is_system_named]
FROM [sys].[default_constraints] AS dc
ORDER BY OBJECT_NAME([parent_object_id]);
GO

-- Foreign key details
SELECT  OBJECT_NAME(fk.[parent_object_id]) AS [parent_object_name] ,
        COL_NAME([fkc].[parent_object_id], [fkc].[parent_column_id]) 
			AS [parent_column] ,
        OBJECT_NAME(fk.[referenced_object_id]) AS [referenced_object_name] ,
        COL_NAME([fkc].[referenced_object_id], [fkc].[referenced_column_id]) 
			AS [reference_column] ,
        [fk].[name] ,
        [fk].[parent_object_id] ,
        [fk].[delete_referential_action_desc] ,
        [fk].[update_referential_action_desc]
FROM    [sys].[foreign_keys] AS [fk]
        INNER JOIN [sys].[foreign_key_columns] AS [fkc]
        ON [fk].[object_id] = [fkc].[constraint_object_id]
ORDER BY OBJECT_NAME(fk.[parent_object_id]),
		 COL_NAME([fkc].[parent_object_id], [fkc].[parent_column_id]);
GO