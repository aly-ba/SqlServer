exec sp_control_plan_guide @operation='drop all';

create proc AllCustProd
as
select * from SalesLT.Customer;
select * from SalesLT.Product;


dbcc freeproccache;


exec AllCustProd;


select * from PlanCache;


exec sp_create_plan_guide
@name =N'FAST9Proc',
@stmt = N'select * from SalesLT.Customer',
@type = N'OBJECT',
@module_or_batch = N'AllCustProd',
@params=null,
@hints = 'OPTION (FAST 9)';


dbcc freeproccache;

exec AllCustProd;


select * from PlanCache;







































































































































