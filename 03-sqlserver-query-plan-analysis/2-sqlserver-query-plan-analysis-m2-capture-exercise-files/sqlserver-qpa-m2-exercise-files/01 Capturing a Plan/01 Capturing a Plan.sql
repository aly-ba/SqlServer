USE [Credit];
GO

-- SHOWPLAN_TEXT (estimated)
SET SHOWPLAN_TEXT ON;
GO

SELECT  [payment_wide].[member_no]
FROM    [dbo].[payment_wide]
WHERE   [payment_wide].[expr_dt] = '2000-10-12 10:41:34.757';
GO

SET SHOWPLAN_TEXT OFF;
GO

-- SHOWPLAN_ALL (estimated)
SET SHOWPLAN_ALL ON;
GO

SELECT  [payment_wide].[member_no]
FROM    [dbo].[payment_wide]
WHERE   [payment_wide].[expr_dt] = '2000-10-12 10:41:34.757';
GO

SET SHOWPLAN_ALL OFF;
GO

-- SHOWPLAN_XML (estimated)
SET SHOWPLAN_XML ON;
GO

SELECT  [payment_wide].[member_no]
FROM    [dbo].[payment_wide]
WHERE   [payment_wide].[expr_dt] = '2000-10-12 10:41:34.757';
GO

SET SHOWPLAN_XML OFF;
GO

-- STATISTICS PROFILE (actual)
SET STATISTICS PROFILE ON;
GO

SELECT  [payment_wide].[member_no]
FROM    [dbo].[payment_wide]
WHERE   [payment_wide].[expr_dt] = '2000-10-12 10:41:34.757';
GO

SET STATISTICS PROFILE OFF;
GO

-- STATISTICS XML (actual)
SET STATISTICS XML ON;
GO

SELECT  [payment_wide].[member_no]
FROM    [dbo].[payment_wide]
WHERE   [payment_wide].[expr_dt] = '2000-10-12 10:41:34.757';
GO

SET STATISTICS XML OFF;
GO

-- Show estimated graphical execution plan

-- Show actual execution plan
