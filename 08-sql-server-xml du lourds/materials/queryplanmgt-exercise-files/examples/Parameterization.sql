select Databasepropertyex ('adventureworkslt2008', 'IsParameterizationForced');

dbcc freeproccache;

select * from PlanCache;


select * from SalesLT.Product  where ProductID=4;

select * from SalesLT.Product where ProductID=5;

select count(*) from SalesLT.Product where ProductID > 5

alter database adventureworkslt2008 set parameterization forced



alter database adventureworkslt2008 set parameterization simple;


select * from PlanCache;

sp_executesql N'select count(*) from SalesLT.Product where ProductID > @pid', N'@pid int', 7;


declare @stmt nvarchar(max), @params nvarchar(max);


declare @stmt nvarchar(max), @params nvarchar(max);
exec sp_get_query_template N'select count(*) from SalesLT.Product where ProductID > 5',
@stmt output, @params output
select @stmt, @params


select * from PlanCache



sp_executesql N'select * from SalesLT.Product   where ProductModelID=@pid
OPTION (optimize for (@pid=9))', N'@pid int', 6
 

sp_executesql N'select * from SalesLT.Product  where ProductModelID=@pid
OPTION (optimize for (@pid UNKNOWN))', N'@pid int', 6


sp_configure 'show advanced options', 1;
go
RECONFIGURE
go
sp_configure 'optimize for ad hoc workloads', 0;
go
RECONFIGURE


 select * from SalesLT.Product   where ProductModelID between 1 and -1
 








































































































































































