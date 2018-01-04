-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

USE [Credit]
GO

-- No Handling
SET IDENTITY_INSERT [dbo].[category] ON;

INSERT  INTO [dbo].[category]
        ([category_no],
            [category_desc],
            [category_code])
VALUES  (1,
            'Travel',
            '');

SET IDENTITY_INSERT [dbo].[category] OFF;



-- Handling with no action at all (not recommended)
BEGIN TRY

    SET IDENTITY_INSERT [dbo].[category] ON;

    INSERT  INTO [dbo].[category]
            ([category_no],
             [category_desc],
             [category_code])
    VALUES  (1,
             'Travel',
             '');

    SET IDENTITY_INSERT [dbo].[category] OFF;

END TRY
BEGIN CATCH
	-- Nothing going on here
END CATCH



-- Handling - but not surfacing an actual error to the caller
BEGIN TRY

    SET IDENTITY_INSERT [dbo].[category] ON;

    INSERT  INTO [dbo].[category]
            ([category_no],
             [category_desc],
             [category_code])
    VALUES  (1,
             'Travel',
             '');

    SET IDENTITY_INSERT [dbo].[category] OFF;

END TRY
BEGIN CATCH
	
    PRINT 'The INSERT did not succeed.';

END CATCH



-- Handling - but not surfacing an actual error to the caller
-- but still returning tabular error information
BEGIN TRY

    SET IDENTITY_INSERT [dbo].[category] ON;

    INSERT  INTO [dbo].[category]
            ([category_no],
             [category_desc],
             [category_code])
    VALUES  (1,
             'Travel',
             '');

    SET IDENTITY_INSERT [dbo].[category] OFF;

END TRY
BEGIN CATCH
	
    PRINT 'The INSERT did not succeed.';

    SELECT  ERROR_LINE() AS [Error_Line],
            ERROR_MESSAGE() AS [Error_Message],
            ERROR_NUMBER() AS [Error_Number],
            ERROR_SEVERITY() AS [Error_Severity],
            ERROR_PROCEDURE() AS [Error_Procedure];

END CATCH



-- Handling, providing error info, and throwing an error message
BEGIN TRY

    SET IDENTITY_INSERT [dbo].[category] ON;

    INSERT  INTO [dbo].[category]
            ([category_no],
             [category_desc],
             [category_code])
    VALUES  (1,
             'Travel',
             '');

    SET IDENTITY_INSERT [dbo].[category] OFF;

END TRY
BEGIN CATCH
	
    PRINT 'The INSERT did not succeed.';

    SELECT  ERROR_LINE() AS [Error_Line],
            ERROR_MESSAGE() AS [Error_Message],
            ERROR_NUMBER() AS [Error_Number],
            ERROR_SEVERITY() AS [Error_Severity],
            ERROR_PROCEDURE() AS [Error_Procedure];

    THROW;

END CATCH