USE Credit;
GO

-- Stream Aggregate (Scalar)
-- Ordering doesn't matter here!
SELECT  SUM([charge].[charge_amt]),
        AVG([charge].[charge_amt])
FROM    [dbo].[charge]
OPTION  (MAXDOP 1);

-- Stream Aggregate (grouping)
-- Check order of the index scan
SELECT  [charge].[category_no],
        COUNT(*)
FROM    [dbo].[charge]
GROUP BY [charge].[category_no]
OPTION  (MAXDOP 1);