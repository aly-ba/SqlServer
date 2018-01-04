/****************************************************************
Course by: 	Pinal Dave  (http://blog.sqlauthority.com)
			Vinod Kumar (http://blogs.extremeExperts.com)

Scripts for SQL Server Performance: Query Tuning ©Pluralsight.

Description: Performance of Dynamic SQL inside SQL Server

****************************************************************/
USE AdventureWorks2012
GO
SET NOCOUNT ON
GO

DECLARE @SalesOrderID INT
SET @SalesOrderID = 54321

SELECT	*
FROM	Sales.SalesOrderHeader
WHERE	SalesOrderID = @SalesOrderID
GO


-- Using COALESCE
DECLARE @SalesOrderID INT
SET @SalesOrderID = 54321
	
SELECT	*
FROM	Sales.SalesOrderHeader
WHERE	SalesOrderID = COALESCE(@SalesOrderID, SalesOrderID)
GO	

-- Using OR @Parm with IS NULL
DECLARE @SalesOrderID INT
SET @SalesOrderID = 54321
	
SELECT	*
FROM	Sales.SalesOrderHeader
WHERE	SalesOrderID = @SalesOrderID  OR  @SalesOrderID IS NULL
GO	


-- Gets complex with multiple parameters
-- Nulls & conditional parameters
DECLARE @SalesOrderID INT,
		@SalesOrderDate DATETIME
		
SELECT @SalesOrderID = 54321,
		@SalesOrderDate = NULL  -- '7/3/2006'

DECLARE @SQL NVARCHAR(MAX)

SET @SQL = 'SELECT * FROM Sales.SalesOrderHeader WHERE 1=1 '

IF @SalesOrderID IS NOT NULL
	SET @SQL = @SQL + ' AND	SalesOrderID = @SalesOrderID '

IF @SalesOrderDate IS NOT NULL
	SET @SQL = @SQL + ' AND	OrderDate = @SalesOrderDate '

-- PRINT @SQL

EXEC sp_executesql 
	@SQL, 
	N'@SalesOrderID int, @SalesOrderDate DATETIME', 
	@SalesOrderID, @SalesOrderDate


SELECT
	*
FROM
	Sales.SalesOrderHeader
WHERE  ( SalesOrderID = @SalesOrderID OR  @SalesOrderID IS NULL )
AND		OrderDate = COALESCE(@SalesOrderDate, OrderDate)
GO