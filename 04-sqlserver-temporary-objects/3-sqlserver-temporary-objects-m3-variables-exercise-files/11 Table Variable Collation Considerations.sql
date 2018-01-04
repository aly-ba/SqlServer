-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

-- Creating a new database with a different collation
CREATE DATABASE [DemoDefaults];
GO

ALTER DATABASE [DemoDefaults]
COLLATE French_CI_AS;
GO

-- Database collation settings
SELECT  [name],
        [collation_name]
FROM    [sys].[databases]
WHERE   [name] IN ('tempdb', 'DemoDefaults');
GO


-- What collation will be used?
-- Will it use tempdb or the current database context?
USE [DemoDefaults];
GO

DECLARE @category TABLE
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);

INSERT  @category
        ([category_no],
         [category_desc],
         [category_code])
        SELECT  [category_no],
                [category_desc],
                [category_code]
        FROM    [Credit].[dbo].[category];


SELECT  [object_id],
        [name],
        [collation_name]
FROM    [tempdb].[sys].[columns]
WHERE   [name] IN ('category_desc', 'category_code');
GO

-- Cleanup
USE [master];
GO

DROP DATABASE [DemoDefaults];
GO