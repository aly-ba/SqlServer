
USE Credit;
GO

-- Show estimated plan
DELETE [dbo].[member]
WHERE [member_no] = 80;

-- FK references?
EXEC sp_help 'dbo.member';

