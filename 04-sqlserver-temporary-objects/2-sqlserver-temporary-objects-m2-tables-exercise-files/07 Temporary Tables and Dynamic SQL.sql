-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

-- Creating a temporary table via Dynamic SQL
EXEC
('CREATE TABLE #category
([category_no] INT,
[category_desc] VARCHAR(31) NOT NULL,
[category_code] CHAR(2) NOT NULL);');
GO

-- Does this work?
INSERT  #category
        ([category_no],
         [category_desc],
         [category_code])
        SELECT  [category_no],
                [category_desc],
                [category_code]
        FROM    [dbo].[category];
GO

SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    #category;
GO

-- How about this?
EXEC
('CREATE TABLE #category
([category_no] INT,
[category_desc] VARCHAR(31) NOT NULL,
[category_code] CHAR(2) NOT NULL);

INSERT  #category
([category_no],
[category_desc],
[category_code])
SELECT  [category_no],
[category_desc],
[category_code]
FROM    [dbo].[category];

SELECT	 [category_no],
[category_desc],
[category_code]
FROM #category;');
GO

-- How about this?
CREATE TABLE #category
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);
GO

-- Will this work?
EXEC
('INSERT  #category
([category_no],
[category_desc],
[category_code])
SELECT  [category_no],
[category_desc],
[category_code]
FROM    [dbo].[category];');
GO

SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    #category;
GO

-- Cleanup
DROP TABLE [#category];
GO
