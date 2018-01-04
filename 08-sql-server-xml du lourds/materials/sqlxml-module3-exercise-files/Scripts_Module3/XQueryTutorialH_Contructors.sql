/*============================================================================
  File:     XQueryTutorialH_Constructors.sql

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


-- constructors 
-- XQuery supports constructors for each node type

-- Msg 9315, Level 16, State 1, Line 12
-- XQuery [query()]: Only constant expressions are supported for the 
-- name expression of computed element and attribute constructors.
declare @x xml
set @x = ''
select @x.query('
(: <x/>            literal :)
(: <a>{1+1}</a>    within the tags is an XQuery expression :)
(: <a>{{1+1}}</a>  escape the curly brace by doubling it :)
(: element x {1+1} computed constructor :)
element { concat("x", ":y")} {1+1}
')

-- attribute constructor
declare @x xml
set @x = ''
select @x.query('
(: curly braces go inside the quotes :)
(: <x a="{1+2}" b="{{1+2}}" /> :)
(: no quotes needed for computed attribute constructors :)
<x>{ attribute a {1+2} }</x>
')

-- text nodes
declare @x xml
set @x = ''
select @x.query('
(: element content :)
{: <x>123</x> :)
(: text node constructor - not like this :)
{: {42} :)
(: no, "an expression was expected" :)
<x><![CDATA[Escape special characters < ]]></x>
')

-- document constructor not supported

declare @x xml
set @x = ''
select @x.query('
(: computed comment or PI constructor not supported :)
(: comment { "this is a comment" } :)
(: processing-instruction { "hello" } { "world" } :)
(: literal comment OK :)
(: these two work individually but not together :)
<?hello world?>
(: <!-- an xml comment --!> :)
')

declare @x xml
set @x = ''
select @x.query('
(: no namspace constructor :)
<x>{ namespace foo { "bar" } }</x>
')

-- Msg 2224, Level 16, State 1, Line 4
-- XQuery [query()]: An expression was expected
declare @x xml
set @x = ''
select @x.query('
{<x><y><z/></y></x>}//z
')

-- when c is added
-- Msg 9313, Level 16, State 1, Line 4
-- XQuery [query()]: This version of the server does not support 
-- multiple expressions or expressions mixed with strings 
-- in an attribute constructor.
declare @x xml
set @x = ''
select @x.query('
<x a="12&apos;" b="{1,2}" />
(: <x a="12&apos;" b="{1,2}" c="12{3, 4}56" /> :)
(: <x a="12&apos;" b="{1,2}" d="1{2+3}4" /> :)
')