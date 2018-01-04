
/*
Converting from Base64 to varbinary and vice versa
Converting Base64 values to varbinary and vice versa is now easier using the XQuery functionality available from SQL Server 2005 onwards. The code samples below show how to perform the conversion:
*/

-- Convert Base64 value in a variable to varbinary:
declare @str varchar(20);
set @str = '3qAAAA==';
select cast(N'' as xml).value('xs:base64Binary(sql:variable("@str"))', 'varbinary(20)');
go

-- Convert binary value in a variable to Base64:
declare @bin varbinary(20);
set @bin = 0xDEA00000;
select cast(N'' as xml).value('xs:base64Binary(xs:hexBinary(sql:variable("@bin")))', 'varchar(20)');
go

-- Convert varbinary value in a column to Base64:
select top (10) cast(N'' as xml).value('xs:base64Binary(xs:hexBinary(sql:column("qs.sql_handle")))', 'varchar(512)') as sql_handle_base64
into #t
from sys.dm_exec_query_stats as qs;
go

-- Convert Base64 value in a column to varbinary:
select cast(N'' as xml).value('xs:base64Binary(sql:column("t.sql_handle_base64"))', 'varbinary(20)') as sql_handle
from #t as t;
drop table #t;
 go
