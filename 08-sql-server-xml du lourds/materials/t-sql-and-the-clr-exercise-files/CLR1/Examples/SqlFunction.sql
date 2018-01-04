use clr1;

select dbo.area(3,4);


select dbo.[geo area](3,4);

drop table geoprops;


create table geoprops
(
id int identity primary key,
height real,
width real,
area as dbo.[geo area](height, width) persisted
)

insert into geoprops values (12,3);
insert into geoprops values (2,33);
insert into geoprops values (1,4);


select * from geoprops;


