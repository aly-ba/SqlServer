USE [Credit];
GO

-- Show actual execution plan
DECLARE @charge TABLE
(
 [charge_no] INT NOT NULL,
 [member_no] INT NOT NULL,
 [provider_no] INT NOT NULL,
 [category_no] INT NOT NULL
);

INSERT  @charge
        ([charge_no],
         [member_no],
         [provider_no],
         [category_no])
SELECT  [c].[charge_no],
        [c].[member_no],
        [c].[provider_no],
        [c].[category_no]
FROM    [dbo].[charge] AS c;

SELECT  [member].[member_no],
        [member].[lastname],
        [member].[firstname],
        [region].[region_no],
        [region].[region_name],
        [provider].[provider_name],
        [category].[category_desc],
        [charge].[charge_no]
FROM    @charge AS [charge]
INNER JOIN [dbo].[member]
        ON [member].[member_no] = [charge].[member_no]
INNER JOIN [dbo].[provider]
        ON [provider].[provider_no] = [charge].[provider_no]
INNER JOIN [dbo].[region]
        ON [region].[region_no] = [member].[region_no]
INNER JOIN [dbo].[category]
        ON [category].[category_no] = [charge].[category_no];

-- Compare this to using a temporary table
CREATE TABLE #charge
(
 [charge_no] INT NOT NULL,
 [member_no] INT NOT NULL,
 [provider_no] INT NOT NULL,
 [category_no] INT NOT NULL
);

INSERT  #charge
        ([charge_no],
         [member_no],
         [provider_no],
         [category_no])
SELECT  [c].[charge_no],
        [c].[member_no],
        [c].[provider_no],
        [c].[category_no]
FROM    [dbo].[charge] AS c;

SELECT  [member].[member_no],
        [member].[lastname],
        [member].[firstname],
        [region].[region_no],
        [region].[region_name],
        [provider].[provider_name],
        [category].[category_desc],
        [charge].[charge_no]
FROM    #charge AS [charge]
INNER JOIN [dbo].[member]
        ON [member].[member_no] = [charge].[member_no]
INNER JOIN [dbo].[provider]
        ON [provider].[provider_no] = [charge].[provider_no]
INNER JOIN [dbo].[region]
        ON [region].[region_no] = [member].[region_no]
INNER JOIN [dbo].[category]
        ON [category].[category_no] = [charge].[category_no];