-- authorization, principals, objects and permissions

select * from sys.server_principals

alter login [darkmatter5\nobody] disable


alter login [darkmatter5\nobody] enable

grant control server to [darkmatter5\nobody]


use authority

setuser 'gort'


select * from numbers

select user

setuser 'nobody'


setuser

create login [darkmatter5\CrewMembers] from windows

create user [crew members] from login [darkmatter5\CrewMembers]

select * from sys.database_principals

grant select on object::numbers to [crew members]

create role pilot

sp_addrolemember 'pilot', 'gort'


grant insert on object::numbers to pilot


setuser 'gort'


insert into numbers values (3)



select * from sys.fn_my_permissions('numbers', 'object')













