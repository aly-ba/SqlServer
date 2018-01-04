USE Credit;
GO

-- Let's look at the estimated plan
SELECT  [member].[member_no],
        [member].[lastname],
        [member].[firstname],
        [region].[region_no],
        [region].[region_name],
        [provider].[provider_name],
        [category].[category_desc],
        [charge].[charge_no],
        [charge].[provider_no],
        [charge].[category_no],
        [charge].[charge_dt],
        [charge].[charge_amt],
        [charge].[charge_code]
FROM    [dbo].[provider],
        [dbo].[member],
        [dbo].[region],
        [dbo].[category],
        [dbo].[charge]
WHERE   [member].[member_no] = [charge].[member_no] AND
        [region].[region_no] = [member].[region_no] AND
        [provider].[provider_no] = [charge].[provider_no] AND
        [category].[category_no] = [charge].[category_no];

-- Skewed statistics can often cause spills
-- We'll build in an under-estimate
UPDATE STATISTICS [dbo].[charge]
WITH ROWCOUNT = 100, PAGECOUNT = 10;

DBCC FREEPROCCACHE;

-- Compare memory estimated
-- Execute the plan with Profiler and Warnings
SELECT  [member].[member_no],
        [member].[lastname],
        [member].[firstname],
        [region].[region_no],
        [region].[region_name],
        [provider].[provider_name],
        [category].[category_desc],
        [charge].[charge_no],
        [charge].[provider_no],
        [charge].[category_no],
        [charge].[charge_dt],
        [charge].[charge_amt],
        [charge].[charge_code]
FROM    [dbo].[provider],
        [dbo].[member],
        [dbo].[region],
        [dbo].[category],
        [dbo].[charge]
WHERE   [member].[member_no] = [charge].[member_no] AND
        [region].[region_no] = [member].[region_no] AND
        [provider].[provider_no] = [charge].[provider_no] AND
        [category].[category_no] = [charge].[category_no]
OPTION  (HASH JOIN);