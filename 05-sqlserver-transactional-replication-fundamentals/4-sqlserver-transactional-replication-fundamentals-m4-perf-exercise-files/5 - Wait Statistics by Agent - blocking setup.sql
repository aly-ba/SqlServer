-- Put in OUTPUT for the log reader and
-- distribution agents

-- Run from SQL2K12-SVR3
USE [CreditReporting];

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
BEGIN TRAN

SELECT [category_no], [category_desc]
FROM [dbo].[category]
WHERE [category_no] BETWEEN 1 AND 1000

-- Go to the second window to perform an INSERT

-- Wait
COMMIT TRAN

