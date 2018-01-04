/*============================================================================
  File:     xquery_modify_var.sql

  Summary:  This script illustrates that in SQL Server 2008, XML DML syntax
			is enhanced to support insert into an XML document using the 
			sql:variable XQuery function.

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


declare @x xml = '<doc/>'
declare @y xml = '<foo>bar</foo>'
set @x.modify ('insert sql:variable("@y") into /doc[1]')
select @x