
USE [tempdb]
go


-- Load XML from a file
DECLARE @x XML
SET @x = (
SELECT * FROM OPENROWSET(
   BULK 'C:\invoice.xsd',
           SINGLE_BLOB
) AS x
)

-- And use it to create an XML schema collection
CREATE XML SCHEMA COLLECTION InvoiceType AS @x
go

-- XML SCHEMA COLLECTION CREATED

CREATE TABLE invoice_docs (
 invoiceid INTEGER PRIMARY KEY IDENTITY,
 invoice   XML(document InvoiceType)
)
go

-- check schema information
SELECT * FROM sys.xml_schema_collections
SELECT * FROM sys.xml_schema_namespaces
SELECT * FROM sys.column_xml_schema_collection_usages







