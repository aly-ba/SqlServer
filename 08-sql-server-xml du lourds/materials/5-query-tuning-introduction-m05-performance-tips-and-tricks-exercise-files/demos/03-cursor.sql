/****************************************************************
Course by: 	Pinal Dave  (http://blog.sqlauthority.com)
			Vinod Kumar (http://blogs.extremeExperts.com)

	Script - http://bit.ly/columnstoreindex

Scripts for SQL Server Performance: Query Tuning ©Pluralsight.

Description: Use of Cursors and Performance

****************************************************************/

SET NOCOUNT ON;
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
USE AdventureWorks2012
GO
-- Creating TestTable 
SELECT *
INTO TestTable
FROM Production.ProductInventory
WHERE 1 = 2
GO

DECLARE @ProductID INT
DECLARE @getProductID CURSOR
SET @getProductID = CURSOR FOR
SELECT TOP 10 ProductID
FROM Production.Product
OPEN @getProductID
FETCH NEXT
FROM @getProductID INTO @ProductID
WHILE @@FETCH_STATUS = 0
BEGIN
INSERT INTO TestTable
SELECT *
FROM Production.ProductInventory
WHERE ProductID = @ProductID
FETCH NEXT
FROM @getProductID INTO @ProductID
END
CLOSE @getProductID
DEALLOCATE @getProductID
GO
-- select 
SELECT *
FROM TestTable
GO

-- Clean up
TRUNCATE TABLE TestTable
GO

--------------------------------------------------------------------------
-- Alternatives 1
--------------------------------------------------------------------------
SELECT *
FROM Production.ProductInventory
WHERE ProductID IN
(SELECT TOP 10 ProductID
FROM Production.Product)
GO

--------------------------------------------------------------------------
-- Alternatives 2
--------------------------------------------------------------------------
SELECT pi.*
FROM Production.ProductInventory pi
INNER JOIN (SELECT TOP 10 ProductID 
			FROM Production.Product) p 
				ON p.ProductID = pi.ProductID
GO
--------------------------------------------------------------------------
-- Alternatives 3
--------------------------------------------------------------------------
INSERT INTO TestTable
SELECT pi.*
FROM Production.ProductInventory pi
INNER JOIN (SELECT TOP 10 ProductID 
			FROM Production.Product) p 
				ON p.ProductID = pi.ProductID
GO
-- select 
SELECT *
FROM TestTable
GO
-- Clean up
TRUNCATE TABLE TestTable
GO

--------------------------------------------------------------------------
-- Alternatives 4
--------------------------------------------------------------------------
SELECT pi.*
INTO TestTable1
FROM Production.ProductInventory pi
INNER JOIN (SELECT TOP 10 ProductID 
			FROM Production.Product) p 
				ON p.ProductID = pi.ProductID
GO
-- select 
SELECT *
FROM TestTable1
GO
-- Clean up
TRUNCATE TABLE TestTable1
GO