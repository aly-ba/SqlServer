USE Pubs
GO

-- 1. Produce rowset using OpenXML
declare @idoc int
declare @doc varchar(1000)
set @doc ='<ROOT>
<Customers CustomerID="VINET" ContactName="Paul Henriot">
   <Orders CustomerID="VINET" EmployeeID="5">
      <OrderDetails OrderID="10248" ProductID="11" />
      <OrderDetails OrderID="10248" ProductID="42" />
   </Orders>
</Customers>
<Customers CustomerID="LILAS" ContactName="Carlos Gonzalez">
   <Orders CustomerID="LILAS" EmployeeID="3">
      <OrderDetails OrderID="10283" ProductID="72" 
           Quantity="3"/>
   </Orders>
</Customers>
</ROOT>'

exec sp_xml_preparedocument @idoc OUTPUT, @doc
SELECT    *
FROM OpenXML 
(@idoc, '/ROOT/Customers/Orders/OrderDetails',2)
 WITH (CustomerID  varchar(10) '../@CustomerID',
       ProdID      int         '@ProductID',
       Qty         int         '@Quantity')
exec sp_xml_removedocument @idoc     


-- 2. Decomposition using OpenXML
DECLARE @h int
DECLARE @xmldoc varchar(1000)
 
set @xmldoc = 
'<root>
<stores stor_id="8888" stor_name="Bob''s Books"  
     stor_address="111 Somewhere" city="Portland" 
     state="OR" zip="97225">
<discounts discounttype="A Discount" 
           stor_id="8888" discount="50.00"/> 
</stores> </root>'

EXEC sp_xml_preparedocument @h OUTPUT, @xmldoc

INSERT INTO stores
SELECT * FROM OpenXML(@h,'/root/stores')
WITH stores

INSERT INTO discounts
SELECT * FROM OpenXML(@h,'/root/stores/discounts')
WITH discounts

EXEC sp_xml_removedocument @h                      