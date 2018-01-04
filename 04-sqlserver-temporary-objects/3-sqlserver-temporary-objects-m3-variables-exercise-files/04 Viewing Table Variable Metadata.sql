-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

-- Does this work?
DECLARE @category TABLE
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);


EXEC [sys].[sp_help] '@category';
GO


-- Or this?
DECLARE @category TABLE
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);

USE tempdb;

EXEC [sys].[sp_help]  '@category';
GO


-- Catalog views? (execute a few times to see the changes)
DECLARE @category TABLE
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);

SELECT  [t].[name],
        [t].[object_id],
        [type],
        [type_desc],
        [create_date],
        [modify_date],
        [c].[name],
        [column_id],
        [system_type_id],
        [user_type_id],
        [max_length],
        [precision],
        [scale],
        [collation_name],
        [is_nullable],
        [is_ansi_padded],
        [is_rowguidcol],
        [is_identity]
FROM    [tempdb].[sys].[tables] AS [t]
INNER JOIN [tempdb].[sys].[columns] AS [c]
        ON t.[object_id] = c.[object_id]
WHERE [c].[name] IN 
	('category_no', 'category_desc', 'category_code')
GO
