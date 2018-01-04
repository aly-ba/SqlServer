

declare @x xml
set @x = 
'<Invoice>
   <InvoiceID>1000</InvoiceID>
   <CustomerName>Jane Smith</CustomerName>
   <LineItems>
      <LineItem>
         <Sku>134</Sku>
         <Quantity>10</Quantity>
         <Description>Chicken Patties</Description>
         <UnitPrice>9.95</UnitPrice>
      </LineItem>
      <LineItem>
         <Sku>153</Sku>
         <Quantity>5</Quantity>
         <Description>Vanilla Ice Cream</Description>
         <UnitPrice>1.50</UnitPrice>
      </LineItem>
   </LineItems>
</Invoice>'

SET @x.modify(
  'insert <InvoiceInfo><InvoiceDate>2002-06-15</InvoiceDate><InvoicePriority>3</InvoicePriority></InvoiceInfo>
  after  /Invoice[1]/CustomerName[1] ')



SET @x.modify('insert attribute status{"backorder"}
  into /Invoice[1] ')
  


-- this deletes all LineItem elements
SET @x.modify('delete /Invoice/LineItems/LineItem')



SET @x.modify('replace value of
  /Invoice[1]/CustomerName[1]/text()[1]
  with "John Smith" ')
  
 SELECT @x   

