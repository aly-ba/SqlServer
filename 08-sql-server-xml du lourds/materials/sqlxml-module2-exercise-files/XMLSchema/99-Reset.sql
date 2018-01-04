use tempdb
go

-- if needed
IF OBJECTPROPERTY(object_id('invoice_docs'), 'IsUserTable') = 1
   DROP TABLE invoice_docs
go

-- if needed
DROP XML SCHEMA COLLECTION InvoiceType
-- go