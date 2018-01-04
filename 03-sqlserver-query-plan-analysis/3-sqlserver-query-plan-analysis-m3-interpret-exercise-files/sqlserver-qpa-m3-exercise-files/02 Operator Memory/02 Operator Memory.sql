USE [Credit];
GO

-- What are the memory requirements?
SELECT  [member].[member_no],
        [member].[lastname],
        [payment].[payment_no],
        [payment].[payment_dt],
        [payment].[payment_amt]
FROM    [dbo].[member]
INNER JOIN [dbo].[payment]
        ON [member].[member_no] = [payment].[member_no];

-- Now what are the memory requirements?
SELECT  [member].[member_no],
        [member].[lastname],
        [payment].[payment_no],
        [payment].[payment_dt],
        [payment].[payment_amt]
FROM    [dbo].[member]
INNER JOIN [dbo].[payment]
        ON [member].[member_no] = [payment].[member_no]
OPTION  (FAST 1);