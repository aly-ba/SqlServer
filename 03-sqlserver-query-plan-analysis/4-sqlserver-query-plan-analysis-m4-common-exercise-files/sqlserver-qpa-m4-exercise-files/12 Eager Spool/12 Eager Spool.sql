USE Credit;
GO

-- Demo table
SELECT  [c].[charge_no],
        [c].[member_no],
        [c].[provider_no],
        [c].[category_no],
        [c].[charge_dt],
        [c].[charge_amt],
        [c].[statement_no],
        [c].[charge_code]
INTO    [dbo].[charge_update_demo]
FROM    [dbo].[charge] AS c;
GO


-- Indexes for charge_amt
CREATE NONCLUSTERED INDEX [charge_charge_amt] ON
[dbo].[charge_update_demo] ([charge_amt]);
GO

UPDATE  [dbo].[charge_update_demo]
SET     [charge_update_demo].[charge_amt] = 
			[charge_update_demo].[charge_amt] * 1.05
WHERE   [charge_update_demo].[charge_amt] < 1000.00
OPTION  (MAXDOP 1);


DROP TABLE [dbo].[charge_update_demo];
GO