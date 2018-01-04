USE [Credit];
GO

-- Let's look at the actual plan
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
FROM    [dbo].[provider]
INNER JOIN [dbo].[charge] ON 
	[provider].[provider_no] = [charge].[provider_no]
INNER JOIN [dbo].[member] ON
	[member].[member_no] = [charge].[member_no]
INNER JOIN [dbo].[region] ON
	[region].[region_no] = [member].[region_no]
INNER JOIN [dbo].[category] ON
	[category].[category_no] = [charge].[category_no];

-- Skewed statistics can often cause spills
-- We'll build in an under-estimate
UPDATE STATISTICS [dbo].[charge]
WITH ROWCOUNT = 100, PAGECOUNT = 10;
GO

-- Compare memory estimated
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
FROM    [dbo].[provider]
INNER JOIN [dbo].[charge] ON 
	[provider].[provider_no] = [charge].[provider_no]
INNER JOIN [dbo].[member] ON
	[member].[member_no] = [charge].[member_no]
INNER JOIN [dbo].[region] ON
	[region].[region_no] = [member].[region_no]
INNER JOIN [dbo].[category] ON
	[category].[category_no] = [charge].[category_no]
OPTION (HASH JOIN, RECOMPILE);

-- Cleanup
ALTER INDEX ALL ON charge REBUILD;

