/****************************************************************
Course by: 	Pinal Dave  (http://blog.sqlauthority.com)
			Vinod Kumar (http://blogs.extremeExperts.com)

Scripts for SQL Server Performance: Query Tuning ©Pluralsight.

Description: Performance analysis of Scalar functions

****************************************************************/
USE AdventureWorks2012
GO
-- Create scalar function
CREATE FUNCTION dbo.fnScalar (@ProductID INT)
RETURNS INT
BEGIN
	DECLARE @val INT
	SELECT @val = COUNT(*) 
	FROM Sales.SalesOrderDetail
	WHERE ProductID = @ProductID
	RETURN @val
END
GO
-------------------------
-- Let us compare following both the query together
SET STATISTICS IO ON
GO
SELECT COUNT(*)
FROM Sales.SalesOrderDetail
WHERE ProductID = 777
GO
SELECT dbo.fnScalar(777)
GO
-------------------------
-- Let us compare following both the query together
SET STATISTICS IO ON
SET STATISTICS TIME ON
--SET STATISTICS PROFILE OFF
GO
SELECT dbo.fnScalar(p.ProductID) cPRoductID, p.ProductID
FROM Production.Product p
ORDER BY p.ProductID
GO
SELECT ISNULL(cProductID,0) cPRoductID, p.ProductID
FROM Production.Product p
LEFT JOIN 
(SELECT ProductID, COUNT(s.ProductID) cProductID
FROM Sales.SalesOrderDetail s
GROUP BY s.ProductID) sub ON sub.ProductID = p.ProductID 
ORDER BY p.ProductID
GO
-------------------------
-- Clean up
DROP FUNCTION dbo.fnScalar
GO
