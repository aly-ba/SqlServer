/****************************************************************
Course by: 	Pinal Dave  (http://blog.sqlauthority.com)
			Vinod Kumar (http://blogs.extremeExperts.com)

Scripts for SQL Server Performance: Query Tuning ©Pluralsight.

Description: Using Dynamic SQL inside a SP

****************************************************************/
Use AdventureWorks2012
GO
SET NOCOUNT ON
GO
CREATE PROCEDURE Dynamic_SQL_SP ( @SalesOrderID INT,
		@SalesOrderDate DATETIME)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX)

	SET @SQL = 'SELECT * FROM Sales.SalesOrderHeader WHERE 1=1 '

	IF @SalesOrderID IS NOT NULL
		SET @SQL = @SQL + ' AND	SalesOrderID = @SalesOrderID '

	IF @SalesOrderDate IS NOT NULL
		SET @SQL = @SQL + ' AND	OrderDate = @SalesOrderDate '

	EXEC sp_executesql 
		@SQL, 
		N'@SalesOrderID int, @SalesOrderDate DATETIME', 
		@SalesOrderID, @SalesOrderDate
END
GO

DECLARE @SalesOrderID INT,
		@SalesOrderDate DATETIME

SELECT @SalesOrderID = 54321,
		@SalesOrderDate = NULL  -- '7/3/2006'

Exec Dynamic_SQL_SP @SalesOrderID, @SalesOrderDate

SELECT
	*
FROM
	Sales.SalesOrderHeader
WHERE  ( SalesOrderID = @SalesOrderID OR  @SalesOrderID IS NULL )
AND		OrderDate = COALESCE(@SalesOrderDate, OrderDate)
GO

-- Clean up
DROP PROCEDURE Dynamic_SQL_SP