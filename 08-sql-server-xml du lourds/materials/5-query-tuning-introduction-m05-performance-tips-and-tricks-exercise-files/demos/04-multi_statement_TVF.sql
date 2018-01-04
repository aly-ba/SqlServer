/****************************************************************
Course by: 	Pinal Dave  (http://blog.sqlauthority.com)
			Vinod Kumar (http://blogs.extremeExperts.com)

	Script - http://bit.ly/columnstoreindex

Scripts for SQL Server Performance: Query Tuning ©Pluralsight.

Description: Using TVF and performance

****************************************************************/

USE AdventureWorks2012
GO

IF OBJECT_ID ('tvf_multi') is not null
	DROP FUNCTION tvf_multi
GO

/*
 creating multi-statement TVF
*/
CREATE FUNCTION tvf_multi()
RETURNS @SaleDetail TABLE (BusinessEntityID INT, ProductId INT)
AS
BEGIN
INSERT INTO @SaleDetail
	SELECT soh.CustomerID, ProductID 
	FROM Sales.SalesOrderHeader soh
	INNER JOIN Sales.SalesOrderDetail sod 
	ON soh.SalesOrderID = sod.SalesOrderID
	RETURN
END

GO


/*************************************************************
exec plan with the multi-statement TVF
**************************************************************/
SET STATISTICS IO ON
SET STATISTICS TIME ON
GO
SELECT c.BusinessEntityID, c.LastName, c.FirstName, prod.Name, prod.ListPrice,
 COUNT (*) 'numer of units' 
FROM Person.Person c INNER JOIN 
	dbo.tvf_multi() tst 
	ON c.BusinessEntityID = tst.BusinessEntityID
	INNER JOIN Production.Product prod 
	ON tst.ProductId = prod.ProductID
GROUP BY c.BusinessEntityID, c.LastName, c.FirstName, prod.Name, prod.ListPrice

GO
SET STATISTICS IO OFF
SET STATISTICS TIME OFF

GO

/*************************************************
 3. re-write
*************************************************/
if OBJECT_ID ('tvf_Inline') is not null
	drop FUNCTION tvf_Inline
	
GO
create FUNCTION tvf_Inline()
RETURNS TABLE
AS
RETURN SELECT CustomerID [BusinessEntityID], ProductID 
		FROM Sales.SalesOrderHeader soh 
		INNER JOIN Sales.SalesOrderDetail sod 
		ON soh.SalesOrderID = sod.SalesOrderID

GO

/*****************************************************
 4. exec plan for inline TVF
******************************************************/
SET STATISTICS IO ON
SET STATISTICS TIME ON
GO

SELECT c.BusinessEntityID, c.LastName, c.FirstName, prod.Name, prod.ListPrice,
 COUNT (*) 'numer of units' 
FROM Person.Person c INNER JOIN 
dbo.tvf_Inline() tst ON c.BusinessEntityID = tst.BusinessEntityID
INNER JOIN Production.Product prod 
	ON tst.ProductID = prod.ProductID
GROUP BY c.BusinessEntityID, c.LastName, c.FirstName, prod.Name, prod.ListPrice

GO
SET STATISTICS IO OFF
SET STATISTICS TIME OFF

/*****************************************************
 4. Do Compare the TVF
******************************************************/
SET STATISTICS IO ON
SET STATISTICS TIME ON
GO

SELECT c.BusinessEntityID, c.LastName, c.FirstName, prod.Name, prod.ListPrice,
 COUNT (*) 'numer of unit' 
FROM Person.Person c INNER JOIN 
dbo.tvf_Inline() tst ON c.BusinessEntityID = tst.BusinessEntityID
INNER JOIN Production.Product prod 
	ON tst.ProductID = prod.ProductID
GROUP BY c.BusinessEntityID, c.LastName, c.FirstName, prod.Name, prod.ListPrice
GO

SELECT c.BusinessEntityID, c.LastName, c.FirstName, prod.Name, prod.ListPrice,
 COUNT (*) 'numer of unit' 
FROM Person.Person c INNER JOIN 
	dbo.tvf_multi() tst 
	ON c.BusinessEntityID = tst.BusinessEntityID
	INNER JOIN Production.Product prod 
	ON tst.ProductId = prod.ProductID
GROUP BY c.BusinessEntityID, c.LastName, c.FirstName, prod.Name, prod.ListPrice

GO
SET STATISTICS IO OFF
SET STATISTICS TIME OFF
