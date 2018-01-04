USE [Credit];
GO

-- "Complexity" via overlap / redundancy
-- Compare execution plans and overall IO
SET STATISTICS IO ON;
GO

SELECT  [basic_member].[member_no],
        [basic_member].[lastname],
        [basic_member].[firstname],
        [basic_member].[middleinitial],
        [basic_member].[street],
        [basic_member].[city],
        [basic_member].[state_prov],
        [basic_member].[mail_code],
        [basic_member].[phone_no],
        [basic_member].[region_no],
        [basic_member].[expr_dt],
        [basic_member].[member_code]
FROM    [dbo].[basic_member];

SELECT  [basic_member].[member_no],
        [basic_member].[lastname],
        [basic_member].[firstname],
        [basic_member].[middleinitial],
        [basic_member].[street],
        [basic_member].[city],
        [basic_member].[state_prov],
        [basic_member].[mail_code],
        [basic_member].[phone_no],
        [basic_member].[region_no],
        [basic_member].[expr_dt],
        [basic_member].[member_code]
FROM    [dbo].[basic_member]
WHERE   [basic_member].[member_no] NOT IN 
(SELECT   [corp_member].[member_no]
 FROM     [dbo].[corp_member]);

SET STATISTICS IO OFF;

