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
SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    #category;

-- Without dropping the local temporary table, let's disconnect

-- Reconnect and try this query
SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    #category;

-- So why explicitly drop? 
	-- Think about tempdb usage for larger modules with longer session durations
	-- Think about numerous concurrent module executions
	-- Think about modules with many temporary objects 

-- We'll discuss local vs. global temporary tables later