USE [Credit];
GO

-- ** Enable Actual Showplan Plan ** --

-- 1) Relative Batch costs
-- 2) Within statement
-- 3) Subtree cost

-- ** Execute two SELECTs together **
SELECT  [payment_wide].[member_no]
FROM    [dbo].[payment_wide]
WHERE   [payment_wide].[expr_dt] = '2000-10-12 10:41:34.757';

SELECT  [member].[member_no],
        [member].[lastname],
        [member].[firstname],
        [member].[middleinitial],
        [corporation].[corp_no],
        [corporation].[corp_name]
FROM    [dbo].[member]
INNER JOIN [dbo].[corporation]
        ON [corporation].[corp_no] = [member].[corp_no];
GO

-- Clustered Index Seek -> 1 Row
-- What's the Estimated I/O cost?
SELECT  [member].[lastname]
FROM [dbo].[member]
WHERE [member].[member_no] = 1;

-- Find the Page ID so we can check the cache
SELECT  [lastname],
		sys.fn_PhysLocFormatter(%%physloc%%)
FROM [dbo].[member]
WHERE [member_no] = 1;

SELECT  [database_id],
        [file_id],
        [page_id],
        [page_level],
        [allocation_unit_id],
        [page_type],
        [row_count],
        [free_space_in_bytes],
        [is_modified],
        [numa_node],
        [read_microsec]
FROM    sys.dm_os_buffer_descriptors
WHERE   page_id = 248 AND
        database_id = DB_ID();

-- Since its cached, does cost change?
SELECT  [member].[lastname]
FROM    [dbo].[member]
WHERE   [member].[member_no] = 1;

-- Let's get it out of cache
DBCC DROPCLEANBUFFERS;

SELECT COUNT(*)
FROM [sys].[dm_os_buffer_descriptors]
WHERE [page_id] = 248 AND
		[database_id] = DB_ID();
		
-- Check cost again (no difference)
SELECT  [member].[lastname]
FROM    [dbo].[member]
WHERE   [member].[member_no] = 1;

-- What about for a Clustered Index Scan?
-- What's the estimated I/O?
SELECT  [member].[member_no],
        [member].[lastname]
FROM    [dbo].[member];

-- How many pages in the table?
SELECT  [dm_db_partition_stats].[in_row_data_page_count]
FROM    [sys].[dm_db_partition_stats]
WHERE   [dm_db_partition_stats].[object_id] = OBJECT_ID('dbo.member') AND
        [dm_db_partition_stats].[index_id] = 1;

-- Random I/O - 0.003125
-- Sequential - 0.000740741
SELECT	0.003125 +
		0.000740741 * (142-1);
		
-- Compare the estimated I/O value to the plan

-- Now let's change the statistics for dbo.member
-- ** Don't do this in production, please **
UPDATE STATISTICS [dbo].[member]
WITH ROWCOUNT = 75000000, PAGECOUNT = 149000

-- What's the new estimated I/O?
SELECT  [member].[member_no],
        [member].[lastname]
FROM    [dbo].[member]
OPTION  (RECOMPILE);
GO

-- 110.373
SELECT	0.003125 +
		0.000740741 * (149000-1)
-- 110.372793259
GO

-- Restore database back to original