SELECT soh.AccountNumber, COUNT(DISTINCT sod.ProductID) AS UniqueProducts
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesOrderDetail AS sod
	ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.AccountNumber