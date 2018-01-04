
use tempdb
go

CREATE FUNCTION getidvalue(@invoice xml)
RETURNS INT WITH SCHEMABINDING AS
BEGIN
RETURN @invoice.value('/*[1]/@ID','INT')
END 
go

-- constraint
CREATE TABLE Invoices (
  id INT PRIMARY KEY,
  invoice xml,
CONSTRAINT id_chk CHECK(
  dbo.getidvalue(invoice)=id)
)

-- test it
INSERT INTO Invoices VALUES(1, '<Invoice ID="1"/>')
INSERT INTO Invoices VALUES(1, '<Invoice ID="2"/>')
INSERT INTO Invoices VALUES(1, '<Invoice ID="1"/>')

-- or even primary key
CREATE TABLE Invoices2 (
  invoice xml,
  id as dbo.getidvalue(invoice) persisted primary key
)
go

-- test it
INSERT INTO Invoices2 VALUES('<Invoice ID="1"/>')
INSERT INTO Invoices2 VALUES('<Invoice ID="2"/>')
INSERT INTO Invoices2 VALUES('<Invoice ID="1"/>')
INSERT INTO Invoices2 VALUES('<Invoice ID="3"/><Invoice ID="2"/>')

SELECT * FROM Invoices2

