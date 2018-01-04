/****************************************************************
Course by: 	Pinal Dave  (http://blog.sqlauthority.com)
			Vinod Kumar (http://blogs.extremeExperts.com)

Scripts for SQL Server Performance: Query Tuning ©Pluralsight.

Description: Indexed Views Performance and usage with NOExpand

****************************************************************/
USE tempdb
GO
IF EXISTS (SELECT * FROM sys.views WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[SampleView]'))
DROP VIEW [dbo].[SampleView]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[mySampleTable]') AND TYPE IN (N'U'))
DROP TABLE [dbo].[mySampleTable]
GO
-- Create SampleTable
CREATE TABLE mySampleTable (ID1 INT, ID2 INT, SomeData VARCHAR(100))
INSERT INTO mySampleTable (ID1,ID2,SomeData)
SELECT TOP 100000 ROW_NUMBER() OVER (ORDER BY o1.name),
ROW_NUMBER() OVER (ORDER BY o2.name),
o2.name
FROM sys.all_objects o1
CROSS JOIN sys.all_objects o2
GO
-- Create View
CREATE VIEW SampleView
WITH SCHEMABINDING
AS
SELECT ID1,ID2,SomeData
FROM dbo.mySampleTable
GO
-- Create Index on View
CREATE UNIQUE CLUSTERED INDEX [IX_ViewSample] ON [dbo].[SampleView]
(
ID2 ASC
)
GO
-- CTRL + M 
-- Select from view
SELECT ID1,ID2,SomeData
FROM SampleView
GO

-- Select from view
SELECT ID1,ID2,SomeData
FROM SampleView WITH (NOEXPAND)
GO