-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [master];
GO

-- Database collation settings
SELECT  [name],
        [collation_name]
FROM    [sys].[databases];
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
WHERE   [name] = 'DemoDefaults';
GO

USE [DemoDefaults];
GO

CREATE TABLE #category
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);
GO

-- What collation?
EXEC [tempdb].[sys].[sp_help] #category;
GO

-- For non-contained databases, we see tempdb's collation was used

-- An alternative?

CREATE TABLE #category_v2
(
 [category_no] INT,
 [category_desc] VARCHAR(31) COLLATE French_CI_AS
                             NOT NULL,
 [category_code] CHAR(2) COLLATE French_CI_AS
                         NOT NULL
);
GO

-- What collation?
EXEC [tempdb].[sys].[sp_help] #category_v2;
GO

-- Cleanup
DROP TABLE [#category];
DROP TABLE [#category_v2];
GO

USE [master];
GO
DROP DATABASE [DemoDefaults];
GO