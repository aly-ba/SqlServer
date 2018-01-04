/************************************************/
/* Working with Temporal Data in SQL Server     */
/* Module 5: Optimizing Temporal Queries Part 1 */
/************************************************/

/* Code in this module is courtesy of Itzik Ben-Gan */

/************************************/
/* Demo 1: Classical T-SQL solution */
/************************************/

-- Module 2 to 4 demos should be finished
SET NOCOUNT ON;
USE TemporalData;
GO

-- Helper function dbo.GetNums
-- Table function returning sequence of integers
-- between inputs @low and @high
CREATE FUNCTION dbo.GetNums(@low AS BIGINT, @high AS BIGINT)
 RETURNS TABLE
AS
RETURN
  WITH
    L0   AS (SELECT c FROM (SELECT 1 UNION ALL SELECT 1) AS D(c)),
    L1   AS (SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),
    L2   AS (SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),
    L3   AS (SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),
    L4   AS (SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B),
    L5   AS (SELECT 1 AS c FROM L4 AS A CROSS JOIN L4 AS B),
    Nums AS (SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rownum
            FROM L5)
  SELECT TOP(@high - @low + 1) @low + rownum - 1 AS n
  FROM Nums
  ORDER BY rownum;
GO

-- Create staging table dbo.Stage with 10,000,000 intervals
-- Use this table to insert data in other tables to have the same data
-- in all tables (except the last one in module 7). 
CREATE TABLE dbo.Stage
(
  id    INT NOT NULL,
  b     INT NOT NULL,
  e     INT NOT NULL,
  CONSTRAINT PK_Stage PRIMARY KEY(id),
  CONSTRAINT CHK_Stage_upper_gteq_lower CHECK(e >= b)
);
GO

-- 18s
DECLARE
  @numintervals AS INT = 10000000,   -- number of intervals
  @minlower     AS INT = 1,          -- min begin
  @maxupper     AS INT = 10000000,   -- min end
  @maxdiff      AS INT = 20;         -- max length of an interval

WITH C AS
(
  SELECT
    n AS id,
    @minlower + (ABS(CHECKSUM(NEWID())) %
	 (@maxupper - @minlower - @maxdiff + 1)) AS lower,
    ABS(CHECKSUM(NEWID())) % (@maxdiff + 1) AS diff
  FROM dbo.GetNums(1, @numintervals) AS Nums
)
INSERT INTO dbo.Stage WITH(TABLOCK) (id, b, e)
  SELECT id, lower, lower + diff AS upper
  FROM C;
GO

-- Check the data
SELECT TOP 1000 *
FROM dbo.Stage;
SELECT COUNT(*) AS nintervals, AVG(1.0 *(e-b)) avglength
FROM dbo.Stage;
GO
-- Average length quite short
-- Such a distribution is optimized for performance testing
-- Need a different distribution for the last solution in module 7

-- Create and populate Intervals table
-- 11 seconds
CREATE TABLE dbo.Intervals
(
  id    INT NOT NULL,
  b     INT NOT NULL,
  e     INT NOT NULL,
  CONSTRAINT CHK_Intervals_upper_gteq_lower CHECK(e >= b)
);

INSERT INTO dbo.Intervals WITH(TABLOCK) (id, b, e)
  SELECT id, b, e
  FROM dbo.Stage;

ALTER TABLE dbo.Intervals ADD CONSTRAINT PK_Intervals PRIMARY KEY(id);

CREATE INDEX idx_lower ON dbo.Intervals(b) INCLUDE(e);
CREATE INDEX idx_upper ON dbo.Intervals(e) INCLUDE(b);
GO
-- 11 seconds up to here

-- Check the data
SELECT TOP 1000 *
FROM dbo.Intervals;
GO

-- query
-- Turn on the graphical execution plan
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- beginning of data
-- logical reads: 3, CPU time: 0 ms
DECLARE @b AS INT = 80, @e AS INT = 100;

SELECT id
FROM dbo.Intervals
WHERE b <= @e AND e >= @b
OPTION (RECOMPILE);        -- Need to prevent plan reusage
GO
-- idx_lower used

-- end of data
-- logical reads: 3, CPU time: 0 ms
DECLARE @b AS INT = 10000000 - 100, @e AS INT = 10000000 - 80;

SELECT id
FROM dbo.Intervals
WHERE b <= @e AND e >= @b
OPTION (RECOMPILE);
GO
-- idx_upper used

-- middle of data
-- logical reads: 11263, CPU time: ~200-400 ms
DECLARE @b AS INT = 5000000, @e AS INT = 5000020;

SELECT id
FROM dbo.Intervals
WHERE b <= @e AND e >= @b
OPTION (RECOMPILE); 
GO
-- One index selected

-- Turn off the graphical execution plan
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO


/*********************************/
/* Demo 2: Fork Node Calculation */
/*********************************/

-- Fork node calculation for [11, 13]

-- 1. Let A = (b - 1) ^ e  
-- XOR marks different bits 01010 ^ 01101 = 00111
SELECT (11 - 1) ^ 13 AS A;
-- 7 = 00111

-- 2. Let B = POWER(2, FLOOR(LOG(A, 2))) 
-- first different bit set to 1 like in e: 00100
SELECT LOG(7, 2) AS Log2A,
 FLOOR(LOG(7, 2)) FloorLog2A,
 POWER(2, FLOOR(LOG(7, 2))) AS B;
-- 4 = 00100

-- 3. Let C = e % B 
-- keep trailing bits from e after set bit in B: 01
SELECT 13 % 4 AS C;

-- 4. Let D = e - C 
-- set trailing bits to 0s: 01100
SELECT 13 - 1 AS D,  -- fork node for [11,13]
 13 - (13 % 4),
 13 - (13 % POWER(2, FLOOR(LOG(7, 2)))),
 13 - (13 % POWER(2, FLOOR(LOG((11 - 1) ^ 13, 2))));
GO


/************************************/
/* Demo 3: Relational Interval Tree */
/************************************/

-- Create and populate IntervalsRIT table
-- 19 seconds
CREATE TABLE dbo.IntervalsRIT
(
  id    INT NOT NULL,
  node  AS e - e % POWER(2, FLOOR(LOG((b - 1) ^ e, 2)))
   PERSISTED NOT NULL,
  b     INT NOT NULL,
  e     INT NOT NULL,
  CONSTRAINT CHK_IntervalsRIT_upper_gteq_lower CHECK(e >= b)
);

INSERT INTO dbo.IntervalsRIT WITH(TABLOCK) (id, b, e)
  SELECT id, b, e
  FROM dbo.Stage;

ALTER TABLE dbo.IntervalsRIT
 ADD CONSTRAINT PK_IntervalsRIT PRIMARY KEY(id);
CREATE INDEX idx_lower ON dbo.IntervalsRIT(node, b);
CREATE INDEX idx_upper ON dbo.IntervalsRIT(node, e);
GO
-- 19 seconds up to here

-- Check the data
SELECT TOP 1000 *
FROM dbo.IntervalsRIT
ORDER BY node;
GO

-- Definitions of leftNodes and rightNodes functions

-- leftNodes function
CREATE FUNCTION dbo.leftNodes(@b AS INT, @e AS INT)
  RETURNS @T TABLE
  (node INT NOT NULL PRIMARY KEY)
AS
BEGIN
  DECLARE @node AS INT = 1073741824;
  DECLARE @step AS INT = @node / 2;

  -- descend from root node to lower
  WHILE @step >= 1
  BEGIN
    -- right node
    IF @b < @node
      SET @node -= @step;
    -- left node
    ELSE IF @b > @node
    BEGIN
      INSERT INTO @T(node) VALUES(@node);
      SET @node += @step;
    END
    -- lower
    ELSE
      BREAK;
    SET @step /= 2;
  END;

  RETURN;
END;
GO

-- rightNodes function
CREATE FUNCTION dbo.rightNodes(@b AS INT, @e AS INT)
  RETURNS @T TABLE
  (node INT NOT NULL PRIMARY KEY)
AS
BEGIN
  DECLARE @node AS INT = 1073741824;
  DECLARE @step AS INT = @node / 2;

  -- descend from root node to upper
  WHILE @step >= 1
  BEGIN
    -- left node
    IF @e > @node
      SET @node += @step
    -- right node
    ELSE IF @e < @node
    BEGIN
      INSERT INTO @T(node) VALUES(@node);
      SET @node -= @step
    END
    -- upper
    ELSE
      BREAK;
    SET @step /= 2;
  END;

  RETURN;
END;
GO

-- Test
DECLARE @b AS INT = 11, @e AS INT = 13;
SELECT * FROM dbo.rightNodes(@b, @e);
SELECT I.id, I.b, I.e, I.node
FROM dbo.IntervalsRIT AS I
  JOIN dbo.rightNodes(@b, @e) AS L
    ON I.node = L.node
    AND I.b <= @e;      -- exclude false positives
GO


-- Intersection query
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- beginning of data
-- logical reads: 114 + 2 + 2, CPU time: 0 ms
DECLARE @b AS INT = 80, @e AS INT = 100;

SELECT I.id
FROM dbo.IntervalsRIT AS I
  JOIN dbo.leftNodes(@b, @e) AS L
    ON I.node = L.node
    AND I.e >= @b
UNION ALL
SELECT I.id
FROM dbo.IntervalsRIT AS I
  JOIN dbo.rightNodes(@b, @e) AS R
    ON I.node = R.node
    AND I.b <= @e
UNION ALL
SELECT id
FROM dbo.IntervalsRIT
WHERE node BETWEEN @b AND @e
OPTION (RECOMPILE);
GO

-- end of data
-- logical reads: 120 + 2 + 2, CPU time: 0 ms
DECLARE @b AS INT = 10000000 - 100, @e AS INT = 10000000 - 80;

SELECT I.id
FROM dbo.IntervalsRIT AS I
  JOIN dbo.leftNodes(@b, @e) AS L
    ON I.node = L.node
    AND I.e >= @b
UNION ALL
SELECT I.id
FROM dbo.IntervalsRIT AS I
  JOIN dbo.rightNodes(@b, @e) AS R
    ON I.node = R.node
    AND I.b <= @e
UNION ALL
SELECT id
FROM dbo.IntervalsRIT
WHERE node BETWEEN @b AND @e
OPTION (RECOMPILE);
GO

-- middle of data
-- logical reads: 144 (IntervalsRIT) + 2 (@T - leftNodes)
-- + 2 (@T - rightNodes), CPU time: 0 ms
DECLARE @b AS INT = 5000000, @e AS INT = 5000020;

SELECT I.id
FROM dbo.IntervalsRIT AS I
  JOIN dbo.leftNodes(@b, @e) AS L
    ON I.node = L.node
    AND I.e >= @b
UNION ALL
SELECT I.id
FROM dbo.IntervalsRIT AS I
  JOIN dbo.rightNodes(@b, @e) AS R
    ON I.node = R.node
    AND I.b <= @e
UNION ALL
SELECT id
FROM dbo.IntervalsRIT
WHERE node BETWEEN @b AND @e
OPTION (RECOMPILE);
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
