
use tempdb
go

create function getid (@data xml)
returns int
with schemabinding
as
begin
 return @data.value('/Invoice[1]/@InvoiceID', 'int')
end
go

create function getname (@data xml)
returns varchar(100)
with schemabinding
as
begin
 return @data.value('(/Invoice/CustomerName/text())[1]', 'varchar(100)')
end
go

create table invoices (
 xmlinvoice xml,
 id as dbo.getid(xmlinvoice) persisted primary key,
 name as dbo.getname(xmlinvoice) persisted
)
go

insert into invoices values('
<Invoice InvoiceID="1000" dept="hardware">
   <CustomerName>Jane Smith</CustomerName>
   <LineItems>
      <LineItem>
         <Sku>134</Sku>
         <Description>Gear</Description>
         <Price>9.95</Price>
      </LineItem>
   </LineItems>
</Invoice>')

insert into invoices values('
<Invoice InvoiceID="1001" dept="hardware">
   <CustomerName>Fred Jones</CustomerName>
   <LineItems>
      <LineItem>
         <Sku>118</Sku>
         <Description>Widget</Description>
         <Price>2.95</Price>
      </LineItem>
   </LineItems>
</Invoice>')

insert into invoices values('
<Invoice InvoiceID="1002" dept="garden" backorder="true">
   <CustomerName>Joe Johnson</CustomerName>
   <LineItems>
      <LineItem>
         <Sku>534</Sku>
         <Description>Shovel</Description>
         <Price>19.95</Price>
      </LineItem>
      <LineItem>
         <Sku>537</Sku>
         <Description>Fork</Description>
         <Price>39.95</Price>
      </LineItem>
   </LineItems>
</Invoice>')

insert into invoices values('
<Invoice InvoiceID="1003" dept="garden">
   <CustomerName>Abe Wells</CustomerName>
   <LineItems>
      <LineItem>
         <Sku>331</Sku>
         <Description>Trellis</Description>
         <Price>9.95</Price>
      </LineItem>
   </LineItems>
</Invoice>')

insert into invoices values('
<Invoice InvoiceID="1004" dept="sundries">
   <CustomerName>Mary Weaver</CustomerName>
   <LineItems>
      <LineItem>
         <Sku>795</Sku>
         <Description>Umbrella</Description>
         <Price>4.95</Price>
      </LineItem>
   </LineItems>
</Invoice>')

insert into invoices values('
<Invoice InvoiceID="1005" dept="hardware">
   <CustomerName>Patricia Walker</CustomerName>
   <LineItems>
      <LineItem>
         <Sku>134</Sku>
         <Description>Gear</Description>
         <Price>9.95</Price>
      </LineItem>
      <LineItem>
         <Sku>118</Sku>
         <Description>Widget</Description>
         <Price>2.95</Price>
      </LineItem>
   </LineItems>
</Invoice>')
go

-- lookup by invoiceID
select * from invoices where id > 1002

select * from invoices where xmlinvoice.value('/Invoice[1]/@InvoiceID', 'int') > 1002

-- lookup by customer name
select id, 
       xmlinvoice.value('(/Invoice/CustomerName/text())[1]', 'varchar(100)') as name,
       xmlinvoice 
from invoices 
where xmlinvoice.value('(/Invoice/CustomerName/text())[1]', 'varchar(100)') LIKE 'Mary%'

select id, name, xmlinvoice
from invoices
where name LIKE 'Mary%'

-- cleanup
drop table invoices
drop function getid
drop function getname