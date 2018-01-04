select * from sys.plan_guides

select * from sys.plan_guides

select * from sys.plan_guides

dbcc freeproccache;

select * from SalesLT.SalesOrderDetail;
select * from SalesLT.Product;

select * from PlanCache;

sp_control_plan_guide
@operation=  N'disable',
@name = N'FAST9'

sp_control_plan_guide
@operation =  N'enable',
@name = N'FAST9'

exec sp_create_plan_guide
@name =N'FAST5',
@stmt = N'select * from SalesLT.SalesOrderDetail',
@type = N'SQL',
@module_or_batch = N'select * from SalesLT.SalesOrderDetail;
select * from SalesLT.Product;',
@params=null,
@hints = 'OPTION (FAST 5)';


sp_control_plan_guide
@operation = N'disable',
@name = N'FAST9'

sp_control_plan_guide
@operation = N'disable all'

sp_control_plan_guide
@operation = N'drop all'





























































































































































































