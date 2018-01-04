-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

CREATE TABLE #category
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);
GO

-- Does this work?
EXEC sp_help #category;
GO

USE tempdb;
GO
EXEC sp_help #category;
GO


-- Will this work?
SELECT  [name],
        [object_id],
        [principal_id],
        [schema_id],
        [parent_object_id],
        [type],
        [type_desc],
        [create_date],
        [modify_date],
        [is_ms_shipped],
        [is_published],
        [is_schema_published]
FROM    [sys].[tables]
WHERE   [name] = N'#category___________________________________________________________________________________________________________000000000010';

-- What if you create another #category in a separate connection?
USE [Credit]
GO

CREATE TABLE #category
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);
GO

-- Will this work?
SELECT  [name],
        [object_id],
        [principal_id],
        [schema_id],
        [parent_object_id],
        [type],
        [type_desc],
        [create_date],
        [modify_date],
        [is_ms_shipped],
        [is_published],
        [is_schema_published]
FROM    [sys].[tables]
WHERE   [name] LIKE N'#category%'
ORDER BY [create_date] DESC;

-- Cleanup
DROP TABLE [#category];
GO


