use tsql3
set transaction isolation level serializable

begin tran
declare @value int
select @value = value from number
set @value = @value + 1
update number set value = @value
commit tran
