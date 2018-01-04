-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

USE [Credit]
GO

-- Unhandled
IF OBJECT_ID('[dbo].[insert_explicit_category_unhandled]') IS NOT NULL 
    BEGIN
        DROP PROCEDURE [dbo].[insert_explicit_category_unhandled];
    END
GO

CREATE PROCEDURE [dbo].[insert_explicit_category_unhandled]
    @category_no INT,
    @category_desc VARCHAR(31),
    @category_code CHAR(2)
AS 
BEGIN TRANSACTION;
  
SET IDENTITY_INSERT [dbo].[category2] ON;

INSERT  INTO [dbo].[category2]
        ([category_no],
         [category_desc],
         [category_code])
VALUES  (@category_no,
         @category_desc,
         @category_code);

SET IDENTITY_INSERT [dbo].[category2] OFF;

COMMIT TRANSACTION;
GO

-- Unhandled example
EXEC [dbo].[insert_explicit_category_unhandled] 1, 'Travel', 'TRV';
GO

-- Create a demo stored procedure, handled, one TRY...CATCH
IF OBJECT_ID('[dbo].[insert_explicit_category]') IS NOT NULL 
    BEGIN
        DROP PROCEDURE [dbo].[insert_explicit_category];
    END
GO

CREATE PROCEDURE [dbo].[insert_explicit_category]
    @category_no INT,
    @category_desc VARCHAR(31),
    @category_code CHAR(2)
AS 

BEGIN TRY
    
    SET NOCOUNT ON;

    BEGIN TRANSACTION
  

    SET IDENTITY_INSERT [dbo].[category2] ON;

    INSERT  INTO [dbo].[category2]
            ([category_no],
             [category_desc],
             [category_code])
    VALUES  (@category_no,
             @category_desc,
             @category_code);

    SET IDENTITY_INSERT [dbo].[category2] OFF;

    COMMIT TRANSACTION
    
END TRY
BEGIN CATCH  

    IF @@TRANCOUNT <> 0 
        BEGIN
            ROLLBACK TRANSACTION
        END;   

    RAISERROR('Category2 was not created ahead of time by the ETL process.', 16, 1);

END CATCH     
	

GO

-- Calling the procedure outside of TRY...CATCH
EXEC [dbo].[insert_explicit_category] 1, 'Travel', 'TRV';



-- Nesting in BEGIN TRY block
BEGIN TRY
	
	-- My goal is to insert two rows into a category table
    EXEC [dbo].[insert_explicit_category] 1, 'Travel', 'TRV';
    EXEC [dbo].[insert_explicit_category] 2, 'Meals', 'MLS';

END TRY
BEGIN CATCH

    -- If the table doesn't exist, create it
    IF ERROR_MESSAGE() = 'Category2 was not created ahead of time by the ETL process.' 
        BEGIN
	
            SELECT  [category_no],
                    [category_desc],
                    [category_code]
            INTO    [dbo].[category2]
            FROM    [dbo].[category]
            WHERE   1 = 0;
	
        END  

	-- And then retry the two procedure calls
    EXEC [dbo].[insert_explicit_category] 1, 'Travel', 'TRV';
    EXEC [dbo].[insert_explicit_category] 2, 'Meals', 'MLS';

END CATCH
GO

SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    [dbo].[category2];
GO

-- Cleanup
DROP TABLE [dbo].[category2];