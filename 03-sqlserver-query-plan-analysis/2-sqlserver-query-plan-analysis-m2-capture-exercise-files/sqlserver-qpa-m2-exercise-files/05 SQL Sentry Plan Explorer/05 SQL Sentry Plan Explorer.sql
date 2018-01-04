USE [Credit];
GO

-- Sample query
SELECT  [member].[member_no],
        [member].[lastname],
        [member].[firstname],
        [member].[middleinitial],
        [corporation].[corp_no],
        [corporation].[corp_name]
FROM    [dbo].[member]
INNER JOIN [dbo].[corporation]
        ON [corporation].[corp_no] = [member].[corp_no];
GO