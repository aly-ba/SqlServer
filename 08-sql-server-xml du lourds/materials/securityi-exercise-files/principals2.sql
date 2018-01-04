create database [security principals]

use [security principals]

select * from sys.server_principals

create login DoNotDoThis with password = 'password'

create login [darkmatter5\nobody] from windows


select * from [security principals].sys.database_principals

select * from [model].sys.database_principals

create user [darkmatter5\nobody]

--0x010500000000000515000000A18AD416EDF9398F7F203B5F01040000

create user gorty from login [darkmatter5\gort]


select * from sys.server_principals where sid = 0x010500000000000515000000A18AD416EDF9398F7F203B5FF4030000


select * from sys.server_principals where sid = 0x010500000000000515000000A18AD416EDF9398F7F203B5F01040000

select * from sys.server_principals where sid = 0x010500000000000903000000E219687297D73D4B9F331B5F91C31475


create user whoami without login

drop user whoami




alter user [darkmatter5\nobody] with name = noone

create role myrole





