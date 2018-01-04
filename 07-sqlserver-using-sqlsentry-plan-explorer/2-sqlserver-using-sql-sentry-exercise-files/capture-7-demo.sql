USE AdventureWorks
GO

IF OBJECT_ID('SearchAllOrders_DynamicSQL') IS NOT NULL
	DROP PROCEDURE dbo.SearchAllOrders_DynamicSQL;
GO
CREATE PROCEDURE dbo.SearchAllOrders_DynamicSQL
(	@OrderDate DATETIME = NULL,
	@AccountNumber AccountNumber = NULL)
AS
SET NOCOUNT ON;

IF @AccountNumber IS NOT NULL
BEGIN
	SELECT COUNT(*) AS OrderCount
	FROM Sales.SalesOrderHeader
	WHERE AccountNumber = @AccountNumber;
END
ELSE
BEGIN
	SELECT 0 AS OrderCount
END

DECLARE @sql nvarchar(max);

SELECT @sql = 'SELECT AccountNumber, OrderDate, ProductID, SUM(OrderQty) 
FROM Sales.SalesOrderHeader
JOIN Sales.SalesOrderDetail ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
WHERE 1=1
'; 

IF @OrderDate IS NOT NULL 
	SET @sql = @sql +  'AND (OrderDate >= @OrderDate)
'

IF @AccountNumber IS NOT NULL
	 SET @sql = @sql + 'AND (AccountNumber = @AccountNumber)
'

SET @sql = @sql +
'GROUP BY AccountNumber, OrderDate, ProductID
';


EXEC sp_executesql 
			@sql, 
			N'@OrderDate datetime, @AccountNumber AccountNumber',
			@OrderDate = @OrderDate, @AccountNumber = @AccountNumber;
GO

EXECUTE dbo.SearchAllOrders_DynamicSQL '2003-01-17', N'10-4020-000118';
GO
