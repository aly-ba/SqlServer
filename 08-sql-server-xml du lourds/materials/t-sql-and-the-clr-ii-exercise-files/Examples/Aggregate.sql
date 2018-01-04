create table [#values]
(
value int
);

insert into [#values] values (1);
insert into [#values] values (2);
insert into [#values] values (1);
insert into [#values] values (2);

insert into [#values] values (null);

delete [#values] where value is null;

select dbo.SumSpecial(value) from [#values]

select Sum(value) from [#values]


select
case 
when 0 != (select TOP 1 count(*) from [#values] where value is null)	then null
ELSE
sum([value])
END
from [#values]

select prod(value) from [#values]

select exp(sum(log(value))) from [#values]

