alter database tsql3 set allow_snapshot_isolation on

alter database tsql3 
set read_committed_snapshot on


set transaction isolation level snapshot


set transaction isolation level read committed


begin tran
select value from dbo.number
commit tran


begin tran
update dbo.number set value = value + 1
commit tran



