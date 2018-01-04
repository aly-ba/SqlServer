use xmltest
go

-- update when changed
update statistics xmlinvoice
dbcc freeproccache

-- without an XML index

-- top-down - base table processed first (top of graphic showplan)
-- Base table - clustered index scan
-- TVF /Invoice (id, in output list)
-- TVF /Invoice/InvoiceID (id, value in output list)
select * from xmlinvoice 
where invoice.exist('/Invoice[@InvoiceID = "1003"]') = 1

select * from xmlinvoice 
where invoice.exist('/Invoice[CustomerName = "Joe Johnson"]') = 1

select * from xmlinvoice 
where invoice.exist('/Invoice/LineItems/LineItem[Sku = "331"]') = 1

-- using FLWOR instead of XPath
select * from xmlinvoice 
where invoice.exist('
for $x in /Invoice/@InvoiceID
where $x = "1003"
return $x
') = 1

-- vs original
select * from xmlinvoice 
where invoice.exist('/Invoice[@InvoiceID = "1003"]') = 1

-- query plan change? yes, better 
-- top-down
-- Base table - clustered index scan
-- TVF /Invoice/@InvoiceID (only looks for values in output list)
select * from xmlinvoice 
where invoice.exist('/Invoice/@InvoiceID[. = "1003"]') = 1

-- vs singleton ensured
select * from xmlinvoice 
where invoice.exist('/Invoice[1]/@InvoiceID[. = "1003"]') = 1

-- vs singleton at the end (note: this is not necessarily equivalent to the previous query)
select * from xmlinvoice 
where invoice.exist('(/Invoice/@InvoiceID)[1][. = "1003"]') = 1

-- vs original
select * from xmlinvoice 
where invoice.exist('/Invoice[@InvoiceID = "1003"]') = 1

select * from xmlinvoice 
where invoice.exist('/Invoice/CustomerName [. = "Joe Johnson"]') = 1

-- vs original
select * from xmlinvoice 
where invoice.exist('/Invoice[CustomerName = "Joe Johnson"]') = 1

select * from xmlinvoice 
where invoice.exist('/Invoice/LineItems/LineItem/Sku[. = "331"]') = 1

-- value vs exist
select * from xmlinvoice 
where invoice.value('/Invoice[1]/@InvoiceID', 'varchar(10)') = '1003'

select * from xmlinvoice 
where invoice.exist('(/Invoice/@InvoiceID)[1][. = "1003"]') = 1

select * from sys.internal_tables

-- xml primary
create primary xml index invoiceidx ON xmlinvoice(invoice)

select * from sys.internal_tables

select * from sys.xml_index_nodes_2105058535_256000

-- see columns in the node table
SELECT c.object_id, substring(c.name,1,10), c.column_id, c.system_type_id, c.user_type_id, max_length, precision FROM sys.columns c
 JOIN sys.indexes i ON i.object_id = c.object_id
 WHERE i.name = 'invoiceidx'
 AND i.type = 1
go

-- space used, table and indexes
sp_spaceused 'xmlinvoice' 

-- space used, all indexes in this DB
-- there should only be XML indexes
select * from sys.dm_db_index_physical_stats(
 DB_ID('xmltest'), null, null, null, 'detailed')
go

-- to drop an XML index
-- you need to use indexname, tablename as with "regular" indexes
-- drop index invoiceidx on xmlinvoice

dbcc freeproccache

-- best choice of query from before index
-- bottom-up execution (XQuery done first, then joined with base table)
-- clustered index scan for InvoiceID, then filter on value
-- clustered index seek on base table
select * from xmlinvoice 
where invoice.exist('(/Invoice/@InvoiceID)[1][. = "1003"]') = 1

-- compare to non-indexed table
select * from xmlinvoice3
where invoice.exist('(/Invoice/@InvoiceID)[1][. = "1003"]') = 1

select * from xmlinvoice 
where invoice.exist('/Invoice/CustomerName [. = "Joe Johnson"]') = 1

-- compare to non-indexed table
select * from xmlinvoice3 
where invoice.exist('/Invoice/CustomerName [. = "Joe Johnson"]') = 1

-- worst choice of query from before index
-- bottom-up execution (XQuery done first, then joined with base table)
-- clustered index scan for InvoiceID, then filter on value
-- clustered index seek on Invoice, then nested loop join
-- clustered index seek on base table
select * from xmlinvoice 
where invoice.exist('/Invoice[@InvoiceID = "1003"]') = 1

select * from xmlinvoice 
where invoice.exist('/Invoice/@InvoiceID[. = "1003"]') = 1

-- create path index (only)
create xml index invpathidx on xmlinvoice(invoice)
 using xml index invoiceidx for path
dbcc freeproccache

-- bottom-up execution (XQuery done first, then joined with base table)
-- index seek on the PATH index (for the value 1003)
-- clustered index seek on base table
select * from xmlinvoice 
where invoice.exist('/Invoice/@InvoiceID[. = "1003"]') = 1

-- now create the other two secondary indexes
create xml index invvalidx on xmlinvoice(invoice)
 using xml index invoiceidx for value

create xml index invpropidx on xmlinvoice(invoice)
 using xml index invoiceidx for property

dbcc freeproccache

-- now it uses the value index instead
-- bottom-up execution (XQuery done first, then joined with base table)
-- index seek on the VALUE index (for the value 1003)
-- clustered index seek on base table
select * from xmlinvoice 
where invoice.exist('/Invoice/@InvoiceID[. = "1003"]') = 1

-- because neither path nor value is selective enough
-- top-down execution
-- clustered index scan on base table
-- index seek on the PROPERTY index (for the text property)
select *
from xmlinvoice
where invoice.exist('/Invoice//CustomerName[text() = "Mary Weaver"]') = 1

select *
from xmlinvoice
where invoice.exist('/Invoice//CustomerName[. = "Mary Weaver"]') = 1