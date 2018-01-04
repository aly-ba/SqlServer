-- Module 3, Demo 4
-- Triggers

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

-- Triggers
SELECT  OBJECT_NAME([triggers].[parent_id]) AS [object_name],
		[triggers].[name] AS [trigger_name],
        [triggers].[parent_class_desc] ,
        [triggers].[type_desc] ,
        [triggers].[is_disabled] ,
        [triggers].[is_instead_of_trigger],
		OBJECT_DEFINITION([triggers].[object_id]) AS [trigger_definition]
FROM [sys].[triggers]
ORDER BY OBJECT_NAME([triggers].[object_id]);

-- Alternative method for showing definition
SELECT  OBJECT_NAME([t].[parent_id]) AS [object_name],
		[t].[name] AS [trigger_name],
        [t].[parent_class_desc] ,
        [t].[type_desc] ,
        [t].[is_disabled] ,
        [t].[is_instead_of_trigger],
		[sm].[definition]
FROM [sys].[triggers] AS [t]
INNER JOIN [sys].[sql_modules] AS [sm] ON
	[t].[object_id] = [sm].[object_id]
ORDER BY OBJECT_NAME([t].[object_id]);