create database securityII

use securityII


select * from securityII.sys.schemas

select * from sys.schemas


select s.*, p.name from sys.schemas as s join sys.database_principals as p
on s.principal_id = p.principal_id


select user

create user nologin without login

create user gorty from login [darkmatter5\gort]


create user klatuu from login [darkmatter5\klatuu] with default_schema = saucer


select * from sys.database_principals where name in ('gorty', 'klatuu', 'nologin')

alter user gorty with default_schema = saucer


select * from sys.fn_my_permissions('securityII', 'database')

create schema saucer
create table planets
(
id int primary key,
name varchar(50)
)
create table stars
(
id int primary key,
name varchar(50)
)
create view places
as
select id, name from planets
union
select id, name from stars
union
select id, name from comets;


select * from sys.schemas where name = 'saucer'


create schema saucer
create table planets
(
id int primary key,
name varchar(50)
)
create table stars
(
id int primary key,
name varchar(50)
)
create table comets
(
id int primary key,
name varchar(50)
)
create view places
as
select id, name from planets
union
select id, name from stars
union
select id, name from comets

select * from sys.tables


select o.name from sys.objects as o join sys.schemas as s
on o.schema_id = s.schema_id
where s.name = 'saucer'


select * from saucer.planets


select * from dbo.planets

setuser 'gorty'

 select user

setuser

 select user

execute as user = 'gorty'

 select user

revert

execute as user = 'gorty'

select * from planets

select * from saucer.planets

revert

grant select on saucer.planets to gorty

execute as user = 'gorty'

select * from planets

select * from saucer.planets

select * from sys.fn_my_permissions('saucer.planets', 'object')

revert

deny select on saucer.planets(id) to gorty


execute as user = 'gorty'

select * from planets

select name from planets


revert 


select s.name, p.name from sys.schemas as s join sys.database_principals as p
on s.principal_id = p.principal_id
where s.name = 'saucer'


execute as user = 'klatuu'
select * from saucer.planets

revert


alter authorization on schema::saucer to klatuu


select s.name, p.name from sys.schemas as s join sys.database_principals as p
on s.principal_id = p.principal_id
where s.name = 'saucer'


execute as user = 'klatuu'

select * from planets


select * from sys.fn_my_permissions('saucer.planets', 'object')

alter table planets
add albedo float


sp_help 'planets'

revert


create schema dangers authorization gorty
create table bad_planets
(
id int primary key,
name varchar(50)
)

select p.name, s.* from sys.schemas as s join sys.database_principals as p
on s.principal_id = p.principal_id
where s.name='dangers'



  execute as user = 'gorty'


select * from sys.fn_my_permissions('dangers', 'schema')


create table dangers.status
(
 i int primary key,
level varchar(50)
)


revert


grant create table to gorty

  execute as user = 'gorty'



create table dangers.status
(
 i int primary key,
level varchar(50)
)

select * from dangers.bad_planets


revert
execute as user = 'klatuu'

select * from dangers.bad_planets



revert


  execute as user = 'gorty'

grant select on dangers.bad_planets to klatuu

revert







