-- Sample Query to Generate Wait Stats
USE AdventureWorks2012
GO
SELECT *
FROM Sales.SalesOrderDetail
UNION ALL
SELECT *
FROM Sales.SalesOrderDetail
ORDER BY [OrderQty] DESC
GO 100


----------------------------------------------------------------------
-- Single CPU Utilization at Query Level
USE AdventureWorks2012
GO
SELECT *
FROM Sales.SalesOrderDetail
UNION ALL
SELECT *
FROM Sales.SalesOrderDetail
ORDER BY [OrderQty] DESC
OPTION (MAXDOP 1)
GO 100 

----------------------------------------------------------------------
-- Single CPU Utilization at Server Level
------------------------------------------------------------------------------------
-- CPU 
------------------------------------------------------------------------------------
EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
GO
-- Changing Max Degree of Parallelism to 1 - Single CPU
EXEC sys.sp_configure N'max degree of parallelism', N'1'
GO
RECONFIGURE WITH OVERRIDE
GO

-- Sample Query to Generate Wait Stats
USE AdventureWorks2012
GO
SELECT *
FROM Sales.SalesOrderDetail
UNION ALL
SELECT *
FROM Sales.SalesOrderDetail
ORDER BY [OrderQty] DESC
GO 100

-- Changing Max Degree of Parallelism to 0 - ALL CPU
EXEC sys.sp_configure N'max degree of parallelism', N'0'
GO
RECONFIGURE WITH OVERRIDE
GO
------------------------------------------------------------------------------------
-- Cost 
------------------------------------------------------------------------------------
EXEC sys.sp_configure N'show advanced options', N'1'  
GO
RECONFIGURE WITH OVERRIDE
GO
-- Changing Cost Threshold to higher Values - ALL CPU
EXEC sys.sp_configure N'cost threshold for parallelism', N'30'
GO
RECONFIGURE WITH OVERRIDE
GO

-- Sample Query to Generate Wait Stats
USE AdventureWorks2012
GO
SELECT *
FROM Sales.SalesOrderDetail
UNION ALL
SELECT *
FROM Sales.SalesOrderDetail
ORDER BY [OrderQty] DESC
GO 100

-- Changing Cost Threshold to higher Values - ALL CPU
EXEC sys.sp_configure N'cost threshold for parallelism', N'5'
GO
RECONFIGURE WITH OVERRIDE
GO
