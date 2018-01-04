
use xmltest
go

create table xmlinvoice3(
 invoiceid integer identity primary key,
 invoice xml
)

insert into xmlinvoice3 values('
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

insert into xmlinvoice3 values('
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

insert into xmlinvoice3 values('
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

insert into xmlinvoice3 values('
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

insert into xmlinvoice3 values('
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

insert into xmlinvoice3 values('
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

select * from xmlinvoice3

