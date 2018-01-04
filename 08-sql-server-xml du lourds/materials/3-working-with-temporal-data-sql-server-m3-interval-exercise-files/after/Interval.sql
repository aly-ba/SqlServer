/********************************************/
/* Working with Temporal Data in SQL Server */
/* Module 3: The Interval Data Type         */
/********************************************/


/*************************************/
/* Demo 1: The IntervalCID Data Type */
/*************************************/

-- Module 2 demos should be finished
USE TemporalData;
GO

-- IntervalCID C# code
/*
using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;
using System.Globalization;

[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(
    Format.Native,
    IsByteOrdered = true,
    ValidationMethodName = "ValidateIntervalCID")]
public struct IntervalCID : INullable
{
    //Regular expression used to parse values of the form (intBegin,intEnd)
    private static readonly Regex _parser
        = new Regex(@"\A\(\s*(?<intBegin>\-?\d+?)\s*:\s*(?<intEnd>\-?\d+?)\s*\)\Z",
                    RegexOptions.Compiled | RegexOptions.ExplicitCapture);

    // Begin, end of interval
    private Int32 _begin;
    private Int32 _end;

    // Internal member to show whether the value is null
    private bool _isnull;

    // Null value returned equal for all instances
    private const string NULL = "<<null interval>>";
    private static readonly IntervalCID NULL_INSTANCE
       = new IntervalCID(true);

    // Constructor for a known value
    public IntervalCID(Int32 begin, Int32 end)
    {
        this._begin = begin;
        this._end = end;
        this._isnull = false;
    }

    // Constructor for an unknown value
    private IntervalCID(bool isnull)
    {
        this._isnull = isnull;
        this._begin = this._end = 0;
    }

    // Default string representation
    public override string ToString()
    {
        return this._isnull ? NULL : ("("
            + this._begin.ToString(CultureInfo.InvariantCulture) + ":"
            + this._end.ToString(CultureInfo.InvariantCulture)
            + ")");
    }

    // Null handling
    public bool IsNull
    {
        get
        {
            return this._isnull;
        }
    }

    public static IntervalCID Null
    {
        get
        {
            return NULL_INSTANCE;
        }
    }

    // Parsing input using regular expression
    public static IntervalCID Parse(SqlString sqlString)
    {
        string value = sqlString.ToString();

        if (sqlString.IsNull || value == NULL)
            return new IntervalCID(true);

        // Check whether the input value matches the regex pattern
        Match m = _parser.Match(value);

        // If the input’s format is incorrect, throw an exception
        if (!m.Success)
            throw new ArgumentException(
                "Invalid format for an interval. "
                + "Format is (intBegin:intEnd).");

        // If everything is OK, parse the value; 
        // we will get two Int32 type values
        IntervalCID it = new IntervalCID(Int32.Parse(m.Groups[1].Value,
            CultureInfo.InvariantCulture), Int32.Parse(m.Groups[2].Value,
            CultureInfo.InvariantCulture));
        if (!it.ValidateIntervalCID())
            throw new ArgumentException("Invalid begin and end values.");

        return it;
    }

    // Begin and end separately
    public Int32 BeginInt
    {
        [SqlMethod(IsDeterministic = true, IsPrecise = true)]
        get
        {
            return this._begin;
        }
        set
        {
            Int32 temp = _begin;
            _begin = value;
            if (!ValidateIntervalCID())
            {
                _begin = temp;
                throw new ArgumentException("Invalid begin value.");
            }

        }
    }

    public Int32 EndInt
    {
        [SqlMethod(IsDeterministic = true, IsPrecise = true)]
        get
        {
            return this._end;
        }
        set
        {
            Int32 temp = _end;
            _end = value;
            if (!ValidateIntervalCID())
            {
                _end = temp;
                throw new ArgumentException("Invalid end value.");
            }

        }
    }

    // Validation method
    private bool ValidateIntervalCID()
    {
        if (_end >= _begin)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    // Allen's operators

    public bool Equals(IntervalCID target)
    {
        return ((this._begin == target._begin) & (this._end == target._end));
    }

    public bool Before(IntervalCID target)
    {
        return (this._end < target._begin);
    }

    public bool After(IntervalCID target)
    {
        return (this._begin > target._end);
    }

    public bool Includes(IntervalCID target)
    {
        return ((this._begin <= target._begin) & (this._end >= target._end));
    }

    public bool ProperlyIncludes(IntervalCID target)
    {
        return ((this._begin < target._begin) & (this._end > target._end));
    }

    public bool Meets(IntervalCID target)
    {
        return ((this._end + 1 == target._begin) | (this._begin == target._end + 1));
    }

    public bool Overlaps(IntervalCID target)
    {
        return ((this._begin <= target._end) & (target._begin <= this._end));
    }

    public bool Merges(IntervalCID target)
    {
        return (this.Meets(target) | this.Overlaps(target));
    }

    public bool Begins(IntervalCID target)
    {
        return ((this._begin == target._begin) & (this._end <= target._end));
    }

    public bool Ends(IntervalCID target)
    {
        return ((this._begin >= target._begin) & (this._end == target._end));
    }

    public IntervalCID Union(IntervalCID target)
    {
        if (this.Merges(target))
            return new IntervalCID(System.Math.Min(this.BeginInt, target.BeginInt),
                                   System.Math.Max(this.EndInt, target.EndInt));
        else
            return new IntervalCID(true);
    }

    public IntervalCID Intersect(IntervalCID target)
    {
        if (this.Merges(target))
            return new IntervalCID(System.Math.Max(this.BeginInt, target.BeginInt),
                                   System.Math.Min(this.EndInt, target.EndInt));
        else
            return new IntervalCID(true);
    }

    public IntervalCID Minus(IntervalCID target)
    {
        if (this.Merges(target) & (this.BeginInt < target.BeginInt) & (this.EndInt <= target.EndInt))
            return new IntervalCID(this.BeginInt, System.Math.Min(target.BeginInt - 1, this.EndInt));
        else
            if (this.Merges(target) & (this.BeginInt >= target.BeginInt) & (this.EndInt > target.EndInt))
                return new IntervalCID(System.Math.Max(target.EndInt + 1, this.BeginInt), this.EndInt);
            else
                return new IntervalCID(true);
    }
}
*/

-- Enable CLR
USE master; 
EXEC sp_configure 'clr enabled', 1; 
RECONFIGURE; 
GO 
USE TemporalData;
GO

-- Deploy assembly
-- Assuming that the dll file exist in the C:\TemporalData folder
CREATE ASSEMBLY IntervalCID
FROM 'C:\TemporalData\IntervalCID.dll' 
WITH PERMISSION_SET = SAFE;
GO

-- Type
CREATE TYPE dbo.IntervalCID 
EXTERNAL NAME IntervalCID.IntervalCID;
GO

-- Testing presentation and Boolean operators
-- Switch results into text mode
SET NOCOUNT ON;
DECLARE @i1 IntervalCID, @i2 IntervalCID, @i3 IntervalCID;

PRINT 'Testing presentation';
SET @i1 = N'(1:5)';
SELECT @i1 AS i1Bin, CAST(@i1.ToString() AS CHAR(8)) AS i1,
       @i1.BeginInt AS [Begin], @i1.EndInt AS [End];

PRINT 'Testing Equals operator';
SET @i2 = N'(1:5)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8)) AS i2,
       @i1.Equals(@i2) AS [Equals];

PRINT 'Testing Before and After operators';       
SET @i2 = N'(7:10)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8)) AS i2,
       @i1.Before(@i2) AS [Before], @i1.After(@i2) AS [After];

PRINT 'Testing Includes and Properly Includes operators';        
SET @i2 = N'(3:5)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8)) AS i2,
       @i1.Includes(@i2) AS [i1 Includes i2], 
       @i1.ProperlyIncludes(@i2) AS [i1 Properly Includes i2];
SET @i3 = N'(1:5)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i3.ToString() AS CHAR(8)) AS i3,
       @i1.Includes(@i3) AS [i1 Includes i3], 
       @i1.ProperlyIncludes(@i3) AS [i1 Properly Includes i3]; 
	         
PRINT 'Testing Meets operator'; 
SET @i2 = N'(6:6)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8)) AS i2,
       @i1.Meets(@i2) AS [Meets];

PRINT 'Testing Overlaps operator';   
SET @i2 = N'(3:6)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8)) AS i2,
       @i1.Overlaps(@i2) AS [Overlaps];

PRINT 'Testing Begins and Ends operators';   
SET @i2 = N'(1:7)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8)) AS i2,
       @i1.Begins(@i2) AS [Begins], @i1.Ends(@i2) AS [Ends];

PRINT 'Testing NULLs';   
SET @i3 = NULL;
SELECT CAST(@i3.ToString() AS CHAR(8)) AS [Null Interval];
IF @i3 IS NULL
   SELECT '@i3 IS NULL' AS [IS NULL Test];
GO

-- Testing setting properties
DECLARE @i1 IntervalCID;

PRINT 'Original interval';
SET @i1 = N'(1:5)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       @i1.BeginInt AS [Begin], @i1.EndInt AS [End];

PRINT 'Interval after properties modification';
SET @i1.BeginInt = 4;
SET @i1.EndInt = 10;       
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       @i1.BeginInt AS [Begin], @i1.EndInt AS [End];
GO

-- Interval algebra operators
DECLARE @i1 IntervalCID, @i2 IntervalCID;

PRINT 'Overlapping intervals';
SET @i1 = N'(4:8)';
SET @i2 = N'(6:10)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8))AS i2,
       CAST(@i1.[Union](@i2).ToString() AS CHAR(8)) AS [i1 Union i2],
       CAST(@i1.[Intersect](@i2).ToString() AS CHAR(8)) AS [i1 Intersect i2],
       CAST(@i1.[Minus](@i2).ToString() AS CHAR(8)) AS [i1 Minus i2];

PRINT 'Intervals that meet';
SET @i1 = N'(2:3)';
SET @i2 = N'(4:8)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8))AS i2,
       CAST(@i1.[Union](@i2).ToString() AS CHAR(8)) AS [i1 Union i2],
       CAST(@i1.[Intersect](@i2).ToString() AS CHAR(8)) AS [i1 Intersect i2],
       CAST(@i1.[Minus](@i2).ToString() AS CHAR(8)) AS [i1 Minus i2];

PRINT 'Intervals that have nothing in common';
SET @i1 = N'(2:3)';
SET @i2 = N'(6:8)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8))AS i2,
       CAST(@i1.[Union](@i2).ToString() AS CHAR(8)) AS [i1 Union i2],
       CAST(@i1.[Intersect](@i2).ToString() AS CHAR(8)) AS [i1 Intersect i2],
       CAST(@i1.[Minus](@i2).ToString() AS CHAR(8)) AS [i1 Minus i2];

PRINT 'One interval contained in another';
SET @i1 = N'(2:10)';
SET @i2 = N'(6:8)';
SELECT CAST(@i1.ToString() AS CHAR(8)) AS i1,
       CAST(@i2.ToString() AS CHAR(8))AS i2,
       CAST(@i1.[Union](@i2).ToString() AS CHAR(8)) AS [i1 Union i2],
       CAST(@i1.[Intersect](@i2).ToString() AS CHAR(8)) AS [i1 Intersect i2],
       CAST(@i1.[Minus](@i2).ToString() AS CHAR(8)) AS [i1 Minus i2];
GO
-- Switch results back to the grid mode


/********************************/
/* Demo 2: Full-Temporal Tables */
/********************************/

-- Create table dbo.Suppliers_During
IF OBJECT_ID('dbo.Suppliers_During', 'U') IS NOT NULL
   DROP TABLE dbo.Suppliers_During;

CREATE TABLE dbo.Suppliers_During
(
  supplierid   INT          NOT NULL,
  during       IntervalCID  NOT NULL,
  beginint AS During.BeginInt PERSISTED,
  endint   AS During.EndInt   PERSISTED,
  CONSTRAINT PK_Suppliers_During PRIMARY KEY(supplierid, during)
);
GO

-- Create table dbo.SuppliersProducts_During
IF OBJECT_ID('dbo.SuppliersProducts_During', 'U') IS NOT NULL
   DROP TABLE dbo.SuppliersProducts_During;

CREATE TABLE dbo.SuppliersProducts_During
(
  supplierid   INT          NOT NULL,
  productid    INT          NOT NULL,
  during       IntervalCID  NOT NULL,
  CONSTRAINT PK_SuppliersProducts_During
   PRIMARY KEY(supplierid, productid, during)
);
GO

-- Foreign keys
-- Valid time points
ALTER TABLE dbo.Suppliers_During
 ADD CONSTRAINT DateNums_Suppliers_During_FK1
     FOREIGN KEY (beginint)
     REFERENCES dbo.DateNums (n);

ALTER TABLE dbo.Suppliers_During
 ADD CONSTRAINT DateNums_Suppliers_During_FK2
     FOREIGN KEY (endint)
     REFERENCES dbo.DateNums (n);
GO

-- M-to-M relationship between suppliers and products          
ALTER TABLE dbo.SuppliersProducts_During
 ADD CONSTRAINT Suppliers_SuppliersProducts_During_FK1
     FOREIGN KEY (supplierid)
     REFERENCES dbo.Suppliers_Since (supplierid);
-- Note the reference to the dbo.Suppliers_Since table
-- Cannot reference the dbo.Suppliers_During table - supplierid is not unique

/*
-- In a real production system, a FK to the dbo.Products table would exist as well
ALTER TABLE dbo.SuppliersProducts_During
 ADD CONSTRAINT Products_SuppliersProducts_During_FK1
     FOREIGN KEY (productid)
     REFERENCES dbo.Products (productid);
*/
GO

-- Additional constraint: no supplies if not under a contract
-- First trigger prevents invalid inserts to the SuppliersProducts_During table
IF OBJECT_ID (N'dbo.SuppliersProducts_During_TR1','TR') IS NOT NULL
   DROP TRIGGER dbo.SuppliersProducts_During_TR1;
GO

CREATE TRIGGER dbo.SuppliersProducts_During_TR1
 ON dbo.SuppliersProducts_During
AFTER INSERT, UPDATE
AS
BEGIN
IF EXISTS
 (SELECT *
    FROM inserted AS i
   WHERE NOT EXISTS
         (SELECT * FROM dbo.Suppliers_During AS s
           WHERE s.supplierid = i.supplierid
                 AND s.during.Includes(i.during) = 1)
 )
 BEGIN
  RAISERROR('Suppliers are allowed to supply products
             only in periods they have a contract!', 16, 1);
  ROLLBACK TRAN;
 END
END;
GO

-- Second trigger prevents invalid updates and deletes to the Suppliers_During table
IF OBJECT_ID (N'dbo.Suppliers_During_TR1','TR') IS NOT NULL
   DROP TRIGGER dbo.Suppliers_During_TR1;
GO

CREATE TRIGGER dbo.Suppliers_During_TR1
 ON dbo.Suppliers_During
AFTER UPDATE, DELETE
AS
BEGIN
IF EXISTS
 (SELECT *
    FROM dbo.SuppliersProducts_During AS sp
   WHERE NOT EXISTS
         (SELECT * FROM dbo.Suppliers_During AS s
           WHERE s.supplierid = sp.supplierid
                 AND s.during.Includes(sp.during) = 1)
 )
 BEGIN
  RAISERROR('Suppliers are allowed to supply products
             only in periods they have a contract!', 16, 1);
  ROLLBACK TRAN;
 END
END;
GO

-- Test the constraints
-- Suppliers_During valid data
INSERT INTO dbo.Suppliers_During
 (supplierid, during)
VALUES
 (1, N'(2:5)'),
 (1, N'(7:8)'),
 (2, N'(1:10)');
GO

-- Check the data
SELECT *, during.ToString()
  FROM dbo.Suppliers_During;
GO

-- SuppliersProducts_During valid data
INSERT INTO dbo.SuppliersProducts_During
 (supplierid, productid, during)
VALUES
 (1, 22, N'(2:5)');
GO

-- Check the data
SELECT *, during.ToString()
  FROM dbo.SuppliersProducts_During;
GO
  
-- Invalid data

-- Invalid data - invalid interval during
INSERT INTO dbo.Suppliers_During
 (supplierid, during)
VALUES
 (1, N'(1:15000)');
GO

-- A product supplied during a perion supplier did not have a contract
INSERT INTO dbo.SuppliersProducts_During
 (supplierid, productid, during)
VALUES
 (1, 20, N'(2:6)');
GO

-- Invalid update of during column for a supplier
UPDATE dbo.Suppliers_During
   SET during = N'(3:5)'
 WHERE supplierid = 1 AND
       during = N'(2:5)';
GO

-- Invalid delete of a supplier
DELETE FROM dbo.Suppliers_During
 WHERE supplierid = 1 AND
       during = N'(2:5)';
GO

-- Querying full temporal table
-- All rows
SELECT sd.supplierId, 
       CAST(ss.companyname AS CHAR(20)) AS companyname, 
       CAST(sd.during.ToString() AS CHAR(8)) AS during,
       d1.d AS datefrom, d2.d AS dateto
FROM dbo.Suppliers_During AS sd
 INNER JOIN dbo.DateNums AS d1
  ON sd.beginint = d1.n
 INNER JOIN dbo.DateNums AS d2
  ON sd.endint = d2.n  
 INNER JOIN dbo.Suppliers_Since AS ss
  ON sd.supplierid = ss.supplierid;
GO

-- Suppliers with contract during an interval
-- included in given interval
DECLARE @i AS IntervalCID = N'(7:11)';
SELECT sd.supplierId, 
       CAST(ss.companyname AS CHAR(20)) AS companyname, 
       CAST(sd.during.ToString() AS CHAR(8)) AS during,
       d1.d AS datefrom, d2.d AS dateto
FROM dbo.Suppliers_During AS sd
 INNER JOIN dbo.DateNums AS d1
  ON sd.beginint = d1.n
 INNER JOIN dbo.DateNums AS d2
  ON sd.endint = d2.n  
 INNER JOIN dbo.Suppliers_Since AS ss
  ON sd.supplierid = ss.supplierid
WHERE @i.Includes(sd.during) = 1;  
GO

-- Suppliers with contract during an interval
-- that overlaps with given interval
DECLARE @i AS IntervalCID = N'(7:11)';
SELECT sd.supplierId, 
       CAST(ss.companyname AS CHAR(20)) AS companyname, 
       CAST(sd.during.ToString() AS CHAR(8)) AS during,
       d1.d AS datefrom, d2.d AS dateto
FROM dbo.Suppliers_During AS sd
 INNER JOIN dbo.DateNums AS d1
  ON sd.beginint = d1.n
 INNER JOIN dbo.DateNums AS d2
  ON sd.endint = d2.n  
 INNER JOIN dbo.Suppliers_Since AS ss
  ON sd.supplierid = ss.supplierid
WHERE @i.Overlaps(sd.during) = 1;  
GO

-- Suppliers with contract in a specific time point
DECLARE @i AS IntervalCID = N'(9:9)';
SELECT sd.supplierId, 
       CAST(ss.companyname AS CHAR(20)) AS companyname, 
       CAST(sd.during.ToString() AS CHAR(8)) AS during,
       d1.d AS datefrom, d2.d AS dateto
FROM dbo.Suppliers_During AS sd
 INNER JOIN dbo.DateNums AS d1
  ON sd.beginint = d1.n
 INNER JOIN dbo.DateNums AS d2
  ON sd.endint = d2.n  
 INNER JOIN dbo.Suppliers_Since AS ss
  ON sd.supplierid = ss.supplierid
WHERE sd.during.Includes(@i) = 1;  
GO
