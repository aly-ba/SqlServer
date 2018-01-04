  use snapshot_demo
  
  set transaction isolation level 
  serializable
  
  begin tran
  select time, temp from sample
  commit tran
