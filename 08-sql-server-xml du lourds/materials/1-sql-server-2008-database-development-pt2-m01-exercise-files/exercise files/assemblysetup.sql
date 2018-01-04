use veronicas;
go

CREATE ASSEMBLY SQLDevClrDemo
	FROM 'C:\Windows\Microsoft.NET\Framework\v3.5\sample\CLRStoredProc.dll';
	
SELECT assembly_id, name 
from sys.assemblies
where name = 'SQLDevClrDemo';

go
CREATE procedure sales.sp_CustomerGetClr
@CustomerNumber int
as
external name SQLDevClrDemo."SQL433.Clr.Demo".CustomerGetProcedure;
go

select assembly_id, assembly_class, assembly_method
from sys.assembly_modules
where object_id = object_id('Sales.sp_CustomerGetClr');



exec sp_configure 'clr enabled', 1;
reconfigure;

exec SALES.sp_CustomerGetClr @customerNumber = 17;