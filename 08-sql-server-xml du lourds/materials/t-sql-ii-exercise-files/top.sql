use tsql1;

create table #items
(
id int primary key identity,
data varchar(20),
size int
);

declare @index int
set @index = 10000
while @index > 0
begin
set @index = @index -1
insert into #items values ('item' + cast(@index as varchar(10)), @index % 10);
end

select * from #items

select top 4 * from #items order by size

select top (4) * from #items order by size

declare @limit as int;
set @limit = 6
select top (@limit) * from #items order by size 

declare @limit as int;
set @limit = 4
select top (@limit) with ties * from #items order by size desc

select top (select size from #items where id = 3) * from #items order by size desc


set rowcount 4

update #items set size = size + 1000
where size < 1000

set rowcount 0

update top (4) #items set size = size + 1000
where size < 1000


declare @limit int
set @limit = 4
again:
update top(@limit) #items set size = size + 1000
where size < 1000
if @@rowcount != 0 goto again




