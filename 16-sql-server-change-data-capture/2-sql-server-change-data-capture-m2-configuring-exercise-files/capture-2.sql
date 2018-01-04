/*
USE [master];
GO
RESTORE DATABASE [Credit] FROM  DISK = N'E:\SQLBackups\CreditBackup100.bak' WITH  FILE = 1,  NOUNLOAD,  STATS = 5, REPLACE
GO
*/

USE [Credit];
GO

-- Create the cdc_admin role to control access to the change tables
CREATE ROLE [cdc_admin]
GO

-- Enable the database for CDC
EXEC sys.sp_cdc_enable_db
GO
 