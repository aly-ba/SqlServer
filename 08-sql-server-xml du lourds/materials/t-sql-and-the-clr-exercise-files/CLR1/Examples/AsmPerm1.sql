sp_configure 'show advanced options', 1;

GO

RECONFIGURE;

GO

sp_configure 'clr enabled', 1;

GO

RECONFIGURE;

GO

select dbo.Sub2(1,3);


create user GORT from login [darkmatter5\gort]


execute as user = 'GORT'

select dbo.Sub2(1,3);

revert;

grant execute on object::dbo.sub2 to gort ;

grant create assembly to gort;

grant create function to gort;

grant alter on schema::dbo to gort;

execute as user = 'GORT'

select dbo.GortFcn();


grant execute on object::dbo.GortFcn to gort ;



