-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

-- Temporary table
SELECT  [category_no],
        [category_desc],
        [category_code]
INTO    #category
FROM    [dbo].[category];
GO

-- Does this work for table variables?
SELECT  [category_no],
        [category_desc],
        [category_code]
INTO    @category
FROM    [dbo].[category];
GO



-- Cleanup
DROP TABLE [#category];
GO