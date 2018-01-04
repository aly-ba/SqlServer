-- Execute from the publication database
USE [Credit];
GO

EXEC sys.sp_posttracertoken 'Pub_Credit';
GO

EXEC sys.sp_helptracertokens 'Pub_Credit';
GO

EXEC sys.sp_helptracertokenhistory 
	'Pub_Credit', 
	-2147483639;
GO
