USE Credit;
GO

SET STATISTICS IO ON;
GO

-- Work table?
SELECT TOP 1000
         [c1].[charge_no],
                [c1].[member_no],
                [c1].[provider_no],
                [c1].[category_no],
                [c1].[charge_dt],
                [c1].[charge_amt],
                [c1].[statement_no],
                [c1].[charge_code],
                [c2].[charge_no],
                [c2].[member_no],
                [c2].[provider_no],
                [c2].[category_no],
                [c2].[charge_dt],
                [c2].[charge_amt],
                [c2].[statement_no],
                [c2].[charge_code]
FROM    [dbo].[charge] c1
INNER MERGE JOIN [dbo].[charge] c2
        ON [c1].[member_no] = [c2].[member_no]
OPTION  (MAXDOP 1);
GO

SET STATISTICS IO OFF;
GO