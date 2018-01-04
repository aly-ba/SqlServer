-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

USE [Credit]
GO

-- Explicit transaction + TRY CATCH
BEGIN TRY
    BEGIN TRANSACTION;

    SET IDENTITY_INSERT [dbo].[category] ON;

    INSERT  INTO [dbo].[category]
            ([category_no],
             [category_desc],
             [category_code])
    VALUES  (101,
             'Human Resources',
             'HR');

    INSERT  INTO [dbo].[category]
            ([category_no],
             [category_desc],
             [category_code])
    VALUES  (1,
             'Travel',
             '');

    SET IDENTITY_INSERT [dbo].[category] OFF;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH

	-- Checking open transaction counts
    IF @@TRANCOUNT <> 0 
        ROLLBACK TRANSACTION;

    THROW;

END CATCH

GO

-- Was 101 inserted?
SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    [dbo].[category] AS c;



