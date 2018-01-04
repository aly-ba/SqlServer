USE PhotoLibrary
GO

/* =================== Use T-SQL to store and retrieve FILESTREAM data =================== */

-- Create a FILESTREAM-enabled table
CREATE TABLE PhotoAlbum(
 PhotoId int PRIMARY KEY,
 RowId uniqueidentifier ROWGUIDCOL NOT NULL UNIQUE DEFAULT NEWSEQUENTIALID(),
 PhotoDescription varchar(max),
 Photo varbinary(max) FILESTREAM)

GO

-- Add row #1 with a simple text BLOB using CAST
INSERT INTO PhotoAlbum(PhotoId, PhotoDescription, Photo)
 VALUES(
	1,
	'Text file',
	CAST('BLOB' AS varbinary(max)))
 
SELECT *, DATALENGTH(Photo) AS BlobSize, CAST(Photo AS varchar) AS BlobAsText FROM PhotoAlbum

-- Add row #2 with a small icon BLOB using inlined binary content
INSERT INTO PhotoAlbum(PhotoId, PhotoDescription, Photo)
 VALUES(
	2,
	'Document icon',
	0x4749463839610C000E00B30000FFFFFFC6DEC6C0C0C0000080000000D3121200000000000000000000000000000000000000000000000000000000000021F90401000002002C000000000C000E0000042C90C8398525206B202F1820C80584806D1975A29AF48530870D2CEDC2B1CBB6332EDE35D9CB27DCA554484204003B)

SELECT *, DATALENGTH(Photo) AS BlobSize FROM PhotoAlbum

-- Add row #3 with an external image file imported using OPENROWSET with SINGLE_BLOB
INSERT INTO PhotoAlbum(PhotoId, PhotoDescription, Photo)
 VALUES(
	3,
	'Mountains',
	(SELECT BulkColumn FROM OPENROWSET(BULK 'C:\Demo\Ascent.jpg', SINGLE_BLOB) AS x))

SELECT *, DATALENGTH(Photo) AS BlobSize FROM PhotoAlbum


/* =================== Use T-SQL to delete FILESTREAM data =================== */

-- Delete row #1
DELETE FROM PhotoAlbum WHERE PhotoId = 1
SELECT * FROM PhotoAlbum

-- Forcing garbage collection won't delete the file without a BACKUP if using FULL recovery model
EXEC sp_filestream_force_garbage_collection 

-- Switch from FULL to SIMPLE recovery model
SELECT name, recovery_model_desc FROM sys.databases WHERE name = 'PhotoLibrary'
ALTER DATABASE PhotoLibrary SET RECOVERY SIMPLE
SELECT name, recovery_model_desc FROM sys.databases WHERE name = 'PhotoLibrary'

-- Forcing garbage collection will now delete the file immediately
EXEC sp_filestream_force_garbage_collection 
