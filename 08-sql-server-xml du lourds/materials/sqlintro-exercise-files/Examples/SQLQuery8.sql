use AdventureWorks;

select emp.EmployeeID, per.FirstName, per.LastName
from HumanResources.Employee as emp
join
Person.Contact as per
on emp.ContactId = per.ContactId
 
use People;

create table stuff
(
id int identity,
name varchar(50)
);

insert into stuff values ('asdfasf')
insert into stuff values ('sdfsdasdfasf')
insert into stuff values ('asdfsdfsdfasf')


select * from stuff






