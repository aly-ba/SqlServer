/*============================================================================
  File:     XQueryTutorialS_node_tests.sql

  Date:     Nov 2005

  SQL Server Version: 9.0.1399 - RTM
------------------------------------------------------------------------------
  Copyright (C) 2005 Bob Beauchemin, SQLskills, Inc.
  All rights reserved.

  Original query example from:
    XQuery: The XML Query Language - Michael Brundage ISBN 0321165810 

  For more scripts and sample code, check out 
    http://www.SQLskills.com

  This script is intended only as a supplement to demos and lectures
  given by Bob Beauchemin.  
  
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
============================================================================*/


-- Msg 9335, Level 16, State 1, Line 3
-- XQuery [query()]: The XQuery syntax '/function()' is not supported.
declare @x xml
set @x = '<e a1="foo" b1="bar"/>'
select @x.query('//*/attribute()')
go

-- this works
declare @x xml
set @x = '<e a1="foo" b1="bar"/>'
select @x.query('data(//*/@*)')
go

-- this doesn't 
declare @x xml
set @x = '<e a1="foo" b1="bar"/>'
select @x.query('//*/element()')
go

-- this works
declare @x xml
set @x = '<e a1="foo" b1="bar"/>'
select @x.query('//*/node()')

-- no reverse function
declare @x xml
set @x = '<e a1="foo" b1="bar"/>'
select @x.query('reverse(1,2,3)')
go

-- no such function
declare @x xml
set @x = '<e a1="foo" b1="bar"/>'
select @x.query('dayTimeDuration("PT5H")')
go

-- these work
declare @x xml
set @x = '<e a1="foo" b1="bar"/><e a1="foo" b2="bar"/>'
select @x.query('
for $a in //e
where some $part in //e satisfies $part/@b1
return <itdoes/>
')
go

declare @x xml
set @x = '<e a1="foo" b1="bar"/>'
select @x.query('some $part in //e satisfies $part/@b1')
go

-- instance of works
declare @x xml
set @x = '<e a1="foo" b1="bar"/>'
select @x.query('5 instance of xs:integer')
-- needs singleton
select @x.query('/e[1] instance of element()')
go

-- no typeswitch
declare @x xml
set @x = '<e a1="foo" b1="bar"/>'
select @x.query('
typeswitch($customer/billing-address)
   case $a as element(*, USAddress) return $a/state
   case $a as element(*, CanadaAddress) return $a/province
   case $a as element(*, JapanAddress) return $a/prefecture
   default return "unknown"
')
go

-- no castable as
declare @x xml
set @x = '<e a1="foo" b1="bar"/>'
select @x.query('
for $x in (1,2,3)
return
if ($x castable as hatsize) 
   then $x cast as hatsize 
   else if ($x castable as IQ) 
   then $x cast as IQ 
   else $x cast as xs:string
')
go

-- no "cast as" without type?
declare @x xml
set @x = '<e a1="foo" b1="bar"/>'
select @x.query('
for $x in (1,2,3)
return
(: hatsize is not an atomic type :)
(: $x cast as hatsize :)
$x cast as xs:decimal?
')
go

declare @x xml
set @x = '<e a1="foo" b1="bar"/>'
select @x.query('
for $x in (1,2,3)
return
xs:dateTime("2005-10-10T12:00:00Z"),
(: invalid simple type value: xs:date("2005-10-10") :)
')
go

