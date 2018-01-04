/**********************************************************/
/* Working with Temporal Data in SQL Server               */
/* Module 2: Temporal Databases, Problems and Constraints */
/**********************************************************/


/************************/
/* Demo 1: Date Numbers */
/************************/

-- Create a test database
USE master;
GO
CREATE DATABASE TemporalData;
GO
ALTER DATABASE TemporalData SET RECOVERY SIMPLE WITH NO_WAIT;
GO
USE TemporalData;
GO

-- Auxiliary table of date numbers
SET NOCOUNT ON;

IF OBJECT_ID('dbo.DateNums', 'U') IS NOT NULL DROP TABLE dbo.DateNums;
CREATE TABLE dbo.DateNums
 (n INT NOT NULL PRIMARY KEY,
  d DATE NOT NULL);
GO

DECLARE @max AS INT, @rc AS INT, @d AS DATE;
SET @max = 10000;
SET @rc = 1;
SET @d = '20140101'     -- Initial date

INSERT INTO dbo.DateNums VALUES(1, @d);
WHILE @rc * 2 <= @max
BEGIN
  INSERT INTO dbo.DateNums 
  SELECT n + @rc, DATEADD(day,n + @rc - 1, @d) FROM dbo.DateNums;
  SET @rc = @rc * 2;
END

INSERT INTO dbo.DateNums
  SELECT n + @rc, DATEADD(day,n + @rc - 1, @d) 
  FROM dbo.DateNums 
  WHERE n + @rc <= @max;
GO

-- Check data
SELECT * 
FROM dbo.DateNums;
GO


/**********************************/
/* Demo 2: Semi-Temporal Problems */
/**********************************/

-- Create table dbo.Suppliers_Since
IF OBJECT_ID('dbo.Suppliers_Since', 'U') IS NOT NULL
   DROP TABLE dbo.Suppliers_Since;
CREATE TABLE dbo.Suppliers_Since
(
  supplierid   INT          NOT NULL,
  companyname  NVARCHAR(40) NOT NULL,
  since        INT          NOT NULL
  CONSTRAINT PK_Suppliers_Since PRIMARY KEY(supplierid)
);
GO

-- Create table dbo.SuppliersProducts_Since
IF OBJECT_ID('dbo.SuppliersProducts_Since', 'U') IS NOT NULL
   DROP TABLE dbo.SuppliersProducts_Since;
CREATE TABLE dbo.SuppliersProducts_Since
(
  supplierid   INT          NOT NULL,
  productid    INT          NOT NULL,
  since        INT          NOT NULL
  CONSTRAINT PK_SuppliersProducts_Since
   PRIMARY KEY(supplierid, productid)
);
GO

-- Foreign keys
ALTER TABLE dbo.Suppliers_Since
 ADD CONSTRAINT DateNums_Suppliers_Since_FK1
     FOREIGN KEY (since)
     REFERENCES dbo.DateNums (n);

ALTER TABLE dbo.SuppliersProducts_Since
 ADD CONSTRAINT Suppliers_SuppliersProducts_Since_FK1
     FOREIGN KEY (supplierid)
     REFERENCES dbo.Suppliers_Since (supplierid);

/*
-- In a real production system,
-- a FK to the dbo.Products table would exist as well
ALTER TABLE dbo.SuppliersProducts_Since
 ADD CONSTRAINT Products_SuppliersProducts_Since_FK1
     FOREIGN KEY (productid)
     REFERENCES dbo.Products (productid);
*/

ALTER TABLE dbo.SuppliersProducts_Since
 ADD CONSTRAINT DateNums_SuppliersProducts_Since_FK1
     FOREIGN KEY (since)
     REFERENCES dbo.DateNums (n);
GO
     
-- Additional constraint: a supplier can supply products
-- only after the supplier has a contract
-- First trigger prevents invalid inserts to the SuppliersProducts_Since table
IF OBJECT_ID (N'dbo.SuppliersProducts_Since_TR1', 'TR') IS NOT NULL
   DROP TRIGGER dbo.SuppliersProducts_Since_TR1;
GO

CREATE TRIGGER dbo.SuppliersProducts_Since_TR1
 ON dbo.SuppliersProducts_Since
AFTER INSERT, UPDATE
AS
BEGIN
IF EXISTS
 (SELECT *
    FROM inserted AS i
         INNER JOIN dbo.Suppliers_Since AS s
          ON i.supplierid = s.supplierid
             AND i.since < s.since
 )
 BEGIN
  RAISERROR('Suppliers are allowed to supply products
   only after they have a contract!', 16, 1);
  ROLLBACK TRAN;
 END
END;
GO

-- Second trigger prevents invalid updates to the Suppliers_Since table
IF OBJECT_ID (N'dbo.Suppliers_Since_TR1', 'TR') IS NOT NULL
   DROP TRIGGER dbo.Suppliers_Since_TR1;
GO

CREATE TRIGGER dbo.Suppliers_Since_TR1
 ON dbo.Suppliers_Since
AFTER UPDATE
AS
BEGIN
IF EXISTS
 (SELECT *
    FROM dbo.SuppliersProducts_Since AS sp
         INNER JOIN dbo.Suppliers_Since AS s
          ON sp.supplierid = s.supplierid
             AND sp.since < s.since
 )
 BEGIN
  RAISERROR('Suppliers are allowed to supply products
   only after they have a contract!', 16, 1);
  ROLLBACK TRAN;
 END
END;
GO

-- Test the constraints
-- Suppliers_Since valid data
INSERT INTO dbo.Suppliers_Since
 (supplierid, companyname, since)
VALUES
 (1, N'Supplier A', 10),
 (2, N'Supplier B', 15),
 (3, N'Supplier C', 17);
GO
-- Check data
SELECT *
  FROM dbo.Suppliers_Since;
GO
  
-- SuppliersProducts_Since
INSERT INTO dbo.SuppliersProducts_Since
 (supplierid, productid, since)
VALUES
 (1, 20, 10),
 (1, 21, 12),
 (2, 22, 15),
 (3, 21, 23);
GO
-- Check data
SELECT *
  FROM dbo.SuppliersProducts_Since;
GO

-- Invalid data

-- Since too early - not a valid time point
INSERT INTO dbo.Suppliers_Since
 (supplierId, companyname, since)
VALUES
 (4, N'Supplier D', 0);
GO

-- A product supplied before supplier had a contract
INSERT INTO dbo.SuppliersProducts_Since
 (supplierid, productid, since)
VALUES
 (1, 22, 9);
GO

-- Updating since column for a supplier to try to make it
-- later than since of the product supplied by the supplier
UPDATE dbo.Suppliers_Since
   SET since = 24
 WHERE supplierid = 3;  
GO
  
-- Querying semitemporal table
SELECT s.supplierId, s.companyname, s.since,
       d.d AS datesince
FROM dbo.Suppliers_Since AS s
 INNER JOIN dbo.DateNums AS d
  ON s.since = d.n;
GO


