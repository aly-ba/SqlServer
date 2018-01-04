select * from lastnames

select name, row_number() over (order by len(name))  from lastnames

create table [mechanical parts]
(name varchar(50) primary key,
price money,
weight int
)

insert into [mechanical parts] values
('X4-gear', 2.98, 34),
('X9-gear', 3.00, 12),
('AY3-arbor', 1.12, 9),
('PR1-pin', 32.99, 18),
('PH9-pin', 12.87, 54),
('K4-shaft', 4.56, 32),
('K6-shaft', 2.15, 78),
('LO-lock', 2.98, 2),
('DT9-drift', 14.30, 34),
('PG1-pin', 33.13, 15);


select name, rank() over (order by weight)
from [mechanical parts]


select name, rank() over (
 partition by substring(name, charindex('-', name)+1, 100)
 order by weight
 )
from [mechanical parts]

 
 
select name,
 rank() over (
 partition by right(name, len(name) - charindex('-', name))
 order by weight
 ) from [mechanical parts]

select right(name, len(name) - charindex('-', name)),
sum(price) over (partition by right(name, len(name) - charindex('-', name)))
from [mechanical parts]

select * from [mechanical parts]
select right(name, len(name) - charindex('-', name)),
sum(price) over (partition by right(name, len(name) - charindex('-', name)))
from [mechanical parts]

/*
 Entity-attribute-value
 
 products, entity table - items in stockroom
 
 properties, attributes-value table
 */
  
 select * from products
 select * from properties
 
 create table shifts
 (
 id int primary key,
 name nvarchar(10),
 premium float,
 [start time] time
 )
 
 insert into shifts
 values (1, 'day', 1.00, '7:30'),
 (2, 'swing', 1.10, '16:30'),
 (3, 'mid', 1.20, '23:30')
 
 select * from shifts
 
 
 create table [plant locations]
 (
 id int primary key,
 name nvarchar(50),
 state nchar(2),
 city nvarchar(50),
 premium float,
 [business sector] nvarchar(70)
 )
 
 alter table [plant locations]
 add

 [business sector] nvarchar(70)
 
 
 drop table employees
 
 create table employees
 (
 [first name] nvarchar(50),
 [last name] nvarchar(50),
 shift int,
 [base rate] money,
 [location] int,
 constraint shift_fk foreign key (shift) references shifts(id),
 constraint location_fk foreign key (location) references [plant locations](id)
 )
  
 select * from employees

select * from [plant locations]
select * from shifts
 
  
  -- CTE syntax
with [shift premiums]
as
(select premium from shifts)
select max(sp.premium) from [shift premiums] sp
  
with [shift premiums]  (multiplier)
as
(select premium from shifts)
select max(sp.multiplier) from [shift premiums] sp
 
with [shift premiums]([max premium])
as
(select max( premium) from shifts)
select sp.[max premium] from [shift premiums] sp
 
 
 
 
-- find the shifts that pay max premium 
with [shift extremes]([max premium])
as
(select max(premium) from shifts)
select  se.[max premium], id
from shifts cross join [shift extremes] as se
where premium = se.[max premium]
 
-- without cte

select 
(select max(premium) from shifts), id from shifts
where premium = (select max(premium) from shifts)




select * from [plant locations]

 
 
-- trivial example to illustrate syntax
with locations
as 
(select * from [plant locations])
select * from locations
 
with locations
as 
(select id, state, premium, [business sector] from [plant locations])
select * from locations
 
 
with locations(plant, st, premium, sector)
as 
(select id, state, premium, [business sector] from [plant locations])
select * from locations
 
with emp_last
as
(select id, [last name] from employees),
locations
as
(select [plant locations].id where 
 
 
 
select * from shifts
 
-- calculate total premium at each location, by shift
with locations(plant, st, premium, sector)
as 
(select id, state, premium, [business sector] from [plant locations])
select locations.plant, name, shifts.premium * locations.premium from shifts
cross join locations
order by locations.plant, name


-- calculate the stddev from the age of overall shift premiums
with 
locations(plant, st, premium, sector)
as 
(select id, state, premium, [business sector] from [plant locations]),
stats (stdev_premium, avg_premium)
as
(select stddev(shifts.premium * locations.premium), 
avg(shifts.premium * locations.premium)
from locations cross join shifts)


select count(*) from employees	where shift is null

select * from shifts


-- calculate each employee pay relative to the
-- average pay of all employees in terms
-- of standard deviations
 
with [location shifts](shift_id, plant_id, premium)
as
(select shifts.id, [plant locations].id,
 shifts.premium * [plant locations].premium  
 from shifts cross join [plant locations]),
 
[employee rates] (id, rate) as
(select employees.id, [base rate] * [location shifts].premium
from employees join [location shifts]
on employees.location = [location shifts].plant_id
and employees.shift = [location shifts].plant_id),

stats (stdev_rate, avg_rate) as
(select stdev(rate), avg(rate) from [employee rates])

select employees.id, employees.[first name], employees.[last name],
([employee rates].rate - stats.avg_rate)/stats.stdev_rate
from employees join [employee rates] on employees.id = [employee rates].id
cross join stats
order by [last name], [first name]

 
 
select * from shifts
 
select * from [plant locations]

select *from employees

 
 


with [shift premiums]
as
(select id, premium from shifts),
[local premiums](shift, plant, premium)
as
(select sp.id, pl.id, 
sp.premium * pl.premium
from [shift premiums] as sp cross join [plant locations] as pl)

select pl.name, lp.shift, lp.premium
from [plant locations] as pl join [local premiums] as lp
on pl.id = lp.plant
order by pl.name, lp.shift


select top 10 * from [big table]

 
select count(*) from [big table]


-- this is one large transaction 
-- and locks it takes live for life of entire
-- operation
update [big table] set [net worth]=[net worth]+1



drop table [big table]

create table [big table]
(
id int primary key identity,
[first name] nvarchar(50) not null,
[last name] nvarchar(50) not null,
demail nvarchar(100) not null,
[net worth] money not null,
[last update] rowversion
)


sp_help [big table]


create index rv_idx on [big table]([last update])
drop index rv_idx on [big table]


-- big table
select count(*) from [big table]


-- has rowversion column... needed for incremental ops
sp_help [big table]

-- traditional top usage


select TOP 10 * from [big table] 
order by round([net worth], 0)


-- ties excluded by default
select TOP 10 with ties * from [big table] 
order by round([net worth], 0)



-- do update in chunks to minimize max lock/resources
declare @now varbinary(8);
set @now = @@DBTS;
updateMore:
update TOP(100000) [big table] set [net worth]=[net worth]+1
where [last update] < @now;
if @@rowcount != 0
goto updateMore


-- big table
select count(*) from [big table]

select * from [big table]


-- traditional top usage

select TOP 10 * from [big table] 
order by round([net worth], 0)

-- ties excluded by default
select TOP 10 with ties * from [big table] 
order by round([net worth], 0)


select top(cast(rand() *10 as int)) * from [big table]
order by [net worth]


select * from employees


-- just rank accoding to base rate
select  [first name], [last name], [base rate],
 row_number() over (order by [base rate] desc)
from employees

-- rank accoding to rounded base rate
select  [first name], [last name], round([base rate],0),
 row_number() over (order by round([base rate], 0) desc)
from employees

-- mixing ranks
select  [first name], [last name], round([base rate],0),
row_number() over (order by round([base rate], 0) desc) as rate_rank,
row_number() over (order by location) as location_rank
from employees



-- try to page though employees
select  [first name], [last name], [base rate],
 row_number() over (order by [base rate] desc) as rn
from employees where rn between 5 and 10


-- use CTE to enable paging
with rn
as
(select id, row_number() over (order by [base rate] desc) as rn
from employees
)
select [first name], [last name], [base rate], rn from
employees join rn on employees.id = rn.id
where rn between 5 and 10


-- can be wrapped into a function
create function getEmployeePage(@page int, @pageSize int)
returns table
as
return
with rn
as
(select id, row_number() over (order by [base rate] desc) as rn
from employees
)
select [first name], [last name], [base rate], rn from
employees join rn on employees.id = rn.id
where rn between  (@page - 1)*@pageSize and (@page*@pageSize)


-- then get page 
select * from dbo.getEmployeePage(30, 25)


-- rank examples
select * from employees


-- rank according to family name
select [first name], [last name],
rank() over (order by [last name]) as rn
from employees

-- dense_rank according to family name
select [first name], [last name],
dense_rank() over (order by [last name]) as drn,
rank() over (order by [last name]) as rn
from employees


-- ntile examples
select * from employees

-- break into percentiles
select [first name], [last name], [base rate],
ntile(100) over (order by [base rate])   as percentile
from employees
order by percentile desc



-- number of tiles is expression
-- get approx 200 employees per tile
select [first name], [last name], [base rate],
ntile((select count(*)/200 from employees)) 
over (order by [base rate])   as [base tile]
from employees
order by [base tile]


-- tile size
select * from employees


with tiles( tile)
as
(
select
id, ntile(100) over (order by [base rate]) percentile
from employees
)
select count(*), tile from tiles
group by tile


-- partitioning examples

-- review
 select  [first name], [last name], [base rate],
 row_number() over (order by [base rate] desc) as rank
from employees



select  [first name], [last name],  [base rate],  location,
row_number() over (partition by location order by [base rate] desc) as rank
from employees
order by location, rank



select  [first name], [last name],  [base rate],
[base rate] * shifts.premium * [plant locations].premium as net,
location,
row_number() over (partition by location 
order by [base rate] * shifts.premium * [plant locations].premium desc) as [net rank],
row_number() over (partition by location 
order by [base rate] desc) as [base rank]
from employees
join [plant locations]
on employees.location = [plant locations].id
join shifts on employees.shift = shifts.id
order by location, [net rank]



with ranks
as
(
select  [first name], [last name],  [base rate],
[base rate] * shifts.premium * [plant locations].premium as net,
location,
row_number() over (partition by location 
order by [base rate] * shifts.premium * [plant locations].premium desc) as [net rank],
row_number() over (partition by location 
order by [base rate] desc) as [base rank]
from employees
join [plant locations]
on employees.location = [plant locations].id
join shifts on employees.shift = shifts.id
)
select * from ranks where [net rank] != [base rank]

--- aggregate partition examples
select * from employees

-- doesn't work
select location, count(*)as [employee count] from employees

-- traditional group by
select location, count(*)as [employee count] from employees
group by location

-- partitioning by location
select [first name], [last name], 
count(*) over (partition by location) as [location count],
location
from employees

-- degenerate case
select location, count(*)as [employee count] from employees

select [first name], [last name], 
count(*) over (partition by 0) as [location count],
location
from employees


-- stdev rate diff over whole company
select [first name], [last name],  location, [base rate],
([base rate] - avg([base rate]) over (partition by 0)) /
(stdev([base rate]) over (partition by 0))
 as diff
from employees



-- stdev rate diff by location
select [first name], [last name],  location, [base rate],
([base rate] - avg([base rate]) over (partition by location)) /
(stdev([base rate]) over (partition by location))
 as diff
from employees





--- partitioned by family
select [first name], [last name], [base rate],
rank() over (partition by [last name] order by [base rate])	as rank
from employees
order by [last name], rank


-- works with ntile
select [first name], [last name], [base rate],
ntile(4) over (partition by [last name] order by [base rate])	as quartile
from employees
order by [last name], quartile



-- agg partitions
-- doesn't work
select [last name], [first name], 
[base rate] - avg([base rate]) as [rate diff] from employees

-- traditional group by
select [last name], [first name], 
[base rate] - avg([base rate]) as [rate diff] from employees
group by [last name], [first name], [base rate]
