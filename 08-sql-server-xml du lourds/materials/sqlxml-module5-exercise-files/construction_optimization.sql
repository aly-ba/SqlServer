
-- For XML PATH vs XQuery constructions
use tempdb
go

DROP TABLE Customers -- if exists

CREATE TABLE Customers (
 cid int primary key,
 name nvarchar(50),
 notes xml
)
go 

INSERT customers VALUES(1, 'John Smith', '')
INSERT customers VALUES(2, 'Jack Jones', '')
INSERT customers VALUES(3, 'Mary Johnson', '')
GO

SELECT notes.query('
<Customer cid="{sql:column(''cid'')}">
{<name>{sql:column("name")}</name>, /}</Customer>')
FROM Customers WHERE cid=1

SELECT cid as "@cid", name, notes as "*"
FROM Customers 
WHERE cid=1
FOR XML PATH('Customer'), TYPE