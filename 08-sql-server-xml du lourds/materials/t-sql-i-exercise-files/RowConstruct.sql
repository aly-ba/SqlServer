use tsql1;

create table #people
(
id int primary key identity,
name varchar(100),
state char(2)
)

insert into #people 
select 'joe', 'ma'
union
select 'mary', 'ca'
union
select 'frank', 'pa'
select * from #people

insert into #people values ('mike', 'me')
insert into #people values ('hope', 'ct')

insert into #people values
('carol', 'ut'),
('charles', 'wa'),
('cate', 'or')

select * from #people

create table #members
(
id int primary key identity,
name varchar(100),
state char(2),
)


insert into #members values
('harley', 'ka'),
(select name, state from #people),
('cindy', 'az')


insert into #members values
('harley', 'ka'),
((select name from #people where id = 2), (select state from #people where id = 2) ),
('cindy', 'az')

select * from #members

