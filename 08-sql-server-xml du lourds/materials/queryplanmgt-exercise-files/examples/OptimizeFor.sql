dbcc freeproccache

create procedure GreaterProducts(@id int)
as
select * from SalesLT.Product where ProductID>@id
OPTION (OPTIMIZE FOR (@id = 9));

 
 exec GreaterProducts 4;
 
 select * from PlanCache;
 
exec sp_create_plan_guide
@name =N'P9',
@stmt = N'select * from SalesLT.Product where ProductID>@id',
@type = N'OBJECT',
@module_or_batch = N'GreaterProducts',
@params=null,
@hints = 'OPTION (OPTIMIZE FOR (@id = 9))';
 
 
  
 
  
  
 
 
 
 
  
 