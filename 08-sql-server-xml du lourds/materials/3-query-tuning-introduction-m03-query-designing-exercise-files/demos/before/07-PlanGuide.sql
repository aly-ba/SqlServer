/****************************************************************
Course by: 	Pinal Dave  (http://blog.sqlauthority.com)
			Vinod Kumar (http://blogs.extremeExperts.com)

Scripts for SQL Server Performance: Query Tuning ©Pluralsight.

Description: Using Plan Guide exxample

****************************************************************/
USE AdventureWorks2012
GO
-- Count Country 
SELECT COUNT(*) CntCountry, CountryRegionCode
    FROM Sales.SalesOrderHeader AS h 
	INNER JOIN Sales.Customer AS c ON h.CustomerID = c.CustomerID
    INNER JOIN Sales.SalesTerritory AS t ON c.TerritoryID = t.TerritoryID
GROUP BY CountryRegionCode
GO
/*
CntCountry  CountryRegionCode
----------- -----------------
3219        GB
2623        DE
6843        AU
4067        CA
2672        FR
12041       US
*/

-- Create SP [Sales].[GetSalesOrderByCountry]
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Sales].[GetSalesOrderByCountry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [Sales].[GetSalesOrderByCountry]
GO
CREATE PROCEDURE Sales.GetSalesOrderByCountry (@Country_region nvarchar(60))
AS
BEGIN
    SELECT *
    FROM Sales.SalesOrderHeader AS h 
	INNER JOIN Sales.Customer AS c ON h.CustomerID = c.CustomerID
    INNER JOIN Sales.SalesTerritory AS t ON c.TerritoryID = t.TerritoryID
    WHERE CountryRegionCode = @Country_region
END;
GO
-- Enable Execution Plan by CTRL + M 
DBCC FREEPROCCACHE 
GO
EXEC Sales.GetSalesOrderByCountry N'US'
GO
DBCC FREEPROCCACHE 
GO
EXEC Sales.GetSalesOrderByCountry N'AU'
GO

/* OBJECT */
/* Create Execution Plan Gide for the same*/
sp_create_plan_guide 
@name = N'Guide_SalesGetSalesOrderByCountry',
@stmt = N'SELECT * 
		FROM Sales.SalesOrderHeader AS h 
		INNER JOIN Sales.Customer AS c ON h.CustomerID = c.CustomerID
		INNER JOIN Sales.SalesTerritory AS t ON c.TerritoryID = t.TerritoryID
		WHERE CountryRegionCode = @Country_region',
@type = N'OBJECT',
@module_or_batch = N'Sales.GetSalesOrderByCountry',
@params = NULL,
@hints = N'OPTION (OPTIMIZE FOR (@Country_region = N''US''))';
GO

-- Enable Execution Plan by CTRL + M 
DBCC FREEPROCCACHE 
GO
EXEC Sales.GetSalesOrderByCountry N'US'
GO
DBCC FREEPROCCACHE 
GO
EXEC Sales.GetSalesOrderByCountry N'AU'
GO

--Disable the plan guide.
EXEC sp_control_plan_guide N'DISABLE', N'Guide_SalesGetSalesOrderByCountry';
GO
--Enable the plan guide.
EXEC sp_control_plan_guide N'ENABLE', N'Guide_SalesGetSalesOrderByCountry';
GO
--Drop the plan guide.
EXEC sp_control_plan_guide N'DROP', N'Guide_SalesGetSalesOrderByCountry';
GO

/* SQL */
/* Create Execution Plan Gide for the same*/
sp_create_plan_guide 
@name = N'Guide_SalesGetSalesOrderByCountrySQL', 
@stmt = N'SELECT * FROM Sales.Customer AS c INNER JOIN Sales.SalesTerritory AS t ON c.TerritoryID = t.TerritoryID;',
@type = N'SQL',
@module_or_batch = NULL, 
@params = NULL, 
@hints = N'OPTION (MERGE JOIN)';
GO

-- Enable Execution Plan by CTRL + M 
--DBCC FREEPROCCACHE 
--GO
SELECT * FROM Sales.Customer AS c INNER JOIN Sales.SalesTerritory AS t ON c.TerritoryID = t.TerritoryID;
SELECT * FROM Sales.Customer AS c INNER JOIN Sales.SalesTerritory AS t ON c.TerritoryID = t.TerritoryID OPTION (MERGE JOIN);
GO

--Drop the plan guide.
EXEC sp_control_plan_guide N'DROP', N'Guide_SalesGetSalesOrderByCountrySQL';
GO