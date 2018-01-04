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
--       isn't always best - it depends on the data!
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


-- When there are 10,000 rows, the NC covering SCAN is best:
SELECT [e].[EmployeeID], [e].[SSN]
FROM [dbo].[Employee] AS [e]
WHERE [e].[EmployeeID] < 10000;
GO

-- If there are only 1,000 rows, the clustered index seek is better:
SELECT [e].[EmployeeID], [e].[SSN]
FROM [dbo].[Employee] AS [e] 
WHERE [e].[EmployeeID] < 1000;
GO  

-- If this query were critical, I'd *CONSIDER* creating
-- a nonclustered, covering, SEEKABLE index:
CREATE INDEX [NCCoveringSeekableIX] 
ON [dbo].[Employee] ([EmployeeID], [SSN]);
GO

-- Now, it doesn't matter what range I use!
SELECT [e].[EmployeeID], [e].[SSN]
FROM [dbo].[Employee] AS [e]
WHERE [e].[EmployeeID] < 10000;
GO

-- It's still best:
SELECT [e].[EmployeeID], [e].[SSN]
FROM [dbo].[Employee] AS [e] 
WHERE [e].[EmployeeID] < 1000;
GO  

-- It's still best - even here:
SELECT [e].[EmployeeID], [e].[SSN]
FROM [dbo].[Employee] AS [e] 
WHERE [e].[EmployeeID] < 80000;
GO  

-------------------------------------------------------------------------------
-- More than anything - what's best depends on the QUERY
-- and the different costs of the possible options!

-- For critical queries, I'd consider covering but be careful
-- covering ALWAYS works (and VERY well). 

-- You do not want to over index! (more coming up!)
-------------------------------------------------------------------------------
