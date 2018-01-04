/****************************************************************
Course by: 	Pinal Dave  (http://blog.sqlauthority.com)
			Vinod Kumar (http://blogs.extremeExperts.com)

Scripts for SQL Server Performance: Query Tuning �Pluralsight.

Description: Script for basic IO example

****************************************************************/

USE AdventureWorks2012
GO

/***********************************************
New indexes for demo
DROP INDEX Sales.SalesOrderDetail.IX_SalesOrderDetail_1
CREATE INDEX IX_SalesOrderDetail_1 ON Sales.SalesOrderDetail(ProductID, SalesOrderID, SalesOrderDetailID, CarrierTrackingNumber)
**********************************************/

--SET STATISTICS IO ON

SELECT SalesOrderID
	,SalesOrderDetailID
	,CarrierTrackingNumber 
FROM Sales.SalesOrderDetail
WHERE ProductID = 707
GO
SELECT *
FROM Sales.SalesOrderDetail
WHERE ProductID = 707
GO
