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
-- Demo: Using a SCAN to find data
-------------------------------------------------------------------------------

USE [EmployeeCaseStudy];
GO

-- What tables exist?
SELECT [t].* 
FROM [sys].[tables] AS [t];
GO

-------------------------------------------------------------------------------
-- Employee Table as a Clustered Table
-------------------------------------------------------------------------------

-- Review table definition and indexes
EXEC [sp_help] '[dbo].[Employee]';
GO

-- Use this to get some insight into what's happening:
SET STATISTICS IO ON;
GO

-- NOTE: IOs alone are not the ONLY way to understand
-- what's going on. We'll add graphical showplan as well.
-- Use Query, Include Actual Execution Plan

-- Obvious case where a scan must be performed
SELECT [e].* 
FROM [dbo].[Employee] AS [e]
WHERE [e].[LastName] LIKE N'%e%';
GO

-- A more selective case where we should be able
-- to limit the search, but we can't - why?
SELECT [e].* 
FROM [dbo].[Employee] AS [e]
WHERE [e].[LastName] LIKE N'E%';
GO

-- A VERY selective case which should be able
-- to access more effectively - but again, a SCAN - why?
SELECT [e].* 
FROM [dbo].[Employee] AS [e]
WHERE [e].[LastName] = N'Eaton';
GO


-------------------------------------------------------------------------------
-- Employee Table as a Heap
-------------------------------------------------------------------------------

-- Review table definition and indexes
EXEC [sp_help] [EmployeeHeap];
GO

-- Obvious case where a scan must be performed
SELECT [e].* 
FROM [dbo].[EmployeeHeap] AS [e]
WHERE [e].[LastName] LIKE N'%e%';
GO

-- A more selective case where we should be able
-- to limit the search, but we can't - why?
SELECT [e].* 
FROM [dbo].[EmployeeHeap] AS [e]
WHERE [e].[LastName] LIKE N'E%';
GO

-- A VERY selective case which should be able
-- to access more effectively - but again, a SCAN - why?
SELECT [e].* 
FROM [dbo].[EmployeeHeap] AS [e]
WHERE [e].[LastName] = N'Eaton';
GO


-------------------------------------------------------------------------------
-- Scan is not limited to "table" scans
-------------------------------------------------------------------------------

-- Review index definitions again
EXEC [sp_help] '[dbo].[Employee]';
GO

-- More details coming on why this is interesting
SELECT [e].[EmployeeID], [e].[SSN]
FROM [dbo].[Employee] AS [e];
GO

-------------------------------------------------------------------------------
-- Scan solely refers to a way to exhaustively search
-- a particular structure 
-- (we'll talk a lot more about this)
-------------------------------------------------------------------------------
