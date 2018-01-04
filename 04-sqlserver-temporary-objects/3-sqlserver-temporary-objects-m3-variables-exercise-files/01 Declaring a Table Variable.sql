-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


-- Instead of CREATE TABLE, you DECLARE a table variable
USE [Credit];
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
        FROM    [dbo].[category];

SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    @category;
GO

-- No need to explicitly DROP the table variable
-- We'll talk about scope and lifecycle in the next demo
