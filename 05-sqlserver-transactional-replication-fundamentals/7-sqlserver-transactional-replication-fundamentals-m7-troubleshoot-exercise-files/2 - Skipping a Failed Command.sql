:CONNECT SQL2K12-SVR3
USE [CreditReporting];

DELETE dbo.[category]
WHERE   [category_no] = 8; 
GO


:CONNECT SQL2K12-SVR1
USE [Credit];

UPDATE  dbo.[category]
SET [category_desc] = 'misc_mod'
WHERE   [category_no] = 8; 
GO
