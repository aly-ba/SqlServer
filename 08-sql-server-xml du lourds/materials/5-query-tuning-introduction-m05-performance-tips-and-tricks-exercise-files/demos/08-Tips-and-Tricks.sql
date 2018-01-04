/****************************************************************
Course by: 	Pinal Dave  (http://blog.sqlauthority.com)
			Vinod Kumar (http://blogs.extremeExperts.com)

	Script - http://bit.ly/columnstoreindex

Scripts for SQL Server Performance: Query Tuning ©Pluralsight.

Description: Some general Tips and tricks

****************************************************************/

Use AdventureWorks2012
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]') AND name = N'IX_SalesOrderHeader_OrderDate')
	DROP INDEX [IX_SalesOrderHeader_OrderDate] ON [Sales].[SalesOrderHeader] 
GO
CREATE INDEX IX_SalesOrderHeader_OrderDate ON Sales.SalesOrderHeader(OrderDate)
GO
SET NOCOUNT ON
GO
---------------------------------------------------------------------------------------------
-- FUNCTIONS IN THE WHERE CLAUSE
-- Using Functions around an indexed column
-- Two queries, one with functions, one without
---------------------------------------------------------------------------------------------
SELECT	SalesOrderID,
		OrderDate
FROM	Sales.SalesOrderHeader
WHERE	YEAR(OrderDate) = 2008
AND		MONTH(OrderDate) = 7
GO

SELECT	SalesOrderID,
		OrderDate
FROM	Sales.SalesOrderHeader
WHERE	OrderDate BETWEEN '7/1/2008' AND '7/31/2008'
GO


---------------------------------------------------------------------------------------------
-- USING COUNT(*) Coding
---------------------------------------------------------------------------------------------
DECLARE @Rows INT

SELECT @Rows = COUNT(*)
FROM	Sales.SalesOrderHeader
WHERE	Status = 5

IF @Rows > 0 PRINT 'Found!'
GO


IF EXISTS (SELECT 1 FROM Sales.SalesOrderHeader WHERE	Status = 5)
	PRINT 'Found!'
GO


---------------------------------------------------------------------------------------------
-- Order by an Indexed column
---------------------------------------------------------------------------------------------

-- Create a table without the Index
SELECT * INTO Person.Person_NI FROM Person.Person
GO

SELECT P.BusinessEntityID FROM  Person.Person P ORDER BY P.BusinessEntityID
GO
SELECT P.BusinessEntityID FROM  Person.Person_NI P ORDER BY P.BusinessEntityID

---------------------------------------------------------------------------------------------
-- Index DISTINCT Columns
---------------------------------------------------------------------------------------------
SELECT DISTINCT P.BusinessEntityID FROM  Person.Person P
GO
SELECT DISTINCT P.BusinessEntityID FROM  Person.Person_NI P 

---------------------------------------------------------------------------------------------
-- Query on an Un-Indexed column
---------------------------------------------------------------------------------------------
SELECT P.LastName, P.BusinessEntityID FROM  Person.Person P WHERE P.BusinessEntityID = 6642; 
GO
SELECT P.LastName, P.BusinessEntityID FROM  Person.Person_NI P WHERE P.BusinessEntityID = 6642;




-- Clean-up time
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[Sales].[SalesOrderHeader]') AND name = N'IX_SalesOrderHeader_OrderDate')
	DROP INDEX [IX_SalesOrderHeader_OrderDate] ON [Sales].[SalesOrderHeader] 
GO
DROP TABLE Person.Person_NI
GO
