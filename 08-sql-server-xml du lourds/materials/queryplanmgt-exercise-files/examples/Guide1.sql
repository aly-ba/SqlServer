dbcc freeproccache;


select * from SalesLT.SalesOrderDetail;
select * from SalesLT.Product;

select * from PlanCache;

select * from SalesLT.SalesOrderDetail OPTION(FAST 9);
select * from SalesLT.Product;



exec sp_create_plan_guide
@name =N'FAST9',
@stmt = N'select * from SalesLT.SalesOrderDetail',
@type = N'SQL',
@module_or_batch = N'select * from SalesLT.SalesOrderDetail;
select * from SalesLT.Product;',
@params=null,
@hints = 'OPTION (FAST 9)';

exec sp_create_plan_guide
@name =N'NOFAST9',
@stmt = N'select * from SalesLT.SalesOrderDetail OPTION(FAST 9)',
@type = N'SQL',
@module_or_batch = N'select * from SalesLT.SalesOrderDetail OPTION(FAST 9);
select * from SalesLT.Product;',
@params=null,
@hints=null;


select * from sys.plan_guides











































































































































































