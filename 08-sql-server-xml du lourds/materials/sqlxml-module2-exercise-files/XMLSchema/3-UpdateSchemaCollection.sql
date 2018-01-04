
USE [tempdb]
go

-- Load the new XML schema from a file
DECLARE @x XML
SET @x = (
SELECT * FROM OPENROWSET(
   BULK 'C:\invoice_v2.xsd',
           SINGLE_BLOB
) AS x
)

-- And use it to create an XML schema collection
-- Allow V1 and V2 invoices
ALTER XML SCHEMA COLLECTION InvoiceType ADD @x
go

-- XML SCHEMA COLLECTION ALTERED

-- Buy more than one product at a time
-- Include the required invoice date
INSERT INTO invoice_docs(invoice)
SELECT * FROM OPENROWSET(
   BULK 'C:\invoice3.xml',
   SINGLE_BLOB) AS x
go