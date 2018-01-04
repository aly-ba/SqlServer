
-- Use actions: tsql_stack
-- Note: this produces a stack of sql_handles which must be 
-- resolved by using sys.dm_exec_sql_text(handle)

create event session getsqlstack on server
add event sqlserver.error_reported
(
action 
(
sqlserver.session_id,  -- add spid 
sqlserver.sql_text,     -- add query text
sqlserver.tsql_stack
)
where error = 547
and package0.counter <= 5  -- only capture first 5 errors
)
add target package0.ring_buffer
go

alter event session getsqlstack on server state = start;
go

-- cause the error

use pubs
go

drop procedure proca
drop procedure procb
drop procedure procc
go

create proc proca
as
exec procb
go

create proc procb
as
exec procc
go

create proc procc
as
delete jobs
go

exec proca
go

-- events captured for my session
select CAST(xet.target_data as xml) from sys.dm_xe_session_targets xet
join sys.dm_xe_sessions xe
on (xe.address = xet.event_session_address)
where xe.name = 'getsqlstack'
go

-- reformat - step 1 - get all the nodes that contain the event - print the error number 
SELECT
	Data2.Results.value ('(data/.)[1]', 'int') AS ErrorNumber
from
(
select CAST(xet.target_data as xml) as data
from sys.dm_xe_session_targets xet
join sys.dm_xe_sessions xe
on xe.address = xet.event_session_address
where xe.name = 'getsqlstack'
) events
cross apply Data.nodes ('//RingBufferTarget/event') 
  AS Data2 (Results)
  
-- reformat - step 2 - get all the frame elements as XML
SELECT
	Data2.Results.value ('(data/.)[1]', 'int') AS ErrorNumber,
	Data3.Results.query ('.') AS Stacks  -- this won't work
	Cast(Data3.Results.value ('.', 'nvarchar(MAX)') as XML) AS Stacks  -- this will
from
(
select CAST(xet.target_data as xml) as data
from sys.dm_xe_session_targets xet
join sys.dm_xe_sessions xe
on xe.address = xet.event_session_address
where xe.name = 'getsqlstack'
) events
cross apply Data.nodes ('//RingBufferTarget/event') 
  AS Data2 (Results)
cross apply Data2.Results.nodes('(action[@name="tsql_stack"]/value)[1]')
  AS Data3 (Results)
  

-- reformat the data
SELECT ErrorNumber, Level, text 
FROM
(
SELECT ErrorNumber, 
       Data4.Results.value('@level', 'int') as Level,
       convert(varbinary(64),Data4.Results.value('@handle', 'nvarchar(max)'),1) as SQLHandle
FROM
(
SELECT
	Data2.Results.value ('(data/.)[1]', 'int') AS ErrorNumber,
	Cast(Data3.Results.value ('.', 'nvarchar(MAX)') as XML) AS Stacks
from
(
select CAST(xet.target_data as xml) as data
from sys.dm_xe_session_targets xet
join sys.dm_xe_sessions xe
on (xe.address = xet.event_session_address)
where xe.name = 'getsqlstack'
) events
cross apply Data.nodes ('//RingBufferTarget/event') 
  AS Data2 (Results)
cross apply Data2.Results.nodes('(action[@name="tsql_stack"]/value)[1]')
  AS Data3 (Results)
) as a
cross apply a.Stacks.nodes('/frame') as Data4 (Results)
) as b
cross apply sys.dm_exec_sql_text(sqlhandle) sql

-- stop session. note:this loses the collected data
alter event session getsqlstack on server state = stop;
go

drop event session getsqlstack on server;