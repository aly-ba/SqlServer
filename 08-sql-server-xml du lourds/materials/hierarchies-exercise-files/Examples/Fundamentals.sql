-- hierarchyid as a number path
declare @hid hierarchyid;
set @hid = '/1/2/3/4/';
select @hid, @hid.ToString();

-- syntax depends on final /
declare @hid hierarchyid;
set @hid = '/1/2/3/4';

-- sorting hierarchyid's
-- msd radix sort
declare @hid1 hierarchyid;
declare @hid2 hierarchyid;
set @hid1 = '/1/2/3/1/';
set @hid2 = '/1/2/2/4/';
select  hid.ToString() from
 (select @hid1 as hid
 union
 select @hid2 as hid) as a
  order by hid
  
-- adding length produces breadth first sort
declare @hid1 hierarchyid;
declare @hid2 hierarchyid;
set @hid1 = '/1/2/2/1/';
set @hid2 = '/1/1/2/1/2/';
select hid.ToString() from
 (select 4 as len, @hid1 as hid
 union
 select 5 as len, @hid2 as hid) as a
 order by len, hid
 


create table [personnel (small)]
(
employee int identity primary key,
name nvarchar(50),
[hourly rate] money,
node hierarchyid
)


insert into [personnel (small)] (name, [hourly rate], node) values
('Big Boss', 1000, '/'),
('Joe', 10, '/1/'),
('Mary', 20, '/2/'),
('Jack', 15, '/3/'),
('Jane', 10, '/1/1/'),
('Max', 35, '/1/2/'),
('Lynn', 15, '/2/1/'),
('Miles', 60, '/2/2/'),
('Sue', 15, '/2/3/'),
('June', 50, '/3/1/'),
('Jim', 55, '/3/2/'),
('Bob', 40, '/3/3/'),
('Jayne', 35, '/1/1/1/'),
('Ann', 45, '/1/2/1/'),
('Art', 10, '/1/2/2/'),
('Al', 70, '/2/2/1/'),
('Mike', 50, '/2/3/1/'),
('Marty', 55, '/3/1/1/'),
('Barb', 60, '/3/1/2/'),
('Bart', 1000, '/3/3/1/');

select * from [personnel (small)]

 select node.ToString(), * from [personnel (small)]
 
select P.node.ToString() as node, P.name, P2.name as boss
from [personnel (small)] as P
join [personnel (small)] as P2
on P2.node.ToString() = left(P.node.ToString(), 
	len(P.node.ToString()) + 1 -
	    charindex('/', reverse(P.node.ToString()),2 ))
	    
	      

  