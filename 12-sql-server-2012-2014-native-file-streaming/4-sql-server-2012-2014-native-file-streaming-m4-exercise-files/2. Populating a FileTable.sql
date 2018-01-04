USE DocLibrary
GO


/* Show path_locator default constraint */

SELECT
    d.name,
	d.[definition]
 FROM 
    sys.all_columns AS c
    INNER JOIN sys.tables AS t ON c.[object_id] = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
	INNER JOIN sys.default_constraints AS d ON c.default_object_id = d.[object_id]
 WHERE
	s.name = 'dbo' AND t.name = 'Doc' AND c.name = 'path_locator'
GO


/* View FileTable defaults and constraints */

SELECT
	OBJECT_NAME(parent_object_id) FileTableName,
	OBJECT_NAME([object_id]) AS ObjectName
 FROM
	sys.filetable_system_defined_objects

GO


/* Create folders and files */

CREATE PROCEDURE uspAddItem(
	@Parent varchar(max),
	@Name varchar(max),
	@File varchar(max) = NULL)
 AS 
BEGIN

	DECLARE @ParentId hierarchyid = GETPATHLOCATOR(FILETABLEROOTPATH('Doc') + @Parent)
	IF @ParentId IS NULL
	 THROW 50000, 'Parent not found.', 1

	DECLARE @RandomId binary(16) = CONVERT(binary(16), NEWID())
	DECLARE @NewId hierarchyid = CONVERT(hierarchyid, CONCAT(
	 @ParentId.ToString(),
	 CONVERT(varchar(20), CONVERT(bigint, SUBSTRING(@RandomId, 1, 6))), '.',
	 CONVERT(varchar(20), CONVERT(bigint, SUBSTRING(@RandomId, 7, 6))), '.',
	 CONVERT(varchar(20), CONVERT(bigint, SUBSTRING(@RandomId, 13, 4))), '/'))

	DECLARE @Blob varbinary(max)

	IF @File IS NOT NULL BEGIN
		DECLARE @GetBlobSql nvarchar(max) =
		 N'SET @Blob = (SELECT BulkColumn FROM OPENROWSET(BULK ''' + @File + ''', SINGLE_BLOB) AS x)'
		EXECUTE sp_executesql @GetBlobSql, N'@Blob varbinary(max) OUTPUT', @Blob = @Blob OUTPUT
	END

	INSERT INTO Doc(file_stream, name, path_locator, is_directory)
	 VALUES(@Blob, @Name, @NewId, IIF(@File IS NULL, 1, 0))

END
GO


/* Don't allow files in the root folder */

ALTER TABLE Doc
 ADD CONSTRAINT CK_Doc_NoRootFiles CHECK (is_directory = 1 OR path_locator.GetLevel() > 1)
GO

EXEC uspAddItem '', 'CompanyLogo.png', 'C:\Demo\Dummy.png'
GO


-- Create folder \Financial
EXEC uspAddItem '', 'Financial'

-- Add file to \Financial folder
EXEC uspAddItem '\Financial', 'CompanyLogo.png', 'C:\Demo\Dummy.png'

SELECT * FROM Doc

-- Create folder \Financial\Budget
EXEC uspAddItem '\Financial', 'Budget'

-- Create folder \Financial\Budget\2014
EXEC uspAddItem '\Financial\Budget', '2014'

-- Add files to 2014 folder
EXEC uspAddItem '\Financial\Budget\2014', 'ReadMe2014.txt', 'C:\Demo\Dummy.txt'
EXEC uspAddItem '\Financial\Budget\2014', 'DinnerReceipt.png', 'C:\Demo\Dummy.png'
EXEC uspAddItem '\Financial\Budget\2014', 'TravelBudget.rtf', 'C:\Demo\Dummy.rtf'

-- Create folder \Financial\2013
EXEC uspAddItem '\Financial', '2013'

-- Add files to 2013 folder
EXEC uspAddItem '\Financial\2013', 'ReadMe2013.txt', 'C:\Demo\Dummy.txt'
EXEC uspAddItem '\Financial\2013', 'Entertainment.png', 'C:\Demo\Dummy.png'

GO


/* Disable/Enable FileTable namespace */

ALTER TABLE Doc DISABLE FILETABLE_NAMESPACE

-- Constraints are disabled! Perform bulk updates very carefully...

ALTER TABLE Doc ENABLE FILETABLE_NAMESPACE
GO
