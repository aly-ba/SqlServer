USE Credit;
GO

-- Which is the "build" input?
-- Which is the "probe" input?
SELECT  [member].[member_no],
        [member].[lastname],
        [payment].[payment_no],
        [payment].[payment_dt],
        [payment].[payment_amt]
FROM    [dbo].[member]
INNER JOIN [dbo].[payment]
        ON [member].[member_no] = [payment].[member_no];
GO





