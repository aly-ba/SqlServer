set transaction isolation level read committed

sp_help number


update dbo.number set value= 2013


begin tran
update dbo.number set value = value + 1
commit tran

 
select * from dbo.number

 
select * from 
sys.dm_tran_active_snapshot_database_transactions











