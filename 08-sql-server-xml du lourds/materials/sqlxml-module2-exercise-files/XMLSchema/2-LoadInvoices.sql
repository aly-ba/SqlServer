
USE [tempdb]
go

-- Insert an Invoice
INSERT INTO invoice_docs(invoice)
SELECT * FROM OPENROWSET(
   BULK 'C:\invoice1.xml',
   SINGLE_BLOB) AS x
go

-- FIRST DOCUMENT LOADED

SELECT * FROM invoice_docs

-- SELECTED ROW CONTAINING DOCUMENT

-- Attempt to buy more than one product at a time
-- Fails
INSERT INTO invoice_docs(invoice)
SELECT * FROM OPENROWSET(
   BULK 'C:\invoice2.xml',
   SINGLE_BLOB) AS x
go

insert invoice_docs values('
<inv:Invoice xmlns:inv="urn:www-company-com:invoices" >
   <inv:InvoiceID>1000</inv:InvoiceID>
   <inv:CustomerName>Jane Smith</inv:CustomerName>
   <inv:LineItems>
      <inv:LineItem>
         <inv:Sku>1134</inv:Sku>
         <inv:Description>Cola</inv:Description>
         <inv:Price>0.95</inv:Price>
      </inv:LineItem>
   </inv:LineItems>
</inv:Invoice>
')

insert invoice_docs values('
      <inv:LineItem xmlns:inv="urn:www-company-com:invoices" >
         <inv:Sku>124</inv:Sku>
         <inv:Description>Cola</inv:Description>
         <inv:Price>0.95</inv:Price>
      </inv:LineItem>
')

