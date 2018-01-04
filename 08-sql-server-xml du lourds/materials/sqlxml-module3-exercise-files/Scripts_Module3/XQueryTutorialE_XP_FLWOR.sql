/*============================================================================
  File:     XQueryTutorialE_XPathFLWOR.sql

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

CREATE TABLE people (thexml xml)
GO

INSERT people VALUES(
'<people>
 <person>
  <name>
   <givenName>Martin</givenName>
   <familyName>Gudgin</familyName>
  </name>
  <age>33</age>
  <height>short</height>
 </person>
 <person>
  <name>
   <givenName>Simon</givenName>
   <familyName>Horrell</familyName>
  </name>
  <age>40</age>
  <height>short</height>
 </person>
 <person>
  <name>
   <givenName>Mark</givenName>
   <familyName>Szolkowski</familyName>
  </name>
  <age>30</age>
  <height>medium</height>
 </person>
</people>
')
GO 3

SELECT thexml.query('
(: this is a valid XQuery :)
/people/person[age > 30]
')
FROM people

SELECT thexml.query('
(: so is this FLWOR expression :)
for $p in /people/person
where $p/age > 30
return $p
')
FROM people
