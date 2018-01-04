/*********************************************/
/* Working with Temporal Data in SQL Server  */
/* Module 4: Packing and Unpacking Intervals */
/*********************************************/


/**********************************************************************/
/* Demo 1: Preventing overlapping or meeting intervals with a trigger */
/**********************************************************************/

-- Module 2 and 3 demos should be finished
SET NOCOUNT ON;
USE TemporalData;
GO

-- Preventing overlapping or meeting intervals for a supplier

-- Try with a simple AFTER trigger
IF OBJECT_ID (N'dbo.Suppliers_During_TR2','TR') IS NOT NULL
   DROP TRIGGER dbo.Suppliers_During_TR2;
GO

CREATE TRIGGER dbo.Suppliers_During_TR2
 ON dbo.Suppliers_During
AFTER INSERT, UPDATE
AS
BEGIN
IF EXISTS
 (SELECT *
    FROM inserted AS i
   WHERE EXISTS
         (SELECT * FROM dbo.Suppliers_During AS s
           WHERE s.supplierid = i.supplierid
                 AND s.during.Merges(i.during) = 1)
 )
 BEGIN
  RAISERROR('No overlapping or meeting intervals 
             for a given supplier allowed!', 16, 1);
  ROLLBACK TRAN;
 END
END;
GO

-- Testing the trigger
-- Valid insert
INSERT INTO dbo.Suppliers_During
 (supplierId, during)
VALUES
 (2, N'(12:20)');
GO
-- Of course, the triger fires after the INSERT
-- The inserted row overlaps with the new row in the inserted table
-- The trigger made table read-only:-)

-- Drop the trigger
IF OBJECT_ID (N'dbo.Suppliers_During_TR2','TR') IS NOT NULL
   DROP TRIGGER dbo.Suppliers_During_TR2;
GO


-- Using INSTEAD OF trigger
IF OBJECT_ID (N'dbo.Suppliers_During_TR2','TR') IS NOT NULL
   DROP TRIGGER dbo.Suppliers_During_TR2;
GO

CREATE TRIGGER dbo.Suppliers_During_TR2
 ON dbo.Suppliers_During
INSTEAD OF INSERT, UPDATE
AS
BEGIN
-- Disallowing multi-rows inserts and updates
IF (SELECT COUNT(*) FROM inserted) > 1
 BEGIN
  RAISERROR('Insert or update a single row at a time!', 16, 1);
  ROLLBACK TRAN;
  RETURN;
 END;
-- Disallowing update of supplierid
IF (EXISTS(SELECT * FROM deleted) AND
    UPDATE(supplierid))
 BEGIN
  RAISERROR('Update of supplierid is not allowed!', 16, 1);
  ROLLBACK TRAN; 
 END;
-- Checking for overlapping or meeting intervals
IF EXISTS
 (SELECT *
    FROM inserted AS i
   WHERE EXISTS
         (SELECT * FROM
          (SELECT * FROM dbo.Suppliers_During
           -- excluding checking against existing row for an update
           EXCEPT
           SELECT * FROM deleted) AS s
            WHERE s.supplierid = i.supplierid
                  AND s.during.Merges(i.during) = 1)
 )
 BEGIN
  RAISERROR('No overlapping or meeting intervals 
             for a given supplier allowed!', 16, 1);
  ROLLBACK TRAN;
 END;
ELSE
-- Resubmitting update or insert
 IF EXISTS(SELECT * FROM deleted)
  UPDATE dbo.Suppliers_During
     SET during = (SELECT during FROM inserted)
   WHERE supplierid = (SELECT supplierid FROM deleted) AND
         during = (SELECT during FROM deleted);
 ELSE  
  INSERT INTO dbo.Suppliers_During
   (supplierid, during)
  SELECT supplierid, during
   FROM inserted;
END;
GO

-- Test the trigger

-- Check the content of the tables
SELECT supplierid, during.ToString()
FROM dbo.Suppliers_During;
SELECT supplierid, during.ToString()
FROM dbo.SuppliersProducts_During;
GO

-- Overlapping interval
INSERT INTO dbo.Suppliers_During
 (supplierId, during)
VALUES
 (1, N'(3:6)');
GO

-- Meeting interval
INSERT INTO dbo.Suppliers_During
 (supplierId, during)
VALUES
 (1, N'(6:6)');
GO

-- Valid insert
INSERT INTO dbo.Suppliers_During
 (supplierId, during)
VALUES
 (2, N'(12:20)');
GO

-- Valid update
UPDATE dbo.Suppliers_During
   SET during = N'(13:20)'
 WHERE supplierid = 2 AND
       during = N'(12:20)';
GO       

-- Invalid update of supplierid
UPDATE dbo.Suppliers_During
   SET supplierid = 3
 WHERE supplierid = 2 AND
       during = N'(13:20)';
GO   
 
-- Deleting the new row
DELETE FROM dbo.Suppliers_During
 WHERE supplierid = 2 AND
       during = N'(13:20)';
GO

-- Drop the trigger
IF OBJECT_ID (N'dbo.Suppliers_During_TR2','TR') IS NOT NULL
   DROP TRIGGER dbo.Suppliers_During_TR2;
GO


/*********************************/
/* Demo 2: Unpacking and Packing */
/*********************************/

-- Auxiliary Suppliers_Temp_During table
-- To demonstrate PACK and UNPACK
IF OBJECT_ID('dbo.Suppliers_Temp_During', 'U') IS NOT NULL
   DROP TABLE dbo.Suppliers_Temp_During;

CREATE TABLE dbo.Suppliers_Temp_During
(
  supplierid   INT          NOT NULL,
  during       IntervalCID  NOT NULL,
  beginint AS During.BeginInt PERSISTED,
  endint   AS During.EndInt   PERSISTED,
  CONSTRAINT PK_Suppliers_Temp_During PRIMARY KEY(supplierid, during)
);
GO

INSERT INTO dbo.Suppliers_Temp_During
 (supplierId, during)
VALUES
 (1, N'(2:5)'),
 (1, N'(3:7)'),
 (2, N'(10:12)');
GO

-- Unpackig the Suppliers_Temp_During table
-- Current version
SELECT supplierid, during.ToString()
  FROM dbo.Suppliers_Temp_During;
GO

-- Unpacking
SELECT sd.supplierid, 
       CAST(sd.during.ToString() AS CHAR(8)) AS completeduring,
       dn.n, dn.d,
       N'(' + CAST(dn.n AS NVARCHAR(10)) + 
       N':' + CAST(dn.n AS NVARCHAR(10)) + N')'
        AS unpackedduring     
  FROM dbo.Suppliers_Temp_During AS sd
       INNER JOIN dbo.DateNums AS dn
        ON dn.n BETWEEN sd.beginint AND sd.endint
ORDER BY sd.supplierid, dn.n;
GO

-- Create view dbo.Suppliers_During_Unpacked
IF OBJECT_ID('dbo.Suppliers_During_Unpacked', 'V') IS NOT NULL
   DROP VIEW dbo.Suppliers_During_Unpacked;
GO

CREATE VIEW dbo.Suppliers_During_Unpacked
WITH SCHEMABINDING
AS
SELECT sd.supplierid, 
       N'(' + CAST(dn.n AS NVARCHAR(10)) + 
       N':' + CAST(dn.n AS NVARCHAR(10)) + N')'
        AS unpackedduring     
  FROM dbo.Suppliers_During AS sd
       INNER JOIN dbo.DateNums AS dn
        ON dn.n BETWEEN beginint AND sd.endint;
GO

CREATE UNIQUE CLUSTERED INDEX Suppliers_During_Unpacked_ClIx
 ON dbo.Suppliers_During_Unpacked(supplierid, unpackedduring);
GO

-- Invalid data - invalid interval during
-- Check the content of the tables
SELECT supplierid, during.ToString()
FROM dbo.Suppliers_During;
SELECT supplierid, during.ToString()
FROM dbo.SuppliersProducts_During;
GO

-- Overlapping insert
INSERT INTO dbo.Suppliers_During
 (supplierid, during)
VALUES
 (1, N'(1:3)');
GO

-- Packing the Suppliers_Temp_During table
-- Grouping factor
WITH UnpackedCTE AS
(
  SELECT sd.supplierid,
         CAST(sd.during.ToString() AS CHAR(8)) AS CompleteInterval,
         dn.n, dn.d,
         N'(' + CAST(dn.n AS NVARCHAR(10)) + 
         N':' + CAST(dn.n AS NVARCHAR(10)) + N')' 
           AS UnpackedDuring     
  FROM dbo.Suppliers_Temp_During AS sd
    INNER JOIN dbo.DateNums AS dn
       ON dn.n BETWEEN sd.beginint AND sd.endint
),
GroupingFactorCTE AS   
(
  SELECT supplierid, n, 
         DENSE_RANK() OVER (ORDER BY n) AS dr,
         n - DENSE_RANK() OVER(ORDER BY n) AS gf
  FROM UnpackedCTE
)
SELECT * FROM GroupingFactorCTE;
GO

-- Packed form
WITH UnpackedCTE AS
(
  SELECT sd.supplierid,
         CAST(sd.during.ToString() AS CHAR(8)) AS CompleteInterval,
         dn.n, dn.d,
         N'(' + CAST(dn.n AS NVARCHAR(10)) + 
         N':' + CAST(dn.n AS NVARCHAR(10)) + N')' 
           AS UnpackedDuring     
  FROM dbo.Suppliers_Temp_During AS sd
    INNER JOIN dbo.DateNums AS dn
       ON dn.n BETWEEN sd.beginint AND sd.endint
),
GroupingFactorCTE AS   
(
  SELECT supplierid, n, 
         DENSE_RANK() OVER (ORDER BY n) AS dr,
         n - DENSE_RANK() OVER(ORDER BY n) AS gf
  FROM UnpackedCTE
)
SELECT supplierid, gf, 
       N'(' + CAST(MIN(n) AS NVARCHAR(10)) + 
       N':' + CAST(MAX(n) AS NVARCHAR(10)) + N')'
        AS packedduring  
FROM GroupingFactorCTE
GROUP BY supplierid, gf
ORDER BY supplierid, packedduring;
GO


