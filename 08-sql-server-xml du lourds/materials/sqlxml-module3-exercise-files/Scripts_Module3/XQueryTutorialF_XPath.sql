/*============================================================================
  File:     XQueryTutorialF_XPath.sql

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



-- navigation paths

/* XPath defines 13 axes, no namespace axis in XQuery at all
   SQL Server XQuery supports 6 axes
     child, descendant, parent, attribute, self, descendant-or-self
     preceding, preceding-sibling, following, following-sibling not needed 
        because of << and >> 
     no ancestor, ancestor-or-self, namespace

Multiple predicates on the same evaluation step is supported.
pos() and last() are only supported in predicates
 
*/

create table team (thexml xml)
go

insert team values('<?xml version="1.0"?>
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
</Team>')

-- these two are identical 
-- child axis is default
select thexml.query('/Team/Employee/Name') from team

select thexml.query('/Team/Employee/child::Name') from team

-- // is alias for descendent-or-self::node()
select thexml.query('//Employee/Name') from team

-- names of all employees 
-- with an urn:annotations:assigned-to attribute
select thexml.query('
declare namespace ann = "urn:annotations";
//Employee[@ann:assigned-to]/Name') from team

-- uses explicit attribute axis
select thexml.query('
declare namespace ann = "urn:annotations";
//Employee[attribute::ann:assigned-to]/Name') from team

-- not operator
select thexml.query('
declare namespace ann = "urn:annotations";
//Employee[not(@ann:assigned-to)]/Name') from team

-- all Employees who report directly to Chaz
-- these two are identical
select thexml.query('
count(//Employee[Name = "Chaz Hoover"]/Employee) ') from team

-- uses shortcut for parent axis (..)
-- NOTE: parent axis BAD for performance in SQL Server 2005
select thexml.query('
count(//Employee[../Name = "Chaz Hoover"]) ') from team