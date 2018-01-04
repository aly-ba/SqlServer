
use AdventureWorks

create table txml2 (invno int identity, invoicexml xml)

insert into txml2 values
('<Invoice InvoiceNo="1000">
    <Customer>Kim Abercrombie</Customer>
       <Items>
         <Item Product="1" Price="1.99" Quantity="2"/>
         <Item Product="3" Price="2.49" Quantity="1"/>
       </Items>
</Invoice>
')

insert into txml2 values
('<Invoice InvoiceNo="1001">
    <Customer>Sean Chai</Customer>
       <Items>
         <Item Product="1" Price="1.99" Quantity="2"/>
       </Items>
</Invoice>
')

insert into txml2 values
('<Invoice InvoiceNo="1002" Priority="10">
    <Customer>Perk Watson</Customer>
       <Items>
         <Item Product="1" Price="1.99" Quantity="4"/>
         <Item Product="2" Price="3.49" Quantity="5"/>
         <Item Product="3" Price="2.49" Quantity="3"/>
       </Items>
</Invoice>
')

select * from txml2

--ADD attributes to the ITEM nodes
--The documentation state that the first statement must be
--unique or singleton

declare @TotLines int

select @TotLines= max(invoicexml.value('count
((/Invoice/Items/Item))', 'int'))
from txml2

while @TotLines >= 1
begin
update txml2
set invoicexml.modify('
insert attribute Total {"0.0"} into 
 (/Invoice/Items/Item)[sql:variable("@TotLines")][1]
');
set @TotLines = @TotLines -1
end


(:insert attribute Total {"0.0"} into :)
 for $a in /Invoice/Items/Item[sql:variable("@TotLines")][1]
 insert attribute Total {"0.0"} into $a
 return $a 
(: (/Invoice/Items/Item)[sql:variable("@TotLines")] :)
