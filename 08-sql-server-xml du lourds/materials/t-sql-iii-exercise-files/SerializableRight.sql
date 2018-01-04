use tsql3
set transaction isolation level serializable

begin tran
declare @value int
select value from number
commit tran
