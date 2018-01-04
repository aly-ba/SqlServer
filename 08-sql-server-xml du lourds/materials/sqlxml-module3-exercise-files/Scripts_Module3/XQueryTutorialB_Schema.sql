/*============================================================================
  File:     XQueryTutorialB_Schema.sql

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


-- use value function, query must return more than one atomic value
--
--CREATE PROCEDURE someproc
--AS
DECLARE @x XML
SET @x = '
<people>
 <person>
  <name>
   <givenName>Martin</givenName>
   <familyName>Gudgin</familyName>
  </name>
  <age>33</age>
  <height>short</height>
 </person>
</people>
'
-- fails no schema to say one age
SELECT @x.value('(/people/person/age)[1]', 'int')

-- create an XML schema collection
-- from a document on file system
create database xmldemo
go

use xmldemo
go

DECLARE @x XML
SET @x = ( 
 SELECT * FROM OPENROWSET
  (BULK 'c:\people.xsd',
   SINGLE_BLOB)
   as X)
CREATE XML SCHEMA COLLECTION people_xsd AS @x

-- XQuery data model extends XML Schema types with some new types
-- If there is no schema, items are type "xdt:untypedAtomic *" by default.
-- The xdt:dayTimeDuration and xdt:yearMonthDuration types are not supported.

-- cardinalities for XQuery operands
-- + = one or more
-- * = zero or more
-- ? = zero or one

-- type variable according to the schema collection
--
DECLARE @x XML(people_xsd)
SET @x = '
<people>
 <person>
  <name>
   <givenName>Martin</givenName>
   <familyName>Gudgin</familyName>
  </name>
  <age>33</age>
  <height>short</height>
 </person>
</people>
'
-- fails can contain fragment of multiple people documents
SELECT @x.value('/people/person[1]/age', 'int')


-- use schema AND enforce single document
--
DECLARE @x XML(DOCUMENT people_xsd)
SET @x = '
<people>
 <person>
  <name>
   <givenName>Martin</givenName>
   <familyName>Gudgin</familyName>
  </name>
  <age>33</age>
  <height>short</height>
 </person>
</people>
'
SELECT @x.value('/people/person[1]/age', 'int')