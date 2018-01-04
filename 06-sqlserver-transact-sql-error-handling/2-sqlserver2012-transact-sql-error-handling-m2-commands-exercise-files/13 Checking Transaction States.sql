-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

USE [Credit]
GO


-- Checking for transaction states that may or may not be able to be committed 
BEGIN TRANSACTION; 

-- What is the value?
SELECT  XACT_STATE();

SET IDENTITY_INSERT [dbo].[category] ON;

INSERT  INTO [dbo].[category]
        ([category_no],
         [category_desc],
         [category_code])
VALUES  (202,
         'Marketing',
         'MK');

SET IDENTITY_INSERT [dbo].[category] OFF;

-- What is the value?
SELECT  XACT_STATE();

-- I can COMMIT or ROLLBACK now at this point
ROLLBACK TRANSACTION;

-- What is the value?
SELECT  XACT_STATE();

-- What about an uncommitted transaction state?
SET XACT_ABORT OFF;
 -- Notice this is OFF
BEGIN TRY
    BEGIN TRANSACTION;

	SET IDENTITY_INSERT [dbo].[category] ON;

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

	SET IDENTITY_INSERT [dbo].[category] OFF;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH

	-- Transactions that cannot be committed
    IF XACT_STATE() = -1 
        BEGIN
            ROLLBACK TRANSACTION;
        END
	
	-- If you still wanted any statements that ran successfully to commit

    IF XACT_STATE() = 1 
        BEGIN
            COMMIT TRANSACTION;
        END
		   

END CATCH

-- What got inserted?
SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    [dbo].[category] AS c;


-- Cleanup
DELETE  [dbo].[category]
WHERE   [category_no] = 202;
GO


-- What if XACT_ABORT is ON?
SET XACT_ABORT ON;
 -- Notice this is now ON
BEGIN TRY
    BEGIN TRANSACTION;

	SET IDENTITY_INSERT [dbo].[category] ON;

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

	SET IDENTITY_INSERT [dbo].[category] OFF;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH

	-- Transactions that cannot be committed
    IF XACT_STATE() = -1 
        BEGIN
            ROLLBACK TRANSACTION;
        END
	
	-- If you still wanted any statements that ran successfully to commit

    IF XACT_STATE() = 1 
        BEGIN
            COMMIT TRANSACTION;
        END
		   

END CATCH

-- What got inserted?
SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    [dbo].[category] AS c;