USE Credit;
GO

-- What is the estimated cost?
SELECT TOP 1000
        [charge].[charge_no]
FROM    [dbo].[charge]
ORDER BY [charge].[charge_dt]
OPTION  (MAXDOP 1);

-- What if we create a supporting index?
CREATE NONCLUSTERED INDEX charge_charge_dt ON
[dbo].[charge](charge_dt);
GO

-- What is the estimated cost?
SELECT TOP 1000
        [charge].[charge_no]
FROM    [dbo].[charge]
ORDER BY [charge].[charge_dt]
OPTION  (MAXDOP 1);


-- Cleanup
DROP INDEX charge.charge_charge_dt;
