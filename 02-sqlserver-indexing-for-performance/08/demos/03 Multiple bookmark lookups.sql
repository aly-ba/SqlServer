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
-- Demo: Nonclustered index seek with multiple bookmark
--       lookups
-------------------------------------------------------------------------------

USE [EmployeeCaseStudy];
GO

-- Review table definition and indexes
EXEC [sp_help] '[dbo].[Employee]';
GO

-- Use this to get some insight into what's happening:
SET STATISTICS IO ON;
GO

-- NOTE: I/Os alone are not the ONLY way to understand
-- what's going on. We'll add graphical showplan as well.
-- Use Query, Include Actual Execution Plan

SELECT [e].* 
FROM [dbo].[Employee] AS [e]
WHERE [e].[SSN] BETWEEN '123-45-6789' AND '123-45-6800';
GO  -- 0 rows so only the nonclustered seek is performed
 

-- What if we actually have a set of 12 SSNs? 
-- 12 rows and on only 1 page in the NC leaf-level
SELECT [e].* 
FROM [dbo].[Employee] AS [e]
WHERE [e].[SSN] BETWEEN '123-43-4550' AND '123-67-0000';
GO  

-- What if we actually have a set of 12 SSNs?
-- 12 rows and over 2 pages in the NC leaf-level
SELECT [e].* 
FROM [dbo].[Employee] AS [e]
WHERE [e].[SSN] BETWEEN '123-83-7970' AND '123-95-0000';
GO  

-------------------------------------------------------------------------------
-- Bookmark lookups allow you to find data based
-- on secondary index keys
-- This is OK when the set is small...
-------------------------------------------------------------------------------
