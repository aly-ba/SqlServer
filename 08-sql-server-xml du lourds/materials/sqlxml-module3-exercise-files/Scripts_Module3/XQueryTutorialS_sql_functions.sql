/*============================================================================
  File:     XQueryTutorialS_sql_functions.sql

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


CREATE TABLE xml_tab (
  id int identity primary key,
  xml_col xml)
GO

INSERT xml_tab VALUES('<person name="moe"/>')
INSERT xml_tab VALUES('<person name="curly"/>')
INSERT xml_tab VALUES('<person name="larry"/>')
INSERT xml_tab VALUES('<person name="fred"/><person name="ethel"/>')
GO


-- returns <li>moe in record number x</li> 
-- where x is the ID column, or blank column
SELECT xml_col.query('
   for $b in //person 
   where  $b/@name="moe"
   return <li>{ data($b/@name) } in record number {sql:column("xml_tab.id")}</li>
 ') 
FROM xml_tab


-- returns <li>moe is a stooge</li> 
DECLARE @occupation VARCHAR(50)
SET @occupation = ' is a stooge'
SELECT xml_col.query('
   for $b in //person 
   where  $b/@name="moe"
   return <li>{data($b/@name)}
{sql:variable("@occupation") }</li>
 ') 
FROM xml_tab
GO

-- 
-- ordinary answer using SELECT
-- 
SELECT xml_col.query('/person') FROM xml_tab

--
-- combined answer using FOR XML
--
declare @x XML
set @x = (SELECT * FROM xml_tab FOR XML AUTO, ELEMENTS)
SELECT @x.query('/xml_tab/xml_col/person')

-- decomposition using nodes
SELECT tab.col.query('data(@name)')
FROM xml_tab
CROSS APPLY
xml_col.nodes('/person') as tab(col)



