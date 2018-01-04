-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

USE [Credit]
GO


-- Example of a doomed transaction
SET XACT_ABORT ON; 
BEGIN TRY
    BEGIN TRANSACTION;

	-- This table already exists, so this will not succeed
    CREATE TABLE [dbo].[category]
    (
     [category_no] [dbo].[numeric_id] IDENTITY(1, 1)
                                      NOT NULL,
     [category_desc] [dbo].[normstring] NOT NULL,
     [category_code] [dbo].[status_code] NOT NULL
    );

    INSERT  INTO [dbo].[category]
            ([category_no],
             [category_desc],
             [category_code])
    VALUES  (202,
             'Marketing',
             'MK');

    INSERT  INTO [dbo].[category]
            ([category_no],
             [category_desc],
             [category_code])
    VALUES  (1,
             'Travel',
             '');

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH

	-- Transactions that cannot be committed
    IF XACT_STATE() = -1 
        BEGIN
            SELECT  XACT_STATE();      
            PRINT 'Doomed'
            COMMIT TRANSACTION;  -- This won't work!
        END
	
	-- If you still wanted any statements that ran successfully to commit

    IF XACT_STATE() = 1 
        BEGIN
            COMMIT TRANSACTION;
        END
		   

END CATCH

-- Try the doomed transaction again with ROLLBACK
SET XACT_ABORT ON; 
BEGIN TRY
    BEGIN TRANSACTION;

	-- This table already exists, so this will not succeed
    CREATE TABLE [dbo].[category]
    (
     [category_no] [dbo].[numeric_id] IDENTITY(1, 1)
                                      NOT NULL,
     [category_desc] [dbo].[normstring] NOT NULL,
     [category_code] [dbo].[status_code] NOT NULL
    );

    INSERT  INTO [dbo].[category]
            ([category_no],
             [category_desc],
             [category_code])
    VALUES  (202,
             'Marketing',
             'MK');

    INSERT  INTO [dbo].[category]
            ([category_no],
             [category_desc],
             [category_code])
    VALUES  (1,
             'Travel',
             '');

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH

	-- Transactions that cannot be committed
    IF XACT_STATE() = -1 
        BEGIN
            SELECT  XACT_STATE();      
            PRINT 'Doomed'
            ROLLBACK TRANSACTION; 
        END
	
	-- If you still wanted any statements that ran successfully to commit

    IF XACT_STATE() = 1 
        BEGIN
            COMMIT TRANSACTION;
        END
		   

END CATCH

