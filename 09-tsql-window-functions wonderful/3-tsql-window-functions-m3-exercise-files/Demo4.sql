/*
T-SQL Window Functions
Module 3
Demo 4
*/

USE AdventureWorks2014;
GO
SET STATISTICS IO ON;
GO

SELECT ProductID, name, ListPrice, Color,
	ROW_NUMBER() OVER(PARTITION BY Color ORDER BY name) AS RowNum
FROM Production.Product;


CREATE INDEX IX_Product_Mod3_Demo4 ON Production.Product
	(Color, Name) INCLUDE(ListPrice);

SELECT ProductID, name, ListPrice, Color,
	ROW_NUMBER() OVER(PARTITION BY Color ORDER BY name) AS RowNum
FROM Production.Product;

--Descending order
SELECT ProductID, name, ListPrice, Color,
	ROW_NUMBER() OVER(PARTITION BY Color ORDER BY name DESC) AS RowNum
FROM Production.Product;

--Different order
SELECT ProductID, name, ListPrice, Color,
	ROW_NUMBER() OVER(PARTITION BY Color ORDER BY name) AS RowNum
FROM Production.Product
ORDER BY name;

--Add a WHERE clause
SELECT ProductID, name, ListPrice, Color,
	ROW_NUMBER() OVER(PARTITION BY Color ORDER BY name) AS RowNum
FROM Production.Product
WHERE ListPrice > 0;

DROP INDEX IX_Product_Mod3_Demo4 ON Production.Product;

CREATE INDEX IX_Product_Mod3_Demo4 ON Production.Product
	(ListPrice, Color, Name);

--Where clause
SELECT ProductID, name, ListPrice, Color,
	ROW_NUMBER() OVER(PARTITION BY Color ORDER BY name) AS RowNum
FROM Production.Product
WHERE ListPrice > 0;


--Join
SELECT P.ProductID, p.name, p.ListPrice, p.Color,
	ROW_NUMBER() OVER(PARTITION BY p.Color ORDER BY SOD.OrderQty) AS RowNum
FROM Production.Product AS P 
JOIN Sales.SalesOrderDetail AS SOD ON P.ProductID = SOD.ProductID;



CREATE INDEX IX_SalesOrderDetail_Mod3_Demo4 ON Sales.SalesOrderDetail 
	(ProductID, OrderQty);

SELECT P.ProductID, p.name, p.ListPrice, p.Color,
	ROW_NUMBER() OVER(PARTITION BY p.Color ORDER BY SOD.OrderQty) AS RowNum
FROM Production.Product AS P 
JOIN Sales.SalesOrderDetail AS SOD ON P.ProductID = SOD.ProductID;

SELECT P.ProductID, p.name, p.ListPrice, p.Color,
	ROW_NUMBER() OVER(PARTITION BY p.Color ORDER BY SOD.OrderQty) AS RowNum
FROM Production.Product AS P 
JOIN Sales.SalesOrderDetail AS SOD WITH (INDEX (0)) ON P.ProductID = SOD.ProductID;

--Clean up
DROP INDEX IX_SalesOrderDetail_Mod3_Demo4 ON Sales.SalesOrderDetail;
DROP INDEX IX_Product_Mod3_Demo4 ON Production.Product;

