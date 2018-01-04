-- You can get the AdventureWorksDW2012 database used in these demos from http://bit.ly/9hBGub

USE [AdventureWorksDW2012];
GO

EXEC sp_helpindex 'FactInternetSales';
GO

DELETE [dbo].[FactInternetSales]
WHERE [SalesTerritoryKey] = 10;
GO