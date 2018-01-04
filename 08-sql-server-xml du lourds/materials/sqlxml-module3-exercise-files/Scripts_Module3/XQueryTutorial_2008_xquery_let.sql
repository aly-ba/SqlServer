/*============================================================================
  File:     xquery_let.sql

  Summary:  This script illustrates SQL Server 2008 support for the XQuery
			FLWOR expression "let" keyword.

  Date:     August 2008

  SQL Server Version: 10.0.1600.22 (RTM)
------------------------------------------------------------------------------
  Written by Bob Beauchemin, SQLskills.com

  For more scripts and sample code, check out http://www.SQLskills.com

  This script is intended only as a supplement to SQL Server Jumpstart program.
  
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
============================================================================*/


-- SQL Server 2008 adds support for the 'let' clause in FLWOR expressions. 
-- The for and let clauses have a similar purpose, to bind content (tuples) to variables. 
-- Either one can begin a FLWOR expression:

declare @x xml = '';
select @x.query('
for $i in (1,2,3)
return $i
');
go
-- returns 1 2 3

declare @x xml = '';
select @x.query('
let $i := (1,2,3)
return $i
');
go
-- returns 1 2 3

-- The distinction is that let is an assignment clause, in the simple statement 
-- using 'let' above, $i refers to the entire sequence (1,2,3). 
-- The for clause sets up an iterator. The simple statement above using 'for' loops 3 times 
-- and each time through the loop $i refers to a single member of the sequence. 
-- So, if I add an 'order by' clause, the results are quite different. 

declare @x xml = '';
select @x.query('
for $i in (1,2,3)
order by $i descending
return $i
');
go
-- returns 3 2 1

declare @x xml = '';
select @x.query('
let $i := (1,2,3)
order by $i descending
return $i
');
go
-- error:
-- XQuery [query()]: 'order by' requires a singleton (or empty sequence), found operand of type 'xs:integer +'

-- One limitation on the XQuery let clause is that it does not support constructed elements. 
-- So this statement works fine:

declare @x xml = '';
select @x.query('
let $x := 1
return $x
');
go
-- returns 1

-- but this statement does not:

declare @x xml = '';
select @x.query('
let $x := ( <foo>2</foo>, <bar>2</bar> )
return $x
');
go
-- error:
-- XQuery [query()]: 'let' is not supported with constructed XML

-- When 'let' is used inside a loop, it's evaluated each time around the loop:

declare @x xml = '';
select @x.query('
for $i in (1,2,3)
let $j := 42
return ($i, $j)
');
-- returns 1 42 2 42 3 42
-- $j is evaluated three times

 
 