-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

DECLARE @category TABLE
(
 [category_no] INT,
 [category_desc] VARCHAR(31) NOT NULL,
 [category_code] CHAR(2) NOT NULL
);
GO


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



-- The scope is for the duration of batch execution
-- Pros: No need to cleanup at batch completion, implies shorter lifecycle
-- Cons: Cannot cross batch boundaries