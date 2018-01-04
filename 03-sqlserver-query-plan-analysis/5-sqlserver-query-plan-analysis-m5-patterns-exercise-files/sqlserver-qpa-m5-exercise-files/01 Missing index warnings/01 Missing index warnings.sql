USE Credit;
GO

-- Create demo table
SELECT  [c].[charge_no],
        [c].[member_no],
        [c].[provider_no],
        [c].[category_no],
        [c].[charge_dt],
        [c].[charge_amt],
        [c].[statement_no],
        [c].[charge_code]
INTO    [dbo].[charge_demo]
FROM    [dbo].[charge] AS c;
GO

-- Run together
SELECT TOP 1000
        [c].[charge_no],
        [c].[charge_amt]
FROM    [dbo].[charge_demo] AS [c]
WHERE   [c].[charge_amt] > 1000.00
ORDER BY [c].[charge_amt];

SELECT  [c].[charge_no],
        [c].[charge_amt]
FROM    [dbo].[charge_demo] AS [c]
WHERE   [c].[provider_no] = 439
ORDER BY [c].[charge_amt];
GO

-- Cleanup
DROP TABLE [dbo].[charge_demo];
GO
