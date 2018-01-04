create table [personnel (parented)]
(
employee int identity primary key,
name nvarchar(50),
[hourly rate] money,
boss int -- parent in personnel tree
);


 set identity_insert dbo.[personnel (parented)] on;
 insert into [personnel (parented)] (employee, name, [hourly rate], [boss])
 values
 (1, 'Big Boss', 1000.00, 1),
 (2, 'Joe', 10.00, 1),
 (8, 'Mary', 20.00, 1),
 (14, 'Jack', 15.00, 1),
 (3, 'Jane', 10.00, 2),
 (5, 'Max', 35.00, 2),
 (9, 'Lynn', 15.00, 8),
 (10, 'Miles', 60.00, 8),
 (12, 'Sue', 15.00, 8),
 (15, 'June', 50.00, 14),
 (18, 'Jim', 55.00, 14),
 (19, 'Bob', 40.00, 14),
 (4, 'Jayne', 35.00, 3),
 (6, 'Ann', 45.00, 5),
 (7, 'Art', 10.00, 5),
 (11, 'Al', 70.00, 10),
 (13, 'Mike', 50.00, 12),
 (16, 'Marty', 55.00, 15),
 (17, 'Barb', 60.00, 15),
 (20, 'Bart', 1000.00, 19);
  set identity_insert dbo.[personnel (parented)] off;
  
select * from [personnel (parented)]
order by boss


alter table [personnel (parented)]
add [node] hierarchyid;

-- fills all nodes
with sibs
as
(select boss, 
employee, 
cast(row_number() over (partition by boss order by employee) as varchar) + '/' as sib
from [personnel (parented)]
where employee != boss
) 
--select * from sibs
,[no node]
as
(
select boss, employee, hierarchyid::GetRoot() as node   from [personnel (parented)]
where employee = boss
UNION ALL
select P.boss, P.employee, cast([no node].node.ToString() + sibs.sib as hierarchyid)  as node
from [personnel (parented)] as P
join [no node] on P.boss = [no node].employee
join sibs on 
P.employee = sibs.employee
)
--select node.ToString(), * from [no node]
update [personnel (parented)] 
set node = [no node].node
 from  [personnel (parented)] as P join [no node]
 on P.employee = [no node].employee
 
 select node.ToString(), * from [personnel (parented)]
 order by boss
 
 

  