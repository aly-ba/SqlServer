/****************************************************************
Course by: 	Pinal Dave  (http://blog.sqlauthority.com)
			Vinod Kumar (http://blogs.extremeExperts.com)

Scripts for SQL Server Performance: Query Tuning ©Pluralsight.

Description: Indexed Views and Alter Table combination.

****************************************************************/
USE AdventureWorks2012
GO
IF EXISTS (SELECT * FROM sys.views WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[LimitView4]'))
DROP VIEW [dbo].[LimitView4]
GO
-- Create View
CREATE VIEW LimitView4
AS
SELECT *
FROM HumanResources.Shift
GO
-- Select from original table
SELECT *
FROM HumanResources.Shift
GO
-- Select from View
SELECT *
FROM LimitView4
GO
-- Add Column to original Table
ALTER TABLE HumanResources.Shift
ADD AdditionalCol INT
GO
-- Select from original table
SELECT *
FROM HumanResources.Shift
GO
-- Select from View
SELECT *
FROM LimitView4
GO
-- Refresh the view
EXEC sp_refreshview 'LimitView4'
GO
-- Select from original table
SELECT *
FROM HumanResources.Shift
GO
-- Select from View
SELECT *
FROM LimitView4
GO
-- Clean up
ALTER TABLE HumanResources.Shift
DROP COLUMN AdditionalCol
GO