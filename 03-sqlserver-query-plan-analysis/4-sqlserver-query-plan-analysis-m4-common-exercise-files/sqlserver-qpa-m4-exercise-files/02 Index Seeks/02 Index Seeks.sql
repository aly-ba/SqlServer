USE Credit;
GO

-- Indexes on payment?
EXEC dbo.sp_helpindex 'payment';
GO

-- Index seek (nonclustered)
-- * Post-recording Update - the query plan will also show a RID lookup *
SELECT [member_no], [payment_dt]
FROM dbo.[payment]
WHERE [member_no] = 98;

-- Recreate as clustered
DROP INDEX [payment_member_link] ON [dbo].[payment]
GO

CREATE CLUSTERED INDEX [payment_member_link] 
ON [dbo].[payment] 
(
	[member_no] ASC
) ON [PRIMARY];
GO

-- Index seek (nonclustered)
SELECT [member_no], [payment_dt]
FROM dbo.[payment]
WHERE [member_no] = 98;

