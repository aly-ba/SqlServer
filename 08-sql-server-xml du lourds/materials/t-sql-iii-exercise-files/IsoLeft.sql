use snapshot_demo

set transaction isolation level
read committed

create table sample
(
time float,
temp float
)

insert sample values (1.1, 45.0)

begin tran
update sample set time = 1.2
update sample set temp = 73
commit tran
