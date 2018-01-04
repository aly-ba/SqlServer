/*============================================================================
  File:     XQueryTutorialD_Prolog.sql

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


/* 
 every XQuery consists of prolog and body 
 in SQL2005 only namespace declarations are supported in prolog
 you cannot declare default attribute namespace

 there is no support for modules and functions
 there are two built-in UDFs sql:column and sql:variable

 you have a little support for variables by using sql:variable
*/

DECLARE @x XML
SET @x = '
<p:people xmlns:p="http://www.people.com">
 <p:person name="bob"/>
 <p:person name="mary"/>
</p:people>
'
SELECT @x.query('/people/person')
GO


DECLARE @x XML
SET @x = '
<p:people xmlns:p="http://www.people.com">
 <p:person name="bob"/>
 <p:person name="mary"/>
</p:people>
'
SELECT @x.query('/p:people/p:person')
GO

-- use namespace bindings to bind namespace prefixes to namespace
-- two ways to do this
DECLARE @x XML
SET @x = '
<p:people xmlns:p="http://www.people.com">
 <p:person name="bob"/>
 <p:person name="mary"/>
</p:people>
'
SELECT @x.query('
declare default element namespace "http://www.people.com";
/people/person')
GO

-- or
DECLARE @x XML
SET @x = '
<p:people xmlns:p="http://www.people.com">
 <p:person name="bob"/>
 <p:person name="mary"/>
</p:people>
'
SELECT @x.query('
declare namespace aa = "http://www.people.com";
/aa:people/aa:person')
GO

-- you can also use WITH XMLNAMESPACES
DECLARE @x XML
SET @x = '
<p:people xmlns:p="http://www.people.com">
 <p:person name="bob"/>
 <p:person name="mary"/>
</p:people>
';
WITH XMLNAMESPACES(DEFAULT 'http://www.people.com')
SELECT @x.query('
/people/person')
GO

-- or
DECLARE @x XML
SET @x = '
<p:people xmlns:p="http://www.people.com">
 <p:person name="bob"/>
 <p:person name="mary"/>
</p:people>
';
WITH XMLNAMESPACES('http://www.people.com' AS aa)
SELECT @x.query('
/aa:people/aa:person')
GO