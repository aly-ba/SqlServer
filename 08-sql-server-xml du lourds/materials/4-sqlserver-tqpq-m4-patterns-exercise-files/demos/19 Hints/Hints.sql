USE [Credit];
GO

SET STATISTICS IO ON;
GO

-- Include actual execution plan
SELECT  [p].[provider_name],
        [c].[charge_no],
        [c].[provider_no],
        [c].[category_no],
        [c].[charge_dt],
        [c].[charge_amt],
        [c].[charge_code]
FROM    [dbo].[provider] AS [p]
INNER HASH JOIN [dbo].[charge] AS [c]
        ON [p].[provider_no] = [c].[provider_no]
WHERE [c].[charge_amt] = 3263.00                 
OPTION  (MAXDOP 1, RECOMPILE);

SELECT  [p].[provider_name],
        [c].[charge_no],
        [c].[provider_no],
        [c].[category_no],
        [c].[charge_dt],
        [c].[charge_amt],
        [c].[charge_code]
FROM    [dbo].[provider] AS [p]
INNER MERGE JOIN [dbo].[charge] AS [c]
        ON [p].[provider_no] = [c].[provider_no]
WHERE [c].[charge_amt] = 3263.00                 
OPTION  (MAXDOP 1, RECOMPILE);

SELECT  [p].[provider_name],
        [c].[charge_no],
        [c].[provider_no],
        [c].[category_no],
        [c].[charge_dt],
        [c].[charge_amt],
        [c].[charge_code]
FROM    [dbo].[provider] AS [p]
INNER LOOP JOIN [dbo].[charge] AS [c]
        ON [p].[provider_no] = [c].[provider_no]
WHERE [c].[charge_amt] = 3263.00                 
OPTION  (MAXDOP 1, RECOMPILE);


SET STATISTICS IO OFF;
GO

-- No hint
SELECT  [p].[provider_name],
        [c].[charge_no],
        [c].[provider_no],
        [c].[category_no],
        [c].[charge_dt],
        [c].[charge_amt],
        [c].[charge_code]
FROM    [dbo].[provider] AS [p]
INNER JOIN [dbo].[charge] AS [c]
        ON [p].[provider_no] = [c].[provider_no]
WHERE [c].[charge_amt] = 3263.00                 
OPTION  (RECOMPILE, MAXDOP 1);