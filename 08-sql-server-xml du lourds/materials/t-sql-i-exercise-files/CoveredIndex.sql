use tsql1;

create table #rectangles
(
id int identity primary key,
length int,
width int,
material varchar(30)
)

insert into #rectangles values
(10, 3, 'cardboard'),
(11, 5, 'cardboard'),
(11, 5, 'cardboard'),
(11, 4, 'cardboard'),
(11, 4, 'cardboard'),
(13, 3, 'cardboard'),
(9, 3, 'cardboard'),
(10, 6, 'cardboard'),
(8, 3, 'cardboard')

select * from #rectangles

select id, length, width, material from #rectangles where length=11 and width=5

create index lw on #rectangles (length, width)

-- end up with index that looks something like
select cast(length as varchar(4)) + ',' + cast(width as varchar(4)) +
 ',' + cast(id as varchar(4))  from #rectangles order by length, width

8,3,9
9,3,7
10,3,1
10,6,8
11,4,4
11,4,5
11,5,2
11,5,3
13,3,6

select id, length, width, material from #rectangles where length = 11 and width = 5

drop index lw on #rectangles

create index lwm on #rectangles (length, width, material)

-- end up with index that looks something like
select cast(length as varchar(4)) + ',' + cast(width as varchar(4)) +
 ',' + material + ',' + cast(id as varchar(4))  from #rectangles order by length, width, material

8,3,cardboard,9
9,3,cardboard,7
10,3,cardboard,1
10,6,cardboard,8
11,4,cardboard,4
11,4,cardboard,5
11,5,cardboard,2
11,5,cardboard,3
13,3,cardboard,6


select id, length, width, material from #rectangles where length = 11 and width = 5

update #rectangles set material='paper mache' where id=2

select * from #rectangles

-- what index looks like now
select cast(length as varchar(4)) + ',' + cast(width as varchar(4)) +
 ','  + material  + ',' + cast(id as varchar(4))  from #rectangles order by length, width, material

8,3,cardboard,9
9,3,cardboard,7
10,3,cardboard,1
10,6,cardboard,8
11,4,cardboard,4
11,4,cardboard,5
11,5,cardboard,3
11,5,paper mache,2
13,3,cardboard,6


drop index lwm on #rectangles

create index lwmContrived on #rectangles (length, width) include (material)

-- what index looks like now
select cast(length as varchar(4)) + ',' + cast(width as varchar(4)) +
 ','  + material  + ',' + cast(id as varchar(4))  from #rectangles order by length, width

8,3,cardboard,9
9,3,cardboard,7
10,3,cardboard,1
10,6,cardboard,8
11,4,cardboard,4
11,4,cardboard,5
11,5,paper mache,2
11,5,cardboard,3
13,3,cardboard,6

select id, width, material from #rectangles where length = 11 and width=5

update #rectangles set material='platinum' where id=2

