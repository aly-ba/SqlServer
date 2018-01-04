/*============================================================================
  File:     XQueryTutorialG_FLWOR.sql

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

CREATE TABLE people2 (thexml xml)
INSERT people2 VALUES(
'<people>
 <person>
  <name>
   <givenName>Martin</givenName>
   <familyName>Gudgin</familyName>
  </name>
  <age>33</age>
  <age type="dog-years">6</age>
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

-- where and order by
select thexml.query(
'
for $p in /people/person
where $p/age < 30
order by $p/age[1]
return $p/name
')
FROM people2
GO

-- this is an error
select thexml.query(
'
for $p in /people/person
where $p/age lt 30
order by $p/age[1]
return $p/name
')
FROM people2
GO

-- static and dynamic constructors
select thexml.query(
'
<root>
{
for $p in /people/person
return  <person>
        {$p/name[1]/givenName[1]/text()}
        </person>
}
</root>        
')
FROM people2

-- adding a root element
select thexml.query(
'
<root>
{
for $p in /people/person
return  <person>
        {$p/name[1]/givenName[1]/text()}
        </person>
}
</root>
')
FROM people2

-- computed constructor
select thexml.query('
for $p in /people/person
return element person
   {
      attribute name   
                {data($p/name[1]/givenName[1]/text()[1])}
   }
')
FROM people2
