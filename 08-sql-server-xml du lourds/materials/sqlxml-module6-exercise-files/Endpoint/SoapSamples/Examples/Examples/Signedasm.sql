
-- key must be in master so login can be created from it
use master;

CREATE ASYMMETRIC KEY ExtensionsKey 
FROM FILE = 'D:\SqlVidCourse\CLR1\Examples\SqlExtensions.snk'
ENCRYPTION BY PASSWORD = '9AMa$%w34qR4^^qcwioZq45u'; 

use CLR1;

CREATE LOGIN ExtensionsLogin FROM ASYMMETRIC KEY ExtensionsKey  ;

use master;
grant external access assembly to ExtensionsLogin;
use clr1;

select dbo.GortFileAttributes('D:\SqlVidCourse\CLR1\Examples\VSAdmin.png');





