-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

USE [Credit]
GO

-- THROW vs. RAISERROR with SET XACT_ABORT ON
-- Both INSERTs are "okay" but...
SET XACT_ABORT ON;
BEGIN TRANSACTION;

SET IDENTITY_INSERT [dbo].[category] ON;

INSERT  INTO [dbo].[category]
        ([category_no],
         [category_desc],
         [category_code])
VALUES  (202,
         'Marketing',
         'MK');

RAISERROR ('Arbitrary RAISERROR.', 16, 1);

INSERT  INTO [dbo].[category]
        ([category_no],
         [category_desc],
         [category_code])
VALUES  (203,
         'Legal',
         'LE');

SET IDENTITY_INSERT [dbo].[category] OFF;

COMMIT TRANSACTION;
GO



-- Both 202 and 203 were still inserted, even with a RAISERROR
SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    [dbo].[category] AS c;



-- Now compare with THROW

-- Quick cleanup of rows that we'll try to re-insert later
DELETE  [dbo].[category]
WHERE   [category_no] IN (202, 203);
GO

SET XACT_ABORT ON;
BEGIN TRANSACTION;

SET IDENTITY_INSERT [dbo].[category] ON;

INSERT  INTO [dbo].[category]
        ([category_no],
         [category_desc],
         [category_code])
VALUES  (202,
         'Marketing',
         'MK');

THROW 50001, 'Arbitrary THROW.', 1;

INSERT  INTO [dbo].[category]
        ([category_no],
         [category_desc],
         [category_code])
VALUES  (203,
         'Legal',
         'LE');

SET IDENTITY_INSERT [dbo].[category] OFF;

COMMIT TRANSACTION;
GO




-- Neither 202 and 203 were still inserted
SELECT  [category_no],
        [category_desc],
        [category_code]
FROM    [dbo].[category] AS c;



