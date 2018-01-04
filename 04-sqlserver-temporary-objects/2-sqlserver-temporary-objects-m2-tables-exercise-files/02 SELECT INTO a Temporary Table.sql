-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

-- A quick method to produce a temporary table based on an existing table
SELECT  [category_no],
        [category_desc],
        [category_code]
INTO    #category
FROM    [dbo].[category];

SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    #category;

-- Need an empty temporary table based on the schema of an existing table?
SELECT  [category_no],
        [category_desc],
        [category_code]
INTO    #category_2
FROM    [dbo].[category]
WHERE   1 = 0;

SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    #category_2;

-- Cleanup
DROP TABLE #category;
DROP TABLE #category_2;
GO