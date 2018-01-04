USE Credit;
GO

-- Hash Match Aggregate
-- Is it ordered?  No index on charge_dt
SELECT  [charge].[charge_dt],
        AVG([charge].[charge_amt])
FROM    [dbo].[charge]
GROUP BY [charge].[charge_dt]
OPTION  (MAXDOP 1);

-- What if we add order?
-- Where will the sort be added?
SELECT  [charge].[charge_dt],
        AVG([charge].[charge_amt])
FROM    [dbo].[charge]
GROUP BY [charge].[charge_dt]
ORDER BY [charge].[charge_dt]
OPTION  (MAXDOP 1);
