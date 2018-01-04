/*============================================================================
  File:     XQueryTutorialC_Seq.sql

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


-- sequences 

declare @x xml
set @x = ''
select @x.query(
'
 1,2 
'
)

/* must return all nodes or all atomic values */
/* <root/> is not an XML data type, but a string? */

declare @x xml
set @x = ''
select @x.query(
'
 (: 1,2 :) 
 (: 1,"Astring"  :)
 (: 1, "<root/>" :)
 (: 1, "&lt;root/&gt;" :)
 
 (: this doesn''t work :)
 (: Msg 2214, Level 16, State 1, Line 10
    XQuery [query()]: The type ''element'' is not an atomic type :)
   xs:element("root") 
'
)

-- literal node construction
declare @x xml
set @x = ''
select @x.query(
'
 (: this gets "heterogeneous sequences are not allowed" :)
 1, <root/> 
'
)

-- sequences are linear
-- this returns in a single linear sequence

declare @x xml
set @x = ''
select @x.query(
'
for $x in (1,2,3)
for $y in (4,5)
return ($x, $y)
'
)
