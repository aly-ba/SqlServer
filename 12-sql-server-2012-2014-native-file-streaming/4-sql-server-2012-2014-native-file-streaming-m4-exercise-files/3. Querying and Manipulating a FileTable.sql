USE DocLibrary
GO

SELECT * FROM Doc
GO


/* Move folders and files */

CREATE PROCEDURE uspMoveItem(@FullName varchar(max), @NewParent varchar(max))
 AS
BEGIN

	DECLARE @ItemId hierarchyid = GETPATHLOCATOR(FILETABLEROOTPATH('Doc') + @FullName)
	IF @ItemId IS NULL
	 THROW 50000, 'Item not found.', 1

	DECLARE @OldParentId hierarchyid = @ItemId.GetAncestor(1)

	DECLARE @NewParentId hierarchyid = GETPATHLOCATOR(FILETABLEROOTPATH('Doc') + @NewParent)
	IF @NewParentId IS NULL
	 THROW 50000, 'New parent not found.', 1

	UPDATE Doc
		SET path_locator = path_locator.GetReparentedValue(@OldParentId, @NewParentId)
		WHERE path_locator.IsDescendantOf(@ItemId) = 1

END
GO

-- Move \Financial\2013 to \Financial\Budget\2013
EXEC uspMoveItem '\Financial\2013', '\Financial\Budget'

-- Move DinnerReceipt.png from 2014 folder to 2013 folder
EXEC uspMoveItem '\Financial\Budget\2014\DinnerReceipt.png', '\Financial\Budget\2013'

GO


/* Get child subtrees */

CREATE PROCEDURE uspGetChildItems(@FullName varchar(max))
 AS
BEGIN
	SELECT
		IIF(is_directory = 1, 'Folder', 'File') AS ItemType,
		name AS ItemName,
		file_stream.GetFileNamespacePath() AS ItemPath
	 FROM
		Doc
	 WHERE
		path_locator.IsDescendantOf(GETPATHLOCATOR(FILETABLEROOTPATH('Doc') + @FullName)) = 1
	 ORDER BY
		ItemPath
END
GO

EXEC uspGetChildItems '\Financial'
EXEC uspGetChildItems '\Financial\Budget'
EXEC uspGetChildItems '\Financial\Budget\2013'
EXEC uspGetChildItems '\Financial\Budget\2014'

GO


/* Get parent folders */

CREATE PROCEDURE uspGetParentItems(@FullName varchar(max))
 AS
BEGIN
	SELECT
		IIF(parent.is_directory = 1, 'Folder', 'File') AS ItemType,
		parent.name as ItemName,
		parent.file_stream.GetFileNamespacePath() as ItemPath
	 FROM
		Doc AS parent
		INNER JOIN Doc AS child ON child.path_locator.IsDescendantOf(parent.path_locator) = 1
	 WHERE
		child.path_locator = GETPATHLOCATOR(FILETABLEROOTPATH('Doc') + @FullName)
	 ORDER BY
		ItemPath
END
GO

-- Show parent folders
EXEC uspGetParentItems '\Financial'
EXEC uspGetParentItems '\Financial\Budget'
EXEC uspGetParentItems '\Financial\Budget\2013'
EXEC uspGetParentItems '\Financial\Budget\2014'
EXEC uspGetParentItems '\Financial\Budget\2014\TravelBudget.rtf'

GO


/* Delete folders and files */

CREATE PROCEDURE uspDeleteItem(@FullName varchar(max))
 AS
BEGIN

	DECLARE @ItemId hierarchyid = GETPATHLOCATOR(FILETABLEROOTPATH('Doc') + @FullName)
	IF @ItemId IS NULL
	 THROW 50000, 'Item not found.', 1

	DELETE FROM Doc WHERE path_locator.IsDescendantOf(@ItemId) = 1

END
GO

-- Delete ReadMe2014.txt from 2014 folder
EXEC uspDeleteItem '\Financial\Budget\2014\ReadMe2014.txt'

-- Delete \Financial\Budget folder
EXEC uspDeleteItem '\Financial\Budget'

GO

