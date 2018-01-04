-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


-- If you can create a table, you can create a temp table
USE [Credit];
GO

-- Notice the # prefix (local temporary table)
-- We'll be showing other temporary table options in later demos
-- Notice that that I'm not designating a schema owner as part of the object name
CREATE TABLE #category
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);
GO

-- INSERT rows
INSERT  #category
        ([category_no],
         [category_desc],
         [category_code])
        SELECT  [category_no],
                [category_desc],
                [category_code]
        FROM    [dbo].[category];
GO

-- Querying the temporary table
SELECT	 [category_no],
         [category_desc],
         [category_code]
FROM #category;

-- In a new query window can you reference #category?

-- Removing the table
DROP TABLE #category;
GO

