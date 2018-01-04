USE [Credit];
GO

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

BEGIN TRAN
	
UPDATE  [dbo].[member]
SET     [member].[lastname] = 'Zuckerton'
WHERE   [member].[member_no] = 104;

-- Don't execute until after demo
ROLLBACK TRAN
GO