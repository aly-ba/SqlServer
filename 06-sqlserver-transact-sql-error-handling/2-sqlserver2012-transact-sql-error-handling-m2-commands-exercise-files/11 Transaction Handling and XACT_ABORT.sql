-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

USE [Credit]
GO

-- Assuming SET IMPLICIT_TRANSACTIONS is OFF
-- Which rows get inserted?
SET IDENTITY_INSERT [dbo].[category] ON;

INSERT  INTO [dbo].[category]
        ([category_no],
         [category_desc],
         [category_code])
VALUES  (99,
         'Entertainment',
         'ET');

INSERT  INTO [dbo].[category]
        ([category_no],
         [category_desc],
         [category_code])
VALUES  (1,
         'Travel',
         '');

SET IDENTITY_INSERT [dbo].[category] OFF;
GO

SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    [dbo].[category] AS c;



-- Which rows get inserted for this explicit transaction?
BEGIN TRANSACTION;

SET IDENTITY_INSERT [dbo].[category] ON;

INSERT  INTO [dbo].[category]
        ([category_no],
         [category_desc],
         [category_code])
VALUES  (100,
         'Vacation',
         'VC');

INSERT  INTO [dbo].[category]
        ([category_no],
         [category_desc],
         [category_code])
VALUES  (1,
         'Travel',
         '');

SET IDENTITY_INSERT [dbo].[category] OFF;

COMMIT TRANSACTION;
GO

-- 100 still got inserted
SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    [dbo].[category] AS c;



-- With SET XACT_ABORT?
SET XACT_ABORT ON;
BEGIN TRANSACTION;

SET IDENTITY_INSERT [dbo].[category] ON;

INSERT  INTO [dbo].[category]
        ([category_no],
         [category_desc],
         [category_code])
VALUES  (200,
         'Finance',
         'FN');

INSERT  INTO [dbo].[category]
        ([category_no],
         [category_desc],
         [category_code])
VALUES  (1,
         'Travel',
         '');

SET IDENTITY_INSERT [dbo].[category] OFF;

COMMIT TRANSACTION;
GO

-- 200 was NOT inserted
SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    [dbo].[category] AS c;



