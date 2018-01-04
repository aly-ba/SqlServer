-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

-- Creating a table type
CREATE TYPE [CategoryType] AS TABLE
([category_no] INT,
[category_desc] VARCHAR(31),
[category_code] CHAR(2));
GO


-- Create a procedure with the table type input parameter
CREATE PROCEDURE dbo.[LoadCategoryTable]
    @CategoryInput [CategoryType] READONLY
AS 
SET IDENTITY_INSERT [dbo].[category] ON;

INSERT  [dbo].[category]
        ([category_no],
         [category_desc],
         [category_code])
        SELECT  [category_no],
                [category_desc],
                [category_code]
        FROM    @CategoryInput;

SET IDENTITY_INSERT [dbo].[category] OFF;

GO

-- Table variable with a table type
DECLARE @CategoryInput AS [CategoryType];

INSERT  @CategoryInput
VALUES  (11, 'Press', 'PR'),
        (12, 'Media', 'ME'),
        (13, 'Print', 'PR'),
        (14, 'Advertising', 'AD');

EXECUTE [dbo].[LoadCategoryTable] @CategoryInput;
GO

-- Were the rows inserted?
SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    [dbo].[category];
GO


-- Cleanup
DROP PROCEDURE [dbo].[LoadCategoryTable];

DROP TYPE [CategoryType];

DELETE  [dbo].[category]
WHERE   [category_no] BETWEEN 11 AND 14;
GO


