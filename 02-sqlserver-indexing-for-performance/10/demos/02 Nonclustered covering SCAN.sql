-------------------------------------------------------------------------------
-- Employee Case Study Sample Database Setup
-- Download location: http://bit.ly/2r6BR1g
-------------------------------------------------------------------------------

USE [master];
GO

RESTORE DATABASE [EmployeeCaseStudy]
FROM DISK = N'D:\Pluralsight\SampleDBs\EmployeeCaseStudySampleDB2012.bak'
WITH MOVE N'EmployeeCaseStudyData' 
		TO N'D:\Pluralsight\SampleDBs\EmployeeCaseStudyData.mdf',  
	 MOVE N'EmployeeCaseStudyLog' 
		TO N'D:\Pluralsight\SampleDBs\EmployeeCaseStudyLog.ldf',
	 STATS = 10, REPLACE;
GO

-- Set the database compat mode for the version you're running:
--	110 SQL Server 2012
--	120 SQL Server 2014
--	130 SQL Server 2016
-- Note: The compat mode does not affect the execution for most
-- of these indexing for performance scripts. When it does (when 
-- the cardinality estimation model affects the outcome, I will 
-- state what you will see differently).

ALTER DATABASE [EmployeeCaseStudy]
		SET COMPATIBILITY_LEVEL = 120; -- SQL Server 2014
GO

-------------------------------------------------------------------------------
-- Demo: Nonclustered covering query (nonseekable)
-------------------------------------------------------------------------------

USE [EmployeeCaseStudy];
GO

-- When you upgrade a database, you should always 
-- UPDATE STATISTICS! 
UPDATE STATISTICS [dbo].[Employee];
GO

-- Review index definitions
EXEC [sp_helpindex] '[dbo].[Employee]';
GO

-- Use this to get some insight into what's happening:
SET STATISTICS IO ON;
GO

-- NOTE: I/Os alone are not the ONLY way to understand
-- what's going on. We'll add graphical showplan as well.
-- Use Query, Include Actual Execution Plan


-- What's best to return data limited by EmployeeID?
-- Reminder: clustered index on EmployeeID
SELECT [e].[EmployeeID], [e].[SSN]
FROM [dbo].[Employee] AS [e]
WHERE [e].[EmployeeID] < 10000;
GO

-- What about a clustered index seek?
SELECT [e].[EmployeeID], [e].[SSN]
FROM [dbo].[Employee] AS [e] WITH (INDEX = 1)
WHERE [e].[EmployeeID] < 10000;
GO  

-------------------------------------------------------------------------------
-- While it sounds strange that nonclustered covering
-- SCAN is better than a clustered seek, it's all about
-- the I/Os / costs / data selectivity!
-------------------------------------------------------------------------------
