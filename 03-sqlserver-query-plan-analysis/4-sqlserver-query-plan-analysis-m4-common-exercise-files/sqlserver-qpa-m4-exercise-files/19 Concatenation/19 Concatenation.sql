USE Credit;
GO

SELECT  [member].[member_no],
        [member].[lastname],
        [member].[firstname],
        [member].[middleinitial],
        [member].[street],
        [member].[city],
        [member].[state_prov],
        [member].[country],
        [member].[mail_code]
FROM    [dbo].[member]
UNION ALL
SELECT  [member2].[member_no],
        [member2].[lastname],
        [member2].[firstname],
        [member2].[middleinitial],
        [member2].[street],
        [member2].[city],
        [member2].[state_prov],
        [member2].[country],
        [member2].[mail_code]
FROM    [dbo].[member2];

-- UNION and not UNION ALL?
SELECT  [member].[member_no],
        [member].[lastname],
        [member].[firstname],
        [member].[middleinitial],
        [member].[street],
        [member].[city],
        [member].[state_prov],
        [member].[country],
        [member].[mail_code]
FROM    [dbo].[member]
UNION
SELECT  [member2].[member_no],
        [member2].[lastname],
        [member2].[firstname],
        [member2].[middleinitial],
        [member2].[street],
        [member2].[city],
        [member2].[state_prov],
        [member2].[country],
        [member2].[mail_code]
FROM    [dbo].[member2];