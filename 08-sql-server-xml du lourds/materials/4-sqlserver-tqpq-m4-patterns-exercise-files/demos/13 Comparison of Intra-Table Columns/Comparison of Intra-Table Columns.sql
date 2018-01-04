USE [Credit];
GO

SELECT  [statement_no],
        [member_no],
        [statement_amt],
        [statement_code]
FROM    [dbo].[statement]
WHERE   [statement_dt] < [due_dt];
GO

ALTER TABLE [dbo].[statement]
ADD [delta_statement_due_dt] AS
(DATEDIFF(ms, [statement_dt], [due_dt]));
GO

SELECT  [statement_no],
        [member_no],
        [statement_amt],
        [statement_code],
        [delta_statement_due_dt]
FROM    [dbo].[statement]
WHERE   [delta_statement_due_dt] > 0;
GO

EXEC sp_helpstats 'statement';


-- Cleanup
ALTER TABLE [dbo].[statement]
DROP COLUMN [delta_statement_due_dt];
GO