USE Credit;
GO

-- Index Seek + RID Lookup
-- What's the cost?
SELECT  [charge].[member_no],
        [charge].[statement_no]
FROM    [dbo].[charge]
WHERE   [charge].[statement_no] = 18408;

-- Changing the NCI definition 
CREATE NONCLUSTERED INDEX [charge_statement_link] ON 
[dbo].[charge] 
(
[statement_no] ASC
)
INCLUDE (member_no)
WITH (DROP_EXISTING = ON) 
ON [PRIMARY];
GO

-- Test "covering"
-- What's the cost?
SELECT  [charge].[member_no],
        [charge].[statement_no]
FROM    [dbo].[charge]
WHERE   [charge].[statement_no] = 18408;

-- Cleanup
CREATE NONCLUSTERED INDEX [charge_statement_link] ON 
[dbo].[charge] 
(
[statement_no] ASC
)
--INCLUDE (member_no)
WITH (DROP_EXISTING = ON) 
ON [PRIMARY];
GO
