USE Credit;
GO

-- What is the outer table?
-- What is the inner table?
-- What is the cost?
SELECT  [region].[region_name],
        [member].[lastname],
        [member].[firstname],
        [member].[member_no]
FROM    [dbo].[member]
INNER JOIN [dbo].[region]
        ON [region].[region_no] = [member].[region_no]
WHERE   [region].[region_no] = 9
OPTION  (MAXDOP 1);

-- What if we reverse OUTER/INNER?
-- Whats the cost?
SELECT  [region].[region_name],
        [member].[lastname],
        [member].[firstname],
        [member].[member_no]
FROM    [dbo].[member]
INNER JOIN [dbo].[region]
        ON [region].[region_no] = [member].[region_no]
WHERE   [region].[region_no] = 9
OPTION  (MAXDOP 1, FORCE ORDER);