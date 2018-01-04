USE Credit;
GO

DECLARE @member_no1 INT = 1
DECLARE @member_no2 INT = 2
DECLARE @member_no3 INT = 3
DECLARE @member_no4 INT = 2

-- Notice the extra iterators in this plan
SELECT  [member].[member_no],
        [member].[lastname],
        [member].[firstname]
FROM    [dbo].[member]
WHERE   [member].[member_no] IN (@member_no1, @member_no2, @member_no3,
                                 @member_no4);
GO


-- Compared to?
SELECT  [member].[member_no],
        [member].[lastname],
        [member].[firstname]
FROM    [dbo].[member]
WHERE   [member].[member_no] IN (1, 2, 3, 2);
