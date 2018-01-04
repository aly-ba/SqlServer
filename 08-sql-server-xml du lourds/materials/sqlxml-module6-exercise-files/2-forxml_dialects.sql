USE Northwind
GO

SELECT Customers.CustomerID, Orders.OrderID
FROM Customers, Orders 
WHERE Customers.CustomerID = Orders.CustomerID 
ORDER BY Customers.CustomerID 
FOR XML RAW, ELEMENTS

SELECT Customers.CustomerID, Orders.OrderID
FROM Customers, Orders 
WHERE Customers.CustomerID = Orders.CustomerID 
ORDER BY Customers.CustomerID 
FOR XML AUTO, ELEMENTS

SELECT 	1 as Tag, NULL as Parent,
    Customers.CustomerID as [Customer!1!CustomerID],
    NULL as [Order!2!OrderID]
FROM Customers
UNION ALL
SELECT 	2, 1,
    Customers.CustomerID,
    Orders.OrderID
FROM Customers, Orders
WHERE Customers.CustomerID = Orders.CustomerID
ORDER BY [Customer!1!CustomerID]
FOR XML EXPLICIT

use pubs
go

WITH XMLNAMESPACES('http://somens' As au)
SELECT
  au_id as [@au:authorid],
  au_fname as [name/firstname],
  au_lname as [name/lastname]
FROM authors FOR XML PATH ('author'), TYPE
go

-- using the TYPE specifier, even subqueries are allowed
declare @x xml;
WITH XMLNAMESPACES('http://somens' As au)
SELECT @x = (
SELECT
  au_id as [@au:authorid],
  au_fname as [name/firstname],
  au_lname as [name/lastname]
FROM authors FOR XML PATH('author'), TYPE ).query('//firstname')
SELECT @x


