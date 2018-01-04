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
-- Setup IndexPagesOutput table
-------------------------------------------------------------------------------

-- Many examples use the DBCC IND command but change the output 
-- in some way (e.g. change the sort or only look at one level). 
-- To do this easily, use the IndexPagesOutput table to store
-- the output from DBCC IND.

USE [EmployeeCaseStudy];
GO

IF OBJECTPROPERTY(object_id('[IndexPagesOutput]'), 'IsUserTable') IS NOT NULL
    DROP TABLE [IndexPagesOutput];
GO

CREATE TABLE [IndexPagesOutput]
(
    [PageFID]			tinyint,
    [PagePID]			int,
    [IAMFID]			tinyint,
    [IAMPID]			int,
    [ObjectID]			int,
    [IndexID]			tinyint,
    [PartitionNumber]	tinyint,
    [PartitionID]		bigint,
    [iam_chain_type]	varchar(30),
    [PageType]			tinyint,
    [IndexLevel]		tinyint,
    [NextPageFID]		tinyint,
    [NextPagePID]		int,
    [PrevPageFID]		tinyint,
    [PrevPagePID]		int,
    CONSTRAINT [IndexPagesOutput_PK]
        PRIMARY KEY ([PageFID], [PagePID])
);
GO

-------------------------------------------------------------------------------
-- Demo: Clustered Index Internals
-------------------------------------------------------------------------------

USE [EmployeeCaseStudy];
GO

-- Review table definition and indexes
EXEC [sp_help] '[dbo].[Employee]';
GO

-------------------------------------------------------------------------------
-- Analyze the Employee Table's Clustered Index
-------------------------------------------------------------------------------

SELECT [index_depth] AS [D]
    , [index_level] AS [L]
    , [record_count] AS [Rows]
    , [page_count] AS [Pages]
    , [avg_page_space_used_in_percent] AS [Page:Percent Full]
    , [min_record_size_in_bytes] AS [Row:MinLen]
    , [max_record_size_in_bytes] AS [Row:MaxLen]
    , [avg_record_size_in_bytes] AS [Row:AvgLen]
FROM [sys].[dm_db_index_physical_stats]
    (DB_ID (N'EmployeeCaseStudy')					-- Database ID
    , OBJECT_ID (N'EmployeeCaseStudy.dbo.Employee')  -- Object ID
    , 1												-- Index ID
	  -- The Index ID for the clustered index (if exists) is always 1.
    , NULL											-- Partition ID
    , 'DETAILED');									-- Mode
GO

TRUNCATE TABLE [IndexPagesOutput];
INSERT [IndexPagesOutput]
EXEC ('DBCC IND ([EmployeeCaseStudy], ''[dbo].[Employee]'', 1)');
GO

SELECT [IndexLevel]
    , [PageFID]
    , [PagePID]
    , [PrevPageFID]
    , [PrevPagePID]
    , [NextPageFID]
    , [NextPagePID]
FROM [IndexPagesOutput]
ORDER BY [IndexLevel] DESC, [PrevPagePID];
GO

-------------------------------------------------------------------------------
-- Reviewing that output 
-- The root page will have the highest IndexLevel. Because of 
-- the ORDER BY it will be the first row in the output.

-- The root page will reference all of the pages in the next level down.
-- Each of those pages will reference a number of pages in the next level down
-- until you reach the leaf level. Using DBCC PAGE, you can reverse-engineer 
-- the entire index structure.
-------------------------------------------------------------------------------

DBCC TRACEON (3604); 
GO

DBCC PAGE (EmployeeCaseStudy, 1, 338, 3); -- first page of level 2
	-- 7 rows, this shows the 7 pages (in order) of the intermediate level

-- Analyze the intermediate level (which also points to the leaf)
DBCC PAGE (EmployeeCaseStudy, 1, 336, 3); -- first page of level 1 (622 rows)
DBCC PAGE (EmployeeCaseStudy, 1, 337, 3); -- second page of level 1 (622 rows)
DBCC PAGE (EmployeeCaseStudy, 1, 339, 3); -- third page of level 1 (622 rows)
DBCC PAGE (EmployeeCaseStudy, 1, 340, 3); -- fourth page of level 1 (622 rows)
DBCC PAGE (EmployeeCaseStudy, 1, 341, 3); -- fifth page of level 1 (622 rows)
DBCC PAGE (EmployeeCaseStudy, 1, 342, 3); -- sixth page of level 1 (622 rows)
DBCC PAGE (EmployeeCaseStudy, 1, 343, 3); -- LAST page of level 1 (268 rows)

-- Analyze the leaf level (which IS the data)
DBCC PAGE (EmployeeCaseStudy, 1, 304, 3); -- first page of level 0
DBCC PAGE (EmployeeCaseStudy, 1, 305, 3); -- second page of level 0
DBCC PAGE (EmployeeCaseStudy, 1, 306, 3); -- third page of level 0
-- ...
DBCC PAGE (EmployeeCaseStudy, 1, 4335, 3); -- LAST page of level 0
GO

-------------------------------------------------------------------------------
-- Navigate the Employee Table's Clustered Index to find a row
-------------------------------------------------------------------------------

-- WITHOUT RUNNING this query try to visualize the process of accessing
-- this data. How would SQL Server find this row?
SELECT [e].* 
FROM [dbo].[Employee] AS [e]
WHERE [e].[EmployeeID] = 27682;
GO

-- SQL Server starts at the root page and navigates down to the leaf level. 
-- Based on the output shown previously, the root page is page 338 in file 
-- ID 1 (you can see this because the root page is the only page at the 
-- highest index level: IndexLevel = 2). 

DBCC PAGE (EmployeeCaseStudy, 1, 338, 3); -- first page of level 2
GO

-- For the third page, you can see a low value of 24,881, and for the fourth 
-- page, a low value of 37,321. So if the value 27,682 exists, it would have 
-- to be in the index area defined by this particular range.

DBCC PAGE (EmployeeCaseStudy, 1, 339, 3);
GO

-- Review the values. For the 141st row, you can see a low value of 27,681, 
-- and for the 142nd row, a low value of 27,701. So if the value 27,682 exists, 
-- it would have to be on ChildFileId = 1 and ChildPageId = 1712.

DBCC PAGE (EmployeeCaseStudy, 1, 1720, 3);
GO

-- By scanning this page, you can see that a record of 27,682 does exist and it
-- represents a record for Burt R Arbariol.