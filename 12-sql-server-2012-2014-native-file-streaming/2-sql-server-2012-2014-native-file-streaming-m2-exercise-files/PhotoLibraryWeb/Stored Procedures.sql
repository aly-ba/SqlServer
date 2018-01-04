USE PhotoLibrary
GO


/* =================== Stored procedures to insert/select rows for streaming API =================== */

-- Insert new photo row
CREATE PROCEDURE InsertPhotoRow(
	@PhotoId int,
	@PhotoDescription varchar(max))
 AS
BEGIN
	
	INSERT INTO PhotoAlbum(PhotoId, PhotoDescription, Photo)
	 OUTPUT inserted.Photo.PathName(), GET_FILESTREAM_TRANSACTION_CONTEXT()
	 SELECT @PhotoId, @PhotoDescription, 0x

END
GO

-- Select photo image path + txn context
CREATE PROCEDURE SelectPhotoImageInfo(@PhotoId int)
 AS
BEGIN
	
	SELECT
		Photo.PathName(),
		GET_FILESTREAM_TRANSACTION_CONTEXT()
	 FROM PhotoAlbum
	 WHERE PhotoId = @PhotoId

END
GO

-- Select photo description
CREATE PROCEDURE SelectPhotoDescription(
	@PhotoId int,
	@PhotoDescription varchar(max) OUTPUT)
 AS
BEGIN
	
	SELECT @PhotoDescription = PhotoDescription
	 FROM PhotoAlbum
	 WHERE PhotoId = @PhotoId

END
GO
