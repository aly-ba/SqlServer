/*============================================================================
  File:     XQueryTutorialS_modify.sql

  Date:     Nov 2005

  SQL Server Version: 9.0.1399 - RTM
------------------------------------------------------------------------------
  Copyright (C) 2005 Bob Beauchemin, SQLskills, Inc.
  All rights reserved.

  For more scripts and sample code, check out 
    http://www.SQLskills.com

  This script is intended only as a supplement to demos and lectures
  given by Bob Beauchemin.  
  
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
============================================================================*/



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


-- use modify to insert a subelement
SET @x.modify(
  'insert <InvoiceDate>2002-06-15</InvoiceDate>
  into /Invoice[1] ')

SELECT @x 

-- or insert an attribute
SET @x.modify('insert attribute status{"backorder"}
  into /Invoice[1] ')

SELECT @x

-- this deletes all LineItem elements
SET @x.modify('delete /Invoice/LineItems/LineItem')

SELECT @x

-- change the value of the CustomerName element
SET @x.modify('replace value of
  /Invoice[1]/CustomerName[1]/text()[1]
  with "Fred Anderson" ')

SELECT @x
