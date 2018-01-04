USE Credit;
GO

-- Which is the "build" input?
-- Which is the "probe" input?
-- What is the cost? Memory grant in KB?
SELECT  [member].[member_no],
        [member].[lastname],
        [payment].[payment_no],
        [payment].[payment_dt],
        [payment].[payment_amt]
FROM    [dbo].[member]
INNER JOIN [dbo].[payment]
        ON [member].[member_no] = [payment].[member_no];
GO
	
DBCC FREEPROCCACHE;
GO

-- What if we reversed build/probe?
-- Compare the following two queries side-by-side

-- Run both at the same time (both queries)
-- ** Actual Plan **
-- Original query
SELECT  [member].[member_no],
        [member].[lastname],
        [payment].[payment_no],
        [payment].[payment_dt],
        [payment].[payment_amt]
FROM    [dbo].[member]
INNER JOIN [dbo].[payment]
        ON [member].[member_no] = [payment].[member_no];

-- Forced query (compare memory grant)
SELECT  [member].[member_no],
        [member].[lastname],
        [payment].[payment_no],
        [payment].[payment_dt],
        [payment].[payment_amt]
FROM    [dbo].[payment]
INNER HASH JOIN [dbo].[member]
        ON [member].[member_no] = [payment].[member_no]
OPTION  (FORCE ORDER);






