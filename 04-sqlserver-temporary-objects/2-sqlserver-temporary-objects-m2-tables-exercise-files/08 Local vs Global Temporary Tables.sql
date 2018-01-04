-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

-- Local
CREATE TABLE #category
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);
GO

-- Does this work in a separate session?
INSERT  #category
        ([category_no],
         [category_desc],
         [category_code])
        SELECT  [category_no],
                [category_desc],
                [category_code]
        FROM    [dbo].[category];
GO

-- Global
CREATE TABLE ##category
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);
GO

-- Does this work in a separate session?
INSERT  ##category
        ([category_no],
         [category_desc],
         [category_code])
        SELECT  [category_no],
                [category_desc],
                [category_code]
        FROM    [dbo].[category];
GO

-- But like a regular table, you can't create multiple with the same name
CREATE TABLE ##category
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);
GO

CREATE DATABASE [SampleRemoveMe];
GO

-- How about in a separate database?
USE [SampleRemoveMe];
GO

CREATE TABLE ##category
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);
GO


-- Cleanup
DROP TABLE [#category];
DROP TABLE [##category];
GO

USE [master];

DROP DATABASE [SampleRemoveMe];
GO
