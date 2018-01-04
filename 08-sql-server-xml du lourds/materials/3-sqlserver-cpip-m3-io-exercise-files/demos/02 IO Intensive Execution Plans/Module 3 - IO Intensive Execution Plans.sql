USE [Credit];
GO

SELECT  [m].[firstname],
        [m].[lastname],
        [c].[charge_no],
        [c].[charge_dt],
        SUM([c].[charge_amt]) max_amount
FROM    [dbo].[member] m
INNER JOIN [dbo].[charge] c
        ON [m].[member_no] = [c].[member_no]
WHERE   [c].[charge_amt] > 1000.00 AND
        [m].[region_no] = 2 AND
        [c].[charge_dt] = '1999-08-10 10:49:15.030'
GROUP BY [m].[firstname],
        [m].[lastname],
        [c].[charge_no],
        [c].[charge_dt]
HAVING  MAX([c].[charge_amt]) > 2000.00;
GO

EXEC sp_helpindex 'charge';
GO

CREATE NONCLUSTERED INDEX [IX_charge_charge_dt]
ON [dbo].[charge] ([charge_dt],[charge_amt])
GO

-- Cleanup
DROP INDEX [IX_charge_charge_dt] ON [dbo].[charge]
GO