/*============================================================================
  File:     XQueryTutorialA_IO.sql

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


--
-- doc() vs query()
-- 
for $p in doc("people.xml")/people/person
where $p/age > 30
return $p/name/givenName/text()


-- doc not supported must use 
-- XML column, parameter or variable 
DECLARE @x XML
SET @x = ( 
 SELECT * FROM OPENROWSET
  (BULK 'c:\people.xml',
   SINGLE_BLOB)
   as X)

SELECT @x.query('
for $p in /people/person
where $p/age > 30
return $p/name/givenName/text()
')
GO 