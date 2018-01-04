USE [Credit];
GO

-- Sample query for a SQL Profiler trace, XE Session
SELECT  [payment_wide].[member_no]
FROM    [dbo].[payment_wide]
WHERE   [payment_wide].[expr_dt] = '2000-10-12 10:41:34.757';
GO

