-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

-- Creating a table variable via Dynamic SQL
EXEC
('DECLARE @category TABLE
([category_no] INT,
[category_desc] VARCHAR(31) NOT NULL,
[category_code] CHAR(2) NOT NULL);');

-- Does this work?
INSERT  @category
        ([category_no],
         [category_desc],
         [category_code])
        SELECT  [category_no],
                [category_desc],
                [category_code]
        FROM    [dbo].[category];
GO


-- How about this?
DECLARE @category TABLE
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);

-- Will this work?
EXEC
('INSERT @category
([category_no],
[category_desc],
[category_code])
SELECT  [category_no],
[category_desc],
[category_code]
FROM    [dbo].[category];');
GO

-- How about this?
EXEC
('DECLARE @category TABLE
([category_no] INT,
[category_desc] VARCHAR(31) NOT NULL,
[category_code] CHAR(2) NOT NULL);

INSERT  @category
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
FROM @category;');
GO

