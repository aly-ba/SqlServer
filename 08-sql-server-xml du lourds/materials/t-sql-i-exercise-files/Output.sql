use tsql1;

create table #products
(
id int primary key identity,
class int,
name varchar(100),
price money,
[stock level] int
)

Insert into #products values
(2, 'big wheel', 1.22, 4),
(2, 'little wheel', 1.11, 50),
(3, 'console', 200.11, 30),
(2, 'crayons', 3.22, 23),
(4, 'baseball', 44.33, 10),
(3, 'hub', 65.22, 3),
(4, 'basketball', 44.33, 43)

select * from #products

update #products
 set price = price + 1 
output inserted.id, deleted.price as [old price], inserted.price as [new price]
where class = 3

declare @changes table(
id int not null,
[old price] money,
[new price] money
)
update #products
 set price = price + 1 
output inserted.id, deleted.price as [old price], inserted.price as [new price] into @changes
where class = 3
select * from @changes

delete #products
output deleted.*
where id = 3 or id = 6

Insert into #products 
output inserted.*
values
(2, 'moderate wheel', 1.22, 4),
(2, 'really little wheel', 1.11, 50)


