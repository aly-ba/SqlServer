-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

SELECT TOP 100
        [charge_no],
        [member_no],
        [provider_no],
        [category_no],
        [charge_dt],
        [charge_amt],
        [statement_no],
        [charge_code]
INTO    #charge_etl
FROM    [dbo].[charge]
ORDER BY [charge_no];
GO

-- Definition?
EXEC [tempdb].[sys].[sp_help] #charge_etl;
GO

-- I can make table definition modifications
-- For example:
ALTER TABLE #charge_etl
ADD [etl_movement_flag] BIT NULL;
GO

-- Definition
EXEC [tempdb].[sys].[sp_help] #charge_etl;
GO

SELECT TOP 10
        [charge_no],
        [member_no],
        [provider_no],
        [category_no],
        [charge_dt],
        [charge_amt],
        [statement_no],
        [charge_code],
        [etl_movement_flag]
FROM    [#charge_etl];
GO

-- Changing a data type
ALTER TABLE #charge_etl
ALTER COLUMN [etl_movement_flag] TINYINT;
GO

-- Definition
EXEC [tempdb].[sys].[sp_help] #charge_etl;
GO

-- Dropping a column
ALTER TABLE #charge_etl
DROP COLUMN [etl_movement_flag];
GO

-- Definition
EXEC [tempdb].[sys].[sp_help] #charge_etl;
GO

-- Cleanup
DROP TABLE [#charge_etl];
GO
