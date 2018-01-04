create database authority


select * from sys.fn_my_permissions(null, 'server')


use authority


select * from sys.fn_my_permissions(null, 'database')

create table numbers
(
number int
)

select * from sys.fn_my_permissions('numbers', 'object')

insert into numbers values (1)

select * from numbers

create user gort from login [darkmatter5\gort]

select * from sys.database_principals

setuser





