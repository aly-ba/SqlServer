use securityII


sp_helpsrvrole

sp_srvrolepermission 'sysadmin'

sp_srvrolepermission 'dbcreator'


select * from sys.server_principals where type= 'r'


select * from sys.database_principals where type= 'r'


select * from sys.server_principals where name = 'sysadmin'


create login [darkmatter5\workerbee] from windows 


sp_helpsrvrolemember 'sysadmin'

sp_addsrvrolemember 'darkmatter5\workerbee', 'sysadmin'


sp_dropsrvrolemember 'darkmatter5\workerbee', 'sysadmin'

sp_helpdbfixedrole

select * from sys.database_principals


create user [darkmatter5\workerbee]

execute as user = 'darkmatter5\workerbee'

 select * from saucer.planets

revert

sp_addrolemember 'db_datareader', 'darkmatter5\workerbee'


deny select on schema::saucer to db_datareader

deny select on schema::saucer to [darkmatter5\workerbee]

revert


create login [darkmatter5\raygun] from windows
create user [darkmatter5\raygun]


create role saucer_reader
grant select on schema::saucer to saucer_reader


select pri.name as role, pri2.name as principal  from sys.database_role_members as rm
join sys.database_principals as pri
on pri.principal_id = rm.role_principal_id
join sys.database_principals as pri2
on pri2.principal_id = rm.member_principal_id
where pri2.name = 'darkmatter5\raygun'


select * from sys.database_role_members

select pri.name as role, pri2.name as principal  from sys.database_role_members as rm
join sys.database_principals as pri
on pri.principal_id = rm.role_principal_id
join sys.database_principals as pri2
on pri2.principal_id = rm.member_principal_id
where pri2.name = 'darkmatter5\workerbee'



execute as user = 'darkmatter5\raygun'

select * from saucer.planets
revert


sp_addrolemember 'saucer_reader', 'darkmatter5\raygun'

execute as user = 'darkmatter5\raygun'

select * from saucer.planets
revert


select pri.name as role, pri2.name as principal from sys.database_role_members as rm
join sys.database_principals as pri
on pri.principal_id = rm.role_principal_id
join sys.database_principals as pri2
on pri2.principal_id = rm.member_principal_id
where pri2.name = 'darkmatter5\raygun'



create role no_saucer

deny control on schema::saucer to no_saucer

sp_addrolemember 'no_saucer', 'darkmatter5\raygun'

select pri.name as role, pri2.name as principal from sys.database_role_members as rm
join sys.database_principals as pri
on pri.principal_id = rm.role_principal_id
join sys.database_principals as pri2
on pri2.principal_id = rm.member_principal_id
where pri2.name = 'darkmatter5\raygun'


execute as user = 'darkmatter5\raygun'

select * from saucer.planets


revert








