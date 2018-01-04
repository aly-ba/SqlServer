
use tempdb
go

create user mary without login
go

create table sectab (thexml xml(InvoiceType))
go

grant select, insert on sectab to mary
go

deny execute on xml schema collection::InvoiceType to mary

insert sectab values(
'<inv:Invoice xmlns:inv="urn:www-company-com:invoices" >
   <inv:InvoiceID>1000</inv:InvoiceID>
   <inv:CustomerName>Jane Smith</inv:CustomerName>
   <inv:LineItems>
      <inv:LineItem>
         <inv:Sku>134</inv:Sku>
         <inv:Description>Cola</inv:Description>
         <inv:Price>0.95</inv:Price>
      </inv:LineItem>
   </inv:LineItems>
</inv:Invoice>')
go

execute as user='mary'
select * from sectab
select thexml.query('/') from sectab


insert sectab values(
'<inv:Invoice xmlns:inv="urn:www-company-com:invoices" >
   <inv:InvoiceID>1000</inv:InvoiceID>
   <inv:CustomerName>Jane Smith</inv:CustomerName>
   <inv:LineItems>
      <inv:LineItem>
         <inv:Sku>134</inv:Sku>
         <inv:Description>Cola</inv:Description>
         <inv:Price>0.95</inv:Price>
      </inv:LineItem>
   </inv:LineItems>
</inv:Invoice>')

revert
go

create schema marystuff authorization mary
go

grant create table to mary
go

grant references on xml schema collection::InvoiceType to mary

execute as user='mary'
create table marystuff.t1( id int, thexml xml(InvoiceType))
revert

deny view definition  on xml schema collection::InvoiceType to mary


execute as user='mary'
select xml_schema_namespace(N'dbo', N'InvoiceType')
select * from sys.xml_schema_collections
revert
go

drop table sectab
drop user mary