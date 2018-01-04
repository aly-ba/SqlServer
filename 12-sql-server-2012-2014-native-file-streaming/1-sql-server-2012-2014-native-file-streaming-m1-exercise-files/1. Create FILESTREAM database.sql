USE master
GO

/* =================== Create a new FILESTREAM-enabled database =================== */

-- Create database with FILESTREAM filegroup/container
CREATE DATABASE PhotoLibrary
 ON PRIMARY
  (NAME = PhotoLibrary_data, 
   FILENAME = 'C:\Demo\PhotoLibrary\PhotoLibrary_data.mdf'),
 FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM
  (NAME = PhotoLibrary_blobs, 
   FILENAME = 'C:\Demo\PhotoLibrary\Photos')
 LOG ON 
  (NAME = PhotoLibrary_log,
   FILENAME = 'C:\Demo\PhotoLibrary\PhotoLibrary_log.ldf')
GO

-- Switch to the new database
USE PhotoLibrary
GO

-- Show the database filegroups
SELECT * FROM sys.filegroups

/* =================== FILESTREAM-enable an existing database =================== */

-- Switch to master
USE master
GO

-- Drop the database
DROP DATABASE PhotoLibrary
GO

-- Recreate the database without the FILESTREAM filegroup/container
 CREATE DATABASE PhotoLibrary
 ON PRIMARY
  (NAME = PhotoLibrary_data, 
   FILENAME = 'C:\Demo\PhotoLibrary\PhotoLibrary_data.mdf')
 LOG ON 
  (NAME = PhotoLibrary_log,
   FILENAME = 'C:\Demo\PhotoLibrary\PhotoLibrary_log.ldf')
GO

-- Switch to the new database
USE PhotoLibrary
GO

-- Show the database filegroups
SELECT * FROM sys.filegroups

-- Add a FILESTREAM filegroup to the database
ALTER DATABASE PhotoLibrary
 ADD FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM

-- Add a container to the FILESTREAM filegroup
ALTER DATABASE PhotoLibrary
 ADD FILE
  (NAME = PhotoLibrary_blobs, 
   FILENAME = 'C:\Demo\PhotoLibrary\Photos')
 TO FILEGROUP FileStreamGroup1

-- Show the database filegroups
SELECT * FROM sys.filegroups
