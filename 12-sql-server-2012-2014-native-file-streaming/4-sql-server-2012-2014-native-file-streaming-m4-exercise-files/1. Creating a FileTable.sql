USE master
GO

-- Create an ordinary FILESTREAM-enabled database
CREATE DATABASE DocLibrary
 ON PRIMARY
  (NAME = DocLibrary_data, 
   FILENAME = 'C:\Demo\Databases\DocLibrary_data.mdf'),
 FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM
  (NAME = DocLibrary_blobs, 
   FILENAME = 'C:\Demo\Databases\DocLibrary_blobs')
 LOG ON 
  (NAME = DocLibrary_log,
   FILENAME = 'C:\Demo\Databases\DocLibrary_log.ldf')
GO

-- Switch to the new database
USE DocLibrary
GO

-- Can't create a FileTable without a DIRECTORY_NAME for the database
CREATE TABLE Doc AS FileTable

-- View database level directory name and transacted access settings
SELECT
	db = DB_NAME(database_id),
	directory_name,
	non_transacted_access_desc
 FROM
	sys.database_filestream_options
 ORDER BY
	db

-- Enable the database for FileTable
ALTER DATABASE DocLibrary
 SET FILESTREAM
  (DIRECTORY_NAME='DocLibrary',		-- Enable FileTable in this database
   NON_TRANSACTED_ACCESS=FULL)		-- Enable access via Windows share

-- Use a different folder name for the database
ALTER DATABASE DocLibrary
 SET FILESTREAM
  (DIRECTORY_NAME='Document Library')

-- View database level directory name and transacted access settings
SELECT
	db = DB_NAME(database_id),
	directory_name,
	non_transacted_access_desc
 FROM
	sys.database_filestream_options
 ORDER BY
	db

-- Create a FileTable
--  (directory name defaults to table name, name column collation defaults to database collation)
CREATE TABLE Doc AS FileTable

-- Override the default FileTable directory name
ALTER TABLE Doc SET (FILETABLE_DIRECTORY = 'Documents')

-- Specify the directory and collation when creating the table
DROP TABLE Doc
CREATE TABLE Doc AS FileTable WITH(
 FILETABLE_DIRECTORY = 'Documents',
 FILETABLE_COLLATE_FILENAME = SQL_Latin1_General_CP1_CI_AS)

-- Discover FileTables in the database
SELECT name, is_filetable FROM sys.tables

-- Can't specify a case-sensitive collation for the Name column (filenames in Windows are case-insensitive)
CREATE TABLE ForeignDoc AS FileTable WITH(
 FILETABLE_COLLATE_FILENAME = Japanese_CS_AS)

CREATE TABLE ForeignDoc AS FileTable WITH(
 FILETABLE_COLLATE_FILENAME = Japanese_CI_AS)

DROP TABLE ForeignDoc

GO
