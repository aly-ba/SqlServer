use tempdb
go

-- drop table if it already exists
drop table xmlinvoice
go

-- drop schema if it already exists
drop xml schema collection invoice_xsd 
go

CREATE XML SCHEMA COLLECTION invoice_xsd
AS 
N'
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema"
     	    xmlns:tns="urn:www-pluralsight-com:invoices"
            targetNamespace="urn:www-pluralsight-com:invoices"
            elementFormDefault="qualified">

  <!-- named typedefs and element decls -->
  <xsd:simpleType name="skuType">
    <xsd:restriction base="xsd:integer" >
      <xsd:minInclusive value="100" />
      <xsd:maxInclusive value="999" />
    </xsd:restriction>
  </xsd:simpleType>

  <xsd:complexType name="LineItem">
    <xsd:sequence>
      <xsd:element name="Sku" type="tns:skuType"/>
      <xsd:element name="Description" type="xsd:string"/>
      <xsd:element name="Price" type="xsd:double"/>
    </xsd:sequence>
  </xsd:complexType>
  
  <xsd:complexType name="LineItems">
    <xsd:sequence>
      <xsd:element name="LineItem" type="tns:LineItem" maxOccurs="unbounded"/>
    </xsd:sequence>
  </xsd:complexType>

  <xsd:complexType name="Invoice">
    <xsd:sequence>
      <xsd:element name="InvoiceID" type="xsd:string"/>
      <xsd:element name="CustomerName" type="xsd:string"/>
      <xsd:element name="LineItems" type="tns:LineItems"/>
    </xsd:sequence>
  </xsd:complexType>  

  <xsd:element name="Invoice" type="tns:Invoice"/>

</xsd:schema>'
go

-- table with a strongly typed column
-- type this by schema namespace
-- and an additional constraint
-- (big orders with more than 3 LineItems go into a different table)
create function bigorder(@data xml)
returns bit
as
begin
return @data.exist('declare namespace inv="urn:www-pluralsight-com:invoices";
                          //inv:Invoice/inv:LineItems/inv:LineItem[4]')
end


create table xmlinvoice(
 id integer identity primary key,
 invoice xml (invoice_xsd)
  check(dbo.bigorder(invoice)=0)
)

insert into xmlinvoice values('
<inv:Invoice xmlns:inv="urn:www-pluralsight-com:invoices" >
   <inv:InvoiceID>1000</inv:InvoiceID>
   <inv:CustomerName>Jane Smith</inv:CustomerName>
   <inv:LineItems>
      <inv:LineItem>
         <inv:Sku>134</inv:Sku>
         <inv:Description>Dons Boxers</inv:Description>
         <inv:Price>9.95</inv:Price>
      </inv:LineItem>
   </inv:LineItems>
</inv:Invoice>
')
go

insert into xmlinvoice values('
<inv:Invoice xmlns:inv="urn:www-pluralsight-com:invoices" >
   <inv:InvoiceID>1001</inv:InvoiceID>
   <inv:CustomerName>John Jones</inv:CustomerName>
   <inv:LineItems>
      <inv:LineItem>
         <inv:Sku>134</inv:Sku>
         <inv:Description>Dons Boxers</inv:Description>
         <inv:Price>9.95</inv:Price>
      </inv:LineItem>
      <inv:LineItem>
         <inv:Sku>217</inv:Sku>
         <inv:Description>COM is Love Teeshirt</inv:Description>
         <inv:Price>14.95</inv:Price>
      </inv:LineItem>
   </inv:LineItems>
</inv:Invoice>
')
go

insert into xmlinvoice values('
<inv:Invoice xmlns:inv="urn:www-pluralsight-com:invoices" >
   <inv:InvoiceID>1002</inv:InvoiceID>
   <inv:CustomerName>Mary McCoy</inv:CustomerName>
   <inv:LineItems>
      <inv:LineItem>
         <inv:Sku>217</inv:Sku>
         <inv:Description>COM is Love Teeshirt</inv:Description>
         <inv:Price>14.95</inv:Price>
      </inv:LineItem>
      <inv:LineItem>
         <inv:Sku>202</inv:Sku>
         <inv:Description>Essential Yukon Book</inv:Description>
         <inv:Price>39.95</inv:Price>
      </inv:LineItem>
   </inv:LineItems>
</inv:Invoice>
')
go

-- more than 3 LineItems, fails
insert into xmlinvoice values('
<inv:Invoice xmlns:inv="urn:www-pluralsight-com:invoices" >
   <inv:InvoiceID>1001</inv:InvoiceID>
   <inv:CustomerName>John Jones</inv:CustomerName>
   <inv:LineItems>
      <inv:LineItem>
         <inv:Sku>217</inv:Sku>
         <inv:Description>COM is Love Teeshirt</inv:Description>
         <inv:Price>14.95</inv:Price>
      </inv:LineItem>
      <inv:LineItem>
         <inv:Sku>202</inv:Sku>
         <inv:Description>Essential Yukon Book</inv:Description>
         <inv:Price>39.95</inv:Price>
      </inv:LineItem>
      <inv:LineItem>
         <inv:Sku>219</inv:Sku>
         <inv:Description>Grey Teeshirt</inv:Description>
         <inv:Price>14.95</inv:Price>
      </inv:LineItem>
      <inv:LineItem>
         <inv:Sku>198</inv:Sku>
         <inv:Description>Essential ADO.NET Book</inv:Description>
         <inv:Price>49.95</inv:Price>
      </inv:LineItem>
   </inv:LineItems>
</inv:Invoice>
')
go