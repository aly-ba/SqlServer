-- Estimated vs. Actual
USE [Credit];
GO

-- New functionality brings "creative" ways to skew CE
DECLARE @Column INT = 2,
    @Value INT = 10;
 
SELECT  [member].[member_no],
        [member].[street],
        [member].[city],
        [charge].[charge_no],
        [charge].[provider_no],
        [charge].[category_no],
        [charge].[charge_dt],
        [charge].[charge_amt],
        [charge].[charge_code]
FROM    [dbo].[charge]
INNER JOIN [dbo].[member]
        ON [member].[member_no] = [charge].[member_no]
WHERE   CHOOSE(@Column, [charge].[provider_no], [charge].[category_no]) = @Value;
GO

-- New functionality brings "creative" ways to skew CE
SET STATISTICS PROFILE ON;
GO


DECLARE @Column INT = 2,
    @Value INT = 10;
 
SELECT  [member].[member_no],
        [member].[street],
        [member].[city],
        [charge].[charge_no],
        [charge].[provider_no],
        [charge].[category_no],
        [charge].[charge_dt],
        [charge].[charge_amt],
        [charge].[charge_code]
FROM    [dbo].[charge]
INNER JOIN [dbo].[member]
        ON [member].[member_no] = [charge].[member_no]
WHERE   CHOOSE(@Column, [charge].[provider_no], [charge].[category_no]) = @Value;
GO

SET STATISTICS PROFILE OFF;
GO

