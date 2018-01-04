use securityII


create database Context


alter authorization on database::Context to [darkmatter5\gort]

use Context



create   table tests
(
id int,
location varchar(max)
)

select * from tests


create user [darkmatter5\workerbee]


grant select on tests to [darkmatter5\workerbee]



execute as login = 'darkmatter5\gort'

select * from sys.fn_my_permissions('tests', 'object')

revert



execute as user = 'darkmatter5\workerbee'


select * from sys.fn_my_permissions('tests', 'object')


revert


use securityII


execute as user = 'darkmatter5\workerbee'


select * from Context.dbo.tests

revert


execute as login = 'darkmatter5\workerbee'


select * from Context.dbo.tests

use Context

select * from tests


revert

use securityII


revert
































































































































































