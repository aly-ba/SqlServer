
USE [tempdb]
go

INSERT INTO invoice_docs(invoice)
SELECT * FROM OPENROWSET(
   BULK 'C:\invoice4.xml',
   SINGLE_BLOB) AS x
go

-- END OF ATTEMPT TO INSERT FRAGMENT

-- "content" indicates fragments are allowed
ALTER TABLE invoice_docs 
  ALTER COLUMN invoice XML(content InvoiceType)
go

-- END OF ALTER TABLE

-- now the insert will work
INSERT INTO invoice_docs(invoice)
SELECT * FROM OPENROWSET(
   BULK 'C:\invoice4.xml',
   SINGLE_BLOB) AS x
go

SELECT * FROM invoice_docs
go