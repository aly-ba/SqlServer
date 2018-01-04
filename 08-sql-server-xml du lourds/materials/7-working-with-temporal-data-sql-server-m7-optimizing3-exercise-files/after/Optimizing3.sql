/************************************************/
/* Working with Temporal Data in SQL Server     */
/* Module 7: Optimizing Temporal Queries Part 3 */
/************************************************/


/******************************/
/* Demo 1: Interval Data Type */
/******************************/

-- Module 2 to 6 demos should be finished
SET NOCOUNT ON;
USE TemporalData;
GO

-- Create and populate IntervalsCID table
-- 37 s
CREATE TABLE dbo.IntervalsCID
(
  id     INT NOT NULL,
  during IntervalCID NOT NULL
);

INSERT INTO dbo.IntervalsCID WITH(TABLOCK) (id, during)
  SELECT id, N'(' + CAST(b AS NVARCHAR(10)) +':' +
   CAST(e AS NVARCHAR(10)) + ')'
  FROM dbo.Stage;

ALTER TABLE dbo.IntervalsCID ADD CONSTRAINT
 PK_IntervalsCID PRIMARY KEY(id);

CREATE INDEX idx_IntervalCID ON dbo.IntervalsCID(during);
GO
-- Slightly slower insert - please note that the insert code is not optimized for IntervalCID

-- Check the data
SELECT TOP 1000 *, during.ToString()
FROM dbo.IntervalsCID
ORDER BY during DESC;
SELECT COUNT(*), MIN(during.BeginInt), MAX(during.EndInt)
FROM dbo.IntervalsCID;
GO

-- query
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- middle of data - naive solution
-- logical reads: 23779, CPU time: ~7000 ms
DECLARE @l AS INT = 5000000, @u AS INT = 5000020;
DECLARE @i AS IntervalCID;
-- An interval to filter exactly the intervals needed,
-- the ones that really overlap with the given one
SET @i = N'(' + CAST(@l AS NVARCHAR(10)) +':'
 + CAST(@u AS NVARCHAR(10)) + ')';

SELECT id
FROM dbo.IntervalsCID AS I
WHERE @i.Overlaps(I.during) = 1
OPTION (RECOMPILE);   
GO


-- Optimized solution

-- beginning of data
-- logical reads: 3, CPU time: 0 ms
DECLARE @l AS INT = 80, @u AS INT = 100;
DECLARE @max AS INT = 20;   -- max length in the data is 20
DECLARE @b AS IntervalCID, @e AS IntervalCID, @i AS IntervalCID;
-- An interval whose sort value is low enough to filter out 
-- the intervals before the given one
SET @b = N'(' + CAST((@l - 1 - @max) AS NVARCHAR(8)) +':'
 + CAST((@l-1) AS NVARCHAR(8)) + ')';
-- An interval whose sort value is high enough to filter out
-- the intervals after the given one
SET @e = N'(' + CAST((@u+1) AS NVARCHAR(8)) +':'
 + CAST((@u+1) AS NVARCHAR(8)) + ')';
-- An interval to filter excatly the intervals needed,
-- the ones that really ovelap with the given one
SET @i = N'(' + CAST(@l AS NVARCHAR(8)) +':' + CAST(@u AS NVARCHAR(8)) + ')';

SELECT id
FROM dbo.IntervalsCID AS I
WHERE during < @e AND during > @b
  AND @i.Overlaps(I.during) = 1
OPTION (RECOMPILE);
GO

-- end of data
-- logical reads: 3, CPU time: 0 ms
DECLARE @l AS INT = 10000000 - 100, @u AS INT = 10000000 - 80;
DECLARE @max AS INT = 20;   -- max length in the data is 20
DECLARE @b AS IntervalCID, @e AS IntervalCID, @i AS IntervalCID;
-- An interval whose sort value is low enough to filter out
-- the intervals before the given one
SET @b = N'(' + CAST((@l - 1 - @max) AS NVARCHAR(8)) +':'
 + CAST((@l-1) AS NVARCHAR(8)) + ')';
-- An interval whose sort value is high enough to filter
-- out the intervals after the given one
SET @e = N'(' + CAST((@u+1) AS NVARCHAR(8)) +':'
 + CAST((@u+1) AS NVARCHAR(8)) + ')';
-- An interval to filter excatly the intervals needed,
-- the ones that really ovelap with the given one
SET @i = N'(' + CAST(@l AS NVARCHAR(8)) +':'
 + CAST(@u AS NVARCHAR(8)) + ')';

SELECT id
FROM dbo.IntervalsCID AS I
WHERE during < @e AND during > @b
  AND @i.Overlaps(I.during) = 1
OPTION (RECOMPILE);
GO

-- middle of data - optimized solution
DECLARE @l AS INT = 5000000, @u AS INT = 5000020;
DECLARE @max AS INT = 20;   -- max length in the data is 20
DECLARE @b AS IntervalCID, @e AS IntervalCID, @i AS IntervalCID;
-- An interval whose sort value is low enough to filter out
-- the intervals before the given one
SET @b = N'(' + CAST((@l - 1 - @max) AS NVARCHAR(10)) + ':'
 + CAST((@l-1) AS NVARCHAR(10)) + ')';
-- An interval whose sort value is high enough to filter out
-- the intervals after the given one
SET @e = N'(' + CAST((@u+1) AS NVARCHAR(10)) + ':'
 + CAST((@u+1) AS NVARCHAR(10)) + ')';
-- An interval to filter exactly the intervals needed,
-- the ones that really overlap with the given one
SET @i = N'(' + CAST(@l AS NVARCHAR(10)) +':'
 + CAST(@u AS NVARCHAR(10)) + ')';

SELECT id
FROM dbo.IntervalsCID AS I
WHERE during < @e AND during > @b
  AND @i.Overlaps(I.during) = 1
OPTION (RECOMPILE);   
GO
-- logical reads: 4, CPU time: 0 ms


-- Note: all of these queries filter efficiently the right side
-- and less efficiently the left side if the maximum length of the intervals is substantially larger.
-- For example, test with @max = 10000000 - the query that queries the end of the data scans the complete table.
-- This is because there is only one index on the type as a whole in order left, right.
-- Also, the calculation of the maximum interval length value is simplified down to using a constant.
-- To catch up with the T-SQL solution, the BeginInd and EndInt properties should be persisted and indexed
-- and then used like the lower and upper columns in the T-SQL solution.

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO


/*************************/
/* Demo 2: Unpacked Form */
/*************************/

-- Numbers table
-- Auxiliary table of numbers
-- Need a table, not a function
-- Must use JOIN and not APPLY for an indexed view

IF OBJECT_ID('dbo.Nums', 'U') IS NOT NULL DROP TABLE dbo.Nums;
CREATE TABLE dbo.Nums
 (n INT NOT NULL PRIMARY KEY);
GO

DECLARE @max AS INT, @rc AS INT, @d AS DATE;
SET @max = 10000000;
SET @rc = 1;

INSERT INTO dbo.Nums VALUES(1);
WHILE @rc * 2 <= @max
BEGIN
  INSERT INTO dbo.Nums 
  SELECT n + @rc FROM dbo.Nums;
  SET @rc = @rc * 2;
END

INSERT INTO dbo.Nums
  SELECT n + @rc
  FROM dbo.Nums 
  WHERE n + @rc <= @max;
GO

-- Check data
SELECT TOP 1000 * FROM dbo.Nums
GO

-- Create and populate IntervalsU table
CREATE TABLE dbo.IntervalsU
(
  id    INT NOT NULL,
  b     INT NOT NULL,
  e     INT NOT NULL,
  CONSTRAINT CHK_IntervalsU_upper_gteq_lower CHECK(e >= b)
);
GO

-- Create view Intervals_Unpacked
IF OBJECT_ID('dbo.Intervals_Unpacked', 'V') IS NOT NULL
   DROP VIEW dbo.Intervals_Unpacked;
GO

CREATE VIEW dbo.Intervals_Unpacked
WITH SCHEMABINDING
AS
SELECT I.id, N.n
FROM dbo.IntervalsU AS I
 INNER JOIN dbo.Nums AS N
  ON N.n BETWEEN I.b AND I.e;
GO

-- Index the view
CREATE UNIQUE CLUSTERED INDEX PK_Intervals_Unpacked
 ON dbo.Intervals_Unpacked(n, id);
GO

-- Insert the data
-- SLOW! (4:20 min)
INSERT INTO dbo.IntervalsU WITH(TABLOCK) (id, b, e)
  SELECT id, b, e
  FROM dbo.Stage;
GO

-- Check the data
SELECT TOP 1000 *
FROM dbo.Intervals_Unpacked;
SELECT COUNT(*)
FROM dbo.Intervals_Unpacked;
-- 109,991,876 rows
GO

-- query
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- beginning of data
-- logical reads: 6, CPU time: 0 ms
DECLARE @b AS INT = 80, @e AS INT = 100;
DECLARE @t AS TABLE(id INT);

INSERT INTO @t(id)
SELECT id
FROM dbo.Intervals_Unpacked
WHERE n BETWEEN @b AND @e;

SELECT DISTINCT id
FROM @t;
GO

-- end of data
-- logical reads: 7, CPU time: 0 ms
DECLARE @b AS INT = 10000000 - 100, @e AS INT = 10000000 - 80;
DECLARE @t AS TABLE(id INT);

INSERT INTO @t(id)
SELECT id
FROM dbo.Intervals_Unpacked
WHERE n BETWEEN @b AND @e;

SELECT DISTINCT id
FROM @t;
GO

-- middle of data
-- logical reads: 6 (5 + 1 from the table variable), CPU time: 0 ms
DECLARE @b AS INT = 5000000, @e AS INT = 5000020;
DECLARE @t AS TABLE(id INT);

INSERT INTO @t(id)
SELECT id
FROM dbo.Intervals_Unpacked
WHERE n BETWEEN @b AND @e;

SELECT DISTINCT id
FROM @t;
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

-- Table with intervals unpacked
-- Create and populate Intervals_Unpacked_Table table
-- With row compression
CREATE TABLE dbo.Intervals_Unpacked_Table
(
  id    INT NOT NULL,
  n     INT NOT NULL
)
WITH (DATA_COMPRESSION = ROW);
GO

ALTER TABLE dbo.Intervals_Unpacked_Table
 ADD CONSTRAINT PK_Intervals_Unpacked_Table PRIMARY KEY(n, id);
GO

-- 1:23 min with row compression
INSERT INTO dbo.Intervals_Unpacked_Table WITH(TABLOCK) (id, n)
SELECT id, n
FROM dbo.Intervals
 CROSS APPLY dbo.GetNums(b, e);
GO

-- Check the space used 
EXEC sys.sp_spaceused N'dbo.Intervals', TRUE;
EXEC sys.sp_spaceused N'dbo.Intervals_Unpacked', TRUE;
EXEC sys.sp_spaceused N'dbo.Intervals_Unpacked_Table', TRUE;
GO
-- Original table reserverd:				  566,360 KB
-- Indexed view reserved:					1,857,744 KB
-- Table with row compressions reserved:	1,234,064 KB

-- Use page compression
-- 35 s
ALTER TABLE dbo.Intervals_Unpacked_Table 
 REBUILD WITH (DATA_COMPRESSION = PAGE);
GO

-- Check the space used 
EXEC sys.sp_spaceused N'dbo.Intervals_Unpacked_Table', TRUE;
GO
-- Table with page compressions reserved:	1,229,272 KB

-- query
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- beginning of data
-- logical reads: 7, CPU time: 0 ms
DECLARE @b AS INT = 80, @e AS INT = 100;
SELECT DISTINCT id
FROM dbo.Intervals_Unpacked_Table
WHERE n BETWEEN @b AND @e;
GO

-- end of data
-- logical reads: 7, CPU time: 0 ms
DECLARE @b AS INT = 10000000 - 100, @e AS INT = 10000000 - 80;
SELECT DISTINCT id
FROM dbo.Intervals_Unpacked_Table
WHERE n BETWEEN @b AND @e;
GO   

-- middle of data
-- logical reads: 7, CPU time: 0 ms
DECLARE @b AS INT = 5000000, @e AS INT = 5000020;
SELECT DISTINCT id
FROM dbo.Intervals_Unpacked_Table
WHERE n BETWEEN @b AND @e;
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO


/*********************************/
/* Demo 3: Compact Unpacked Form */
/*********************************/

-- Create and populate IntervalsCU table
-- Need a different interval length distribution
-- With the original short intervals, 
-- there would be no difference between
-- the unpacked and compact unpacked form

CREATE TABLE dbo.IntervalsCU
(
  id    INT NOT NULL,
  b     INT NOT NULL,
  e     INT NOT NULL,
  CONSTRAINT PK_IntervalsCU PRIMARY KEY(id),
  CONSTRAINT CHK_IntervalsCU_upper_gteq_lower CHECK(e >= b)
);
GO

-- 0 s 
DECLARE
  @numintervals AS INT = 100000,    -- number of intervals
  @minlower     AS INT = 1,         -- min begin
  @maxupper     AS INT = 99999,     -- max end
  @maxdiff      AS INT = 730;       -- max length of an interval

WITH C AS
(
  SELECT
    n AS id,
    @minlower + (ABS(CHECKSUM(NEWID())) % (@maxupper - @minlower - @maxdiff + 1)) AS lower,
    ABS(CHECKSUM(NEWID())) % (@maxdiff + 1) AS diff
  FROM dbo.GetNums(1, @numintervals) AS Nums
)
INSERT INTO dbo.IntervalsCU WITH(TABLOCK) (id, b, e)
  SELECT id, lower, lower + diff AS upper
  FROM C;
GO

CREATE INDEX idx_lowerCU ON dbo.IntervalsCU(b) INCLUDE(e);
CREATE INDEX idx_upperCU ON dbo.IntervalsCU(e) INCLUDE(b);
GO

-- Check the data
SELECT TOP 1000 *
FROM dbo.IntervalsCU;

SELECT COUNT(*) AS nintervals, AVG(1.0 *(e-b)) avglength,
 MIN(b) AS MinBegin, MAX(e) AS MaxEnd
FROM dbo.IntervalsCU;
GO
-- Average length 362.815400
-- Could expect ~ 36,281,540 rows in the unpacked form


-- Compact unpacked form of an interval
/*
nnnnA marks full tens, e.g. 0002A marks all numbers between 20 and 29
nnnB0 marks full hundreds, e.g. 001B0 marks all numbers between 100 and 199
*/

-- Test interval
DECLARE @b AS int, @e AS int;
-- Lower and upper boundaries of a test interval
SET @b = 13;
SET @e = 355;

-- NumsCTE generates the fully unpacked form of an interval
WITH NumsCTE AS
(
 SELECT n
 FROM dbo.GetNums(@b, @e)
),
-- Count numbers in groups of tens and hundreds
RowsInGroupsCTE AS
(
 SELECT n, 
  n / 10 AS nDIV10,
  n / 100 AS nDIV100,
  COUNT(*) OVER (PARTITION BY n / 10 ORDER BY n
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
   AS RowsInTens,
  COUNT(*) OVER (PARTITION BY n / 100 ORDER BY n
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
   AS RowsInHundreds
 FROM NumsCTE
)
SELECT  DISTINCT COALESCE(N100, N10, N1) as CompactUnpackedN 
FROM 
(
 SELECT	
  CASE WHEN RowsInHundreds = 100 
       THEN FORMAT(nDIV100, '000') + 'B0' 
       ELSE NULL 
  END AS N100,
  CASE WHEN RowsInHundreds <> 100 AND RowsInTens = 10 
       THEN FORMAT (nDIV10, '0000') + 'A' 
	   ELSE NULL 
  END AS N10,
  CASE WHEN RowsInHundreds <> 100 AND RowsInTens <> 10 
       THEN FORMAT(n, '00000') 
	   ELSE NULL
  END AS N1
 FROM RowsInGroupsCTE
) AS T
ORDER BY CompactUnpackedN;
GO

-- Function that generates the compact unpacked form
CREATE FUNCTION dbo.GetCUForm(@b AS BIGINT, @e AS BIGINT) RETURNS TABLE
AS RETURN
WITH NumsCTE AS
(
 SELECT n
 FROM dbo.GetNums(@b, @e)
),
-- Count numbers in groups of tens and hundreds
RowsInGroupsCTE AS
(
 SELECT n, 
  n / 10 AS nDIV10,
  n / 100 AS nDIV100,
  COUNT(*) OVER (PARTITION BY n / 10 ORDER BY n
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
   AS RowsInTens,
  COUNT(*) OVER (PARTITION BY n / 100 ORDER BY n
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
   AS RowsInHundreds
 FROM NumsCTE
)
SELECT  DISTINCT COALESCE(N100, N10, N1) as CompactUnpackedN 
FROM 
(
 SELECT	
  CASE WHEN RowsInHundreds = 100 
       THEN FORMAT(nDIV100, '000') + 'B0' 
       ELSE NULL 
  END AS N100,
  CASE WHEN RowsInHundreds <> 100 AND RowsInTens = 10 
       THEN FORMAT (nDIV10, '0000') + 'A' 
	   ELSE NULL 
  END AS N10,
  CASE WHEN RowsInHundreds <> 100 AND RowsInTens <> 10 
       THEN FORMAT(n, '00000') 
	   ELSE NULL
  END AS N1
 FROM RowsInGroupsCTE
) AS T;
GO

-- Test the function
SELECT *
FROM dbo.GetCUForm(13, 355);
GO

-- Table with intervals unpacked
-- Create and populate Intervals_Unpacked_Table table
-- With row compression
DROP TABLE dbo.Intervals_Compact_Unpacked

CREATE TABLE dbo.Intervals_Compact_Unpacked
(
  id    INT     NOT NULL,
  n     CHAR(8) NOT NULL
)
WITH (DATA_COMPRESSION = ROW);
GO

ALTER TABLE dbo.Intervals_Compact_Unpacked
 ADD CONSTRAINT PK_Intervals_Compact_Unpacked PRIMARY KEY(n, id);
GO

-- SLOW!!! 5:20 min with row compression
INSERT INTO dbo.Intervals_Compact_Unpacked WITH(TABLOCK) (id, n)
SELECT id, CompactUnpackedN
FROM dbo.IntervalsCU
 CROSS APPLY dbo.GetCUForm(b, e);
GO

-- Check the data
SELECT TOP 1000 *
FROM dbo.IntervalsCU;
SELECT TOP 10000 *
FROM dbo.Intervals_Compact_Unpacked;

SELECT COUNT(*) AS nintervals
FROM dbo.Intervals_Compact_Unpacked;
GO
-- 2,000,262 rows

-- Check the space used 
EXEC sys.sp_spaceused N'dbo.IntervalsCU', TRUE;
EXEC sys.sp_spaceused N'Intervals_Compact_Unpacked', TRUE;
GO
-- Original table reserverd:				  6,672 KB
-- Table with row compressions reserved:	 25,224 KB

-- Use page compression
-- 1 s
ALTER TABLE dbo.Intervals_Compact_Unpacked
 REBUILD WITH (DATA_COMPRESSION = PAGE);
GO

-- Check the space used 
EXEC sys.sp_spaceused N'dbo.Intervals_Compact_Unpacked', TRUE;
GO
-- Table with page compressions reserved:	24328 KB


-- Check with the classical T-SQL solution
-- query
-- Turn on the graphical execution plan
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- All pages - 226
SELECT *
FROM dbo.IntervalsCU;
GO

-- beginning of data
-- logical reads: 2, CPU time: 0 ms
DECLARE @b AS INT = 80, @e AS INT = 100;

SELECT id
FROM dbo.IntervalsCU
WHERE b <= @e AND e >= @b
OPTION (RECOMPILE);        -- Need to prevent plan reusage
GO
-- idx_lower used

-- end of data
-- logical reads: 2, CPU time: 0 ms
DECLARE @b AS INT = 99999 - 100, @e AS INT = 99999 - 80;

SELECT id
FROM dbo.IntervalsCU
WHERE b <= @e AND e >= @b
OPTION (RECOMPILE);
GO
-- idx_upper used

-- middle of data
-- logical reads: 115, CPU time: ~100 ms
DECLARE @b AS INT = 50000, @e AS INT = 50020;

SELECT id
FROM dbo.IntervalsCU
WHERE b <= @e AND e >= @b
OPTION (RECOMPILE); 
GO
-- One index selected


-- beginning of data
-- logical reads 15, 
-- Intervals_Compact_Unpacked 9, 
-- IntervalsCU                2,
-- temp table                 4 (3 + 1),
-- CPU time: 0 ms
DECLARE @b AS INT = 80, @e AS INT = 100;
DECLARE @SearchForm AS TABLE
(n CHAR(8));

-- Populate the search form
INSERT INTO @SearchForm
SELECT FORMAT(@b, '00000')
UNION ALL
SELECT FORMAT(@b / 10, '0000') + 'A'
UNION ALL
SELECT FORMAT(@b / 100, '000') + 'B0';

SELECT I.id
FROM dbo.Intervals_Compact_Unpacked AS I
INNER JOIN @SearchForm AS S
 ON S.n = I.n 
UNION
SELECT I.id
FROM dbo.IntervalsCU AS I
WHERE b BETWEEN @b AND @e
OPTION (RECOMPILE);        -- Need to prevent plan reusage
GO

-- end of data
-- logical reads: 15, CPU time: 0 ms
DECLARE @b AS INT = 99999 - 100, @e AS INT = 99999 - 80;
DECLARE @SearchForm AS TABLE
(n CHAR(8));

-- Populate the search form
INSERT INTO @SearchForm
SELECT FORMAT(@b, '00000')
UNION ALL
SELECT FORMAT(@b / 10, '0000') + 'A'
UNION ALL
SELECT FORMAT(@b / 100, '000') + 'B0';

SELECT I.id
FROM dbo.Intervals_Compact_Unpacked AS I
INNER JOIN @SearchForm AS S
 ON S.n = I.n 
UNION
SELECT I.id
FROM dbo.IntervalsCU AS I
WHERE b BETWEEN @b AND @e
OPTION (RECOMPILE);        -- Need to prevent plan reusage
GO

-- middle of data
-- logical reads: 16, CPU time: ~0 ms
DECLARE @b AS INT = 50000, @e AS INT = 50020;
DECLARE @SearchForm AS TABLE
(n CHAR(8));

-- Populate the search form
INSERT INTO @SearchForm
SELECT FORMAT(@b, '00000')
UNION ALL
SELECT FORMAT(@b / 10, '0000') + 'A'
UNION ALL
SELECT FORMAT(@b / 100, '000') + 'B0';

SELECT I.id
FROM dbo.Intervals_Compact_Unpacked AS I
INNER JOIN @SearchForm AS S
 ON S.n = I.n 
UNION
SELECT I.id
FROM dbo.IntervalsCU AS I
WHERE b BETWEEN @b AND @e
OPTION (RECOMPILE);        -- Need to prevent plan reusage
GO
