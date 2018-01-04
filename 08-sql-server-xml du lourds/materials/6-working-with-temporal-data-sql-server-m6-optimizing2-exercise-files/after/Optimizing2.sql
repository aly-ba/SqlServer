/************************************************/
/* Working with Temporal Data in SQL Server     */
/* Module 6: Optimizing Temporal Queries Part 2 */
/************************************************/


/******************************/
/* Demo 1: Geometry Data Type */
/******************************/

/* Code in this demo is courtesy of Davide Mauri */

-- Module 2 to 5 demos should be finished
SET NOCOUNT ON;
USE TemporalData;
GO

CREATE TABLE dbo.IntervalsSP
(
	id INT NOT NULL,
	segment geometry NOT NULL
);

-- SLOW! (8:30 min!)
INSERT INTO dbo.IntervalsSP WITH(TABLOCK) (id, segment)
  SELECT 
	id,
	segment = 
		CASE WHEN b != e then
			geometry::STGeomFromText('LINESTRING
			 (' + CAST(b AS VARCHAR(50)) + ' 0, ' + 
			      CAST(e AS VARCHAR(50)) + ' 0)', 0) 
		ELSE 
			geometry::STGeomFromText('POINT
			 (' + CAST(b AS VARCHAR(50)) + ' 0)', 0)
		END
  FROM dbo.Stage;
GO

-- ~ 12 s
ALTER TABLE dbo.IntervalsSP
 ADD CONSTRAINT PK_IntervalsSP PRIMARY KEY(id);
GO

-- ~ 1:30 min
CREATE SPATIAL INDEX ixs_1
 ON dbo.IntervalsSP (segment) 
 USING GEOMETRY_AUTO_GRID
 WITH (BOUNDING_BOX = (0, 0, 10000000,1));
GO

-- Check the data
SELECT TOP 1000 *, segment.ToString()
FROM dbo.IntervalsSP;
SELECT COUNT(*)
FROM dbo.IntervalsSP;
GO

-- query
SET STATISTICS IO ON
SET STATISTICS TIME ON
GO

-- beginning of data
-- logical reads: 213 (165 table + 48 index), CPU time: 11 ms
SELECT id 
FROM dbo.IntervalsSP 
WHERE segment.STIntersects
 (geometry::STGeomFromText('LINESTRING (80 0, 100 0)', 0)) = 1
ORDER BY id;
GO

-- end of data
-- logical reads: 277 (229 table + 48 index), CPU time: 12 ms
SELECT id 
FROM dbo.IntervalsSP 
WHERE segment.STIntersects
(geometry::STGeomFromText('LINESTRING (9999900 0, 9999920 0)', 0)) = 1
ORDER BY id;
GO

-- middle of data
-- logical reads: 427 (331 table + 96 index), CPU time: 16 ms
SELECT id 
FROM dbo.IntervalsSP 
WHERE segment.STIntersects
 (geometry::STGeomFromText('LINESTRING (5000000 0, 5000020 0)', 0)) = 1
ORDER BY id;
GO

SET STATISTICS IO OFF
SET STATISTICS TIME OFF
GO

-- Check the space used 
EXEC sys.sp_spaceused N'dbo.Intervals', TRUE;
-- 566.360 KB
EXEC sys.sp_spaceused N'dbo.IntervalsSP', TRUE;
-- 776.800 KB
GO


/*************************/
/* Demo 2: XML Data Type */
/*************************/

SELECT TOP 1000 id, b, e,
 CAST(N'<intervalXML b="' + CAST(b AS NVARCHAR(10)) +
      N'" e="' + CAST(e AS NVARCHAR(10)) + N'" />' AS XML)
FROM dbo.Stage;

-- Create and populate IntervalsXML table
-- SLOW! 6:50 min
CREATE TABLE dbo.IntervalsXML
(
  id          INT NOT NULL,
  IntervalXML XML NOT NULL
);

ALTER TABLE dbo.IntervalsXML
 ADD CONSTRAINT PK_IntervalsXML PRIMARY KEY(id);
CREATE PRIMARY XML INDEX PXML_IntervalsXML
 ON dbo.IntervalsXML (IntervalXML);
CREATE XML INDEX IXML_IntervalsXML_Property 
 ON dbo.IntervalsXML (IntervalXML)
 USING XML INDEX PXML_IntervalsXML FOR PROPERTY;

INSERT INTO dbo.IntervalsXML WITH(TABLOCK) (id, IntervalXML)
	SELECT id,
	 CAST(N'<intervalXML b="' + CAST(b AS NVARCHAR(10)) +
		  N'" e="' + CAST(e AS NVARCHAR(10)) + N'" />' AS XML)
	FROM dbo.Stage;
GO

-- Check the data
SELECT TOP 1000 *
FROM dbo.IntervalsXML;
GO

-- query
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- beginning of data
-- logical reads: ~ 42,000,000, CPU time: ~ 70,000 ms
DECLARE @b AS INT = 80, @e AS INT = 100;

SELECT id 
FROM dbo.IntervalsXML
WHERE IntervalXML.value('(/intervalXML/@b)[1]', 'INT') <= @e
  AND IntervalXML.value('(/intervalXML/@e)[1]', 'INT') >= @b;
GO

-- end of data
-- logical reads: ~ 85,000,000, CPU time: ~ 140,000 ms
DECLARE @b AS INT = 10000000 - 100, @e AS INT = 10000000 - 80;

SELECT id 
FROM dbo.IntervalsXML
WHERE IntervalXML.value('(/intervalXML/@b)[1]', 'INT') <= @e
  AND IntervalXML.value('(/intervalXML/@e)[1]', 'INT') >= @b;
GO

-- middle of data
-- logical reads: ~ 65,000,000, CPU time: ~ 100,000 ms
DECLARE @b AS INT = 5000000, @e AS INT = 5000020;

SELECT id 
FROM dbo.IntervalsXML
WHERE IntervalXML.value('(/intervalXML/@b)[1]', 'INT') <= @e
  AND IntervalXML.value('(/intervalXML/@e)[1]', 'INT') >= @b;
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO

-- Check the space used 
EXEC sys.sp_spaceused N'dbo.Intervals', TRUE;
--   566.360 KB
EXEC sys.sp_spaceused N'dbo.IntervalsXML', TRUE;
-- 4,509,800 KB
GO


/**************************/
/* Demo 3: Enhanced T-SQL */
/**************************/

-- Create and populate IntervalsL table
-- 17 seconds
CREATE TABLE dbo.IntervalsL
(
  id    INT NOT NULL,
  b     INT NOT NULL,
  e     INT NOT NULL,
  ilen  AS e - b PERSISTED,
  CONSTRAINT CHK_IntervalsL_upper_gteq_lower CHECK(e >= b)
);

INSERT INTO dbo.IntervalsL WITH(TABLOCK) (id, b, e)
  SELECT id, b, e
  FROM dbo.Stage;

ALTER TABLE dbo.IntervalsL ADD CONSTRAINT PK_IntervalsL PRIMARY KEY(id);

CREATE INDEX idx_lowerL ON dbo.IntervalsL(b) INCLUDE(e);
CREATE INDEX idx_upperL ON dbo.IntervalsL(e) INCLUDE(b);
CREATE INDEX ids_ilenL ON dbo.IntervalsL(ilen);
GO

-- Check the data
SELECT TOP 1000 *
FROM dbo.IntervalsL;
GO

-- query
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

-- beginning of data
-- logical reads: 6, CPU time: 0 ms
DECLARE @b AS INT = 80, @e AS INT = 100;

DECLARE @max AS INT;
SET @max = 
 (SELECT MAX(ilen) AS maxlen FROM
  (SELECT MAX(ilen) AS ilen FROM dbo.IntervalsL
   UNION
   SELECT @e - @b) AS m1
 );

SELECT id
FROM dbo.IntervalsL
WHERE b <= @e AND b >= @b - @max
  AND e >= @b AND e <= @e + @max
OPTION (RECOMPILE);
GO

-- end of data
-- logical reads: 6, CPU time: 0 ms
DECLARE @b AS INT = 10000000 - 100, @e AS INT = 10000000 - 80;

DECLARE @max AS INT;
SET @max = 
 (SELECT MAX(ilen) AS maxlen FROM
  (SELECT MAX(ilen) AS ilen FROM dbo.IntervalsL
   UNION
   SELECT @e - @b) AS m1
 );

SELECT id
FROM dbo.IntervalsL
WHERE b <= @e AND b >= @b - @max
  AND e >= @b AND e <= @e + @max
OPTION (RECOMPILE);
GO

-- middle of data
-- logical reads: 6 (3 + 3 to calculate the max length), CPU time: 0 ms
DECLARE @b AS INT = 5000000, @e AS INT = 5000020;

DECLARE @max AS INT;
SET @max = 
 (SELECT MAX(ilen) AS maxlen FROM
  (SELECT MAX(ilen) AS ilen FROM dbo.IntervalsL
   UNION
   SELECT @e - @b) AS m1
 );

SELECT id
FROM dbo.IntervalsL
WHERE b <= @e AND b >= @b - @max
  AND e >= @b AND e <= @e + @max
OPTION (RECOMPILE);
GO

-- Check with longer maximal interval
-- logical reads: 228, CPU time: 0 ms
DECLARE @b AS INT = 5000000, @e AS INT = 5000020;

DECLARE @max AS INT = 100000;

SELECT id
FROM dbo.Intervals
WHERE b <= @e AND b >= @b - @max
  AND e >= @b AND e <= @e + @max
OPTION (RECOMPILE);
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
