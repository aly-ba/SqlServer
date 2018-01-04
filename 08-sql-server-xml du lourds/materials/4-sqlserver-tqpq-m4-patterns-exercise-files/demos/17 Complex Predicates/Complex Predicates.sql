USE [Credit];
GO

SELECT  [member].[member_no],
        [member].[lastname],
        [member].[firstname],
        [charge].[charge_no],
        [charge].[provider_no],
        [charge].[category_no],
        [charge].[charge_dt],
        [charge].[charge_amt],
        [charge].[charge_code]
FROM    [dbo].[charge]
INNER JOIN [dbo].[member]
        ON [member].[member_no] = [charge].[member_no]
WHERE   LEFT([member].[firstname], 15) + ' ' + 
		LEFT([member].[lastname], 15) + '' = 'VKZEJQXGGPERFL XAVIER'
OPTION  (RECOMPILE);
GO

SELECT  [member].[member_no],
        [member].[lastname],
        [member].[firstname],
        [charge].[charge_no],
        [charge].[provider_no],
        [charge].[category_no],
        [charge].[charge_dt],
        [charge].[charge_amt],
        [charge].[charge_code]
FROM    [dbo].[charge]
INNER JOIN [dbo].[member]
        ON [member].[member_no] = [charge].[member_no]
WHERE   [member].[firstname] = 'VKZEJQXGGPERFL' AND
        [member].[lastname] = 'XAVIER'
OPTION  (RECOMPILE);
GO