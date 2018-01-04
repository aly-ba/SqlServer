USE Credit;
GO

SELECT  [statement].[statement_no],
        [statement].[member_no],
        [statement].[statement_amt],
        [statement].[statement_code],
        DAY([statement].[statement_dt]) AS [statment_due_day]
FROM    [dbo].[statement];
GO



