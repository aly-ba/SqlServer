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
-- Demo: Using a bookmark lookup to find data
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


-- Think like an index in the back of a book... you
-- reference one thing (the index key) but then have
-- to go to the data to get more information.

-- The table (i.e. the "book") is structured by the 
-- clustering key of EmployeeID 

-- The reference (i.e. the index in the back of the book)
-- is SSN (the nonclustered index)

SELECT [e].* 
FROM [dbo].[Employee] AS [e]
WHERE [e].[SSN] = '749-21-9445';
GO

-------------------------------------------------------------------------------
-- Employee Table as a Heap
-------------------------------------------------------------------------------

-- Review table definition and indexes
EXEC [sp_help] [EmployeeHeap];
GO

-- With a HEAP the "book" is unstructured 
-- But, there are still secondary reference columns such
-- as EmployeeID and SSN (the nonclustered indexes)

-- Bookmark lookup from a nonclustered to a heap
SELECT [e].* 
FROM [dbo].[EmployeeHeap] AS [e]
WHERE [e].[EmployeeID] = 12345;
GO

-- Bookmark lookup from a nonclustered to a heap
SELECT [e].* 
FROM [dbo].[EmployeeHeap] AS [e]
WHERE [e].[SSN] = '749-21-9445';
GO

-------------------------------------------------------------------------------
-- Bookmark lookups allow you to find data based
-- on secondary index keys
-- (we'll talk a lot more about this)
-------------------------------------------------------------------------------
