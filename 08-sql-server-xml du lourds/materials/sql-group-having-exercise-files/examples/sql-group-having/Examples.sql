SELECT * FROM Franchisees

SELECT * FROM Stores;

SELECT * FROM [Unified Receipts];


SELECT * FROM Stores
GROUP BY zipcode;










SELECT zipcode FROM Stores
GROUP BY zipcode;











SELECT DISTINCT zipcode FROM Stores;








SELECT zipcode, COUNT(*) as Count from Stores
GROUP BY zipcode;











SELECT DISTINCT zipcode, COUNT(zipcode) as count 
FROM Stores;









SELECT zipcode, COUNT(*) as Count,
AVG([Years in business]) As 'Average' from Stores
GROUP BY zipcode;












select * from [Unified Receipts]

















SELECT S.Zipcode,
AVG(UR.Amount) AS 'Average', SUM(UR.Amount) AS 'Total'
FROM [Unified Receipts] AS UR JOIN Stores AS S
ON UR.[Store ID] = S.[ID]
Group By S.Zipcode   

















SELECT S.Zipcode,
AVG(UR.Amount) AS 'Average', SUM(UR.Amount) AS 'Total'
FROM [Unified Receipts] AS UR JOIN Stores AS S
ON UR.[Store ID] = S.[ID]
Group By S.Zipcode
HAVING AVG(UR.Amount) >=60
    
















SELECT substring(S.Zipcode, 5, 1) as 'last digit',
AVG(UR.Amount) AS 'Average', SUM(UR.Amount) AS 'Total'
FROM [Unified Receipts] AS UR JOIN Stores AS S
ON UR.[Store ID] = S.[ID]
Group By substring(S.Zipcode, 5, 1);

















SELECT S.Zipcode,
AVG(UR.Amount) AS 'Average', SUM(UR.Amount) AS 'Total'
FROM [Unified Receipts] AS UR JOIN Stores AS S
ON UR.[Store ID] = S.[ID]
Group By S.Zipcode
HAVING AVG(UR.Amount) >=60

















SELECT * FROM [Unified Receipts]

















SELECT S.Zipcode,
AVG(UR.Amount) AS 'Average', SUM(UR.Amount) AS 'Total'
FROM [Unified Receipts] AS UR JOIN Stores AS S
ON UR.[Store ID] = S.[ID]
WHERE UR.Amount > 50
Group By S.Zipcode
HAVING AVG(UR.Amount) >=60

















SELECT UR.[Store ID], UR.[Cashier ID],
AVG(UR.Amount) AS 'Average', SUM(UR.Amount) AS 'Total'
FROM [Unified Receipts] AS UR
GROUP BY UR.[Store ID], UR.[Cashier ID]

















SELECT 

