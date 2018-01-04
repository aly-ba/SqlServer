select name, type_desc from sys.server_principals

select name, is_disabled from sys.server_principals 
   where type_desc in ('sql_login', 'windows_login')
 

create login [darkmatter5\nobody] from windows
 


























