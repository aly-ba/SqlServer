/*============================================================================
  File:     linqxml.sql

  Summary:  This is a test script for the demo project LINQ2XMLLib. The 
			SQLCLR function must be compiled and deployed first for the test
			to work. Use Visual Studio's autodeploy feature after creating the 
			database in this script.

  Date:     August 2008

  SQL Server Version: 10.0.1600.22 (RTM)
------------------------------------------------------------------------------
  Written by Bob Beauchemin, SQLskills.com

  For more scripts and sample code, check out http://www.SQLskills.com
  
  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF 
  ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED 
  TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
  PARTICULAR PURPOSE.
============================================================================*/
sp_configure 'show advanced options',1
reconfigure
go
sp_configure 'clr enable',1
reconfigure
go

IF EXISTS (
  SELECT * FROM sys.databases 
  WHERE name = N'test'
)
  DROP DATABASE test
GO

CREATE DATABASE test
GO

use test
go

create assembly linq2xmllib from 'c:\temp\linq2xmllib.dll'
 with permission_set = safe
go 

create function dbo.makexml()
returns xml
as external name linq2xmllib.[LINQ2XMLlib.Class1].MakeXML

select dbo.makexml();
go

select * from sys.assemblies
go