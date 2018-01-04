:CONNECT SQL2K12-SVR1
USE [Credit];

EXEC  sp_helppublication 
@publication = 'Pub_Credit';
GO

:CONNECT SQL2K12-SVR1
USE [Credit];

EXEC  sp_changepublication  
 @publication = 'Pub_Credit',
@property = 'immediate_sync', 
 @value = 'false'; 
 GO 

:CONNECT SQL2K12-SVR1
USE [Credit];

EXEC  sp_helppublication 
@publication = 'Pub_Credit';
GO