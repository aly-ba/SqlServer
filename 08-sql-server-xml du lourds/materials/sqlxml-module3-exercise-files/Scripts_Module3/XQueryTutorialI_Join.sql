/*============================================================================
  File:     XQueryTutorialI_Join.sql

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


-- Operators
-- existential, positional, and value comparison
-- comma is the concatenation operator
-- union operator is | (SQL XQuery does not support union)

create table teamprojects (thexml xml)
go

insert teamprojects values('<?xml version="1.0"?>
<Team name="Project 42" xmlns:a="urn:annotations">
  <Employee id="E6" years="4.3">
    <Name>Chaz Hoover</Name>
    <Title>Architect</Title>
    <Expertise>Puzzles</Expertise>
    <Expertise>Games</Expertise>
    <Employee id="E2" years="6.1" a:assigned-to="Jade Studios">
      <Name>Carl Yates</Name>
      <Title>Dev Lead</Title>
      <Expertise>Video Games</Expertise>
      <Employee id="E4" years="1.2" a:assigned-to="PVR">
        <Name>Panda Serai</Name>
        <Title>Developer</Title>
        <Expertise>Hardware</Expertise>
        <Expertise>Entertainment</Expertise>
      </Employee>
      <Employee id="E5" years="0.6">
        <?Follow-up?>
        <Name>Jason Abedora</Name>
        <Title>Developer</Title>
        <Expertise>Puzzles</Expertise>
      </Employee>
    </Employee>
    <Employee id="E1" years="8.2">
      <Name>Kandy Konrad</Name>
      <Title>QA Lead</Title>
      <Expertise>Movies</Expertise>
      <Expertise>Sports</Expertise>
      <Employee id="E0" years="8.5" a:status="on leave">
        <Name>Wanda Wilson</Name>
        <Title>QA Engineer</Title>
        <Expertise>Home Theater</Expertise>
        <Expertise>Board Games</Expertise>
        <Expertise>Puzzles</Expertise>
      </Employee>
    </Employee>
    <Employee id="E3" years="2.8">
      <Name>Jim Barry</Name>
      <Title>QA Engineer</Title>
      <Expertise>Video Games</Expertise>
    </Employee>
  </Employee>
</Team>
<Projects>
  <Project id="X1" owner="E2">
    <Name>Enter the Tuple Space</Name>
    <Category>Video Games</Category>
  </Project>
  <Project id="X2" owner="E1">
    <Name>Cryptic Code</Name>
    <Category>Puzzles</Category>
  </Project>
  <Project id="X3" owner="E5">
    <Name>XQuery Bandit</Name>
    <Category>Video Games</Category>
  </Project>
  <Project id="X4" owner="E3">
    <Name>Micropoly</Name>
    <Category>Board Games</Category>
  </Project>
</Projects>')

-- SQL Server XQuery does not support position (at construct) in FOR
-- or sequences with the "to" construct

select thexml.query('
for $i at $pos in reverse (1 to 10)
let $j := $i * $i
where $j <= 50
order by $i
return ($pos, $i)
') from teamprojects

-- join with two FLWORs
-- cross product
select thexml.query('
for $x in ("a", "b")
for $y in (1,2,3,4)
return ($x, $y)
') from teamprojects

-- nested FLWOR
select thexml.query('
for $i in (7,9)
 return 
   for $j in (1,2,3)
   return $i + $j
') from teamprojects

-- Quantification
select thexml.query('
some $emp in //Employee satisfies $emp/@years > 5
') from teamprojects

-- Quantification
select thexml.query('
every $emp in //Employee satisfies $emp/@years > 5
') from teamprojects

-- Quantification
select thexml.query('
every $i in (1,2), $j in (1,3) satisfies $i = $j
') from teamprojects

-- inner join with two FLWORs
select thexml.query('
for $x in (1,2,3)
for $y in (3,4,5)
where $x = $y
return ($x, $y)
') from teamprojects

-- inner join
-- Projects with the assigned employees 
select thexml.query('
for $proj in /Projects/Project
for $emp in //Employee
where $proj/@owner = $emp/@id
return ($proj/Name, $emp/Name)
') from teamprojects

-- inner join
-- Projects with the assigned employees
-- nicer format using construction
select thexml.query('
for $proj in /Projects/Project
for $emp in //Employee
where $proj/@owner = $emp/@id
return <Assignment>{ $proj/Name, $emp/Name }</Assignment>
') from teamprojects

-- inner join
-- Projects with the assigned employees
-- different constructed XML
select thexml.query('
for $proj in /Projects/Project
for $emp in //Employee
where $proj/@owner = $emp/@id
return <Assignment proj="{$proj/Name}" emp="{$emp/Name}"></Assignment>
') from teamprojects

-- many-to-many join
-- projects and employees 
-- join is by area of expertise 
--
select thexml.query('
for $proj in /Projects/Project
for $emp in //Employee
where $proj/Category = $emp/Expertise
return <Assignment proj="{$proj/Name}" emp="{$emp/Name}"></Assignment>
') from teamprojects

-- many-to-many join
-- projects and employees 
-- join is by area of expertise 
-- nicer format
select thexml.query('
for $proj in /Projects/Project
return 
<Assignment proj="{$proj/Name}">
{
for $emp in //Employee
where $proj/Category = $emp/Expertise
return $emp/Name
}
</Assignment>
') from teamprojects

-- self-join
-- Employees with the same Title as Employee with id "E0"
--
select thexml.query('
//Employee[Title = //Employee[@id="E0"]/Title]/Name
') from teamprojects

-- same self-join with FLWOR
select thexml.query('
for $i in //Employee, $j in //Employee
where ($i/Title = $j/Title) and $j/@id = "E0"
return $i/Name
') from teamprojects