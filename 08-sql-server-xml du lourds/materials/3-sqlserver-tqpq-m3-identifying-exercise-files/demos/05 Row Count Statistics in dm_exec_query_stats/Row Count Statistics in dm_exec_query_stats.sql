USE [Credit];
GO

-- Clearing procedure cache on test environment
DBCC FREEPROCCACHE;
GO

-- Query 1 = No CE issue
SELECT	region.region_name,
		member.lastname,
		member.firstname,
		member.member_no
FROM dbo.member
INNER JOIN dbo.region ON
    region.region_no = member.region_no
WHERE region.region_no = 9;
GO

-- Query 2 = Final rowcount CE issue
DECLARE @Column INT = 2, 
        @Value  INT = 10;

SELECT  [member].[member_no] , 
        [member].[street] , 
        [member].[city] , 
        [charge].[charge_no] , 
        [charge].[provider_no] , 
        [charge].[category_no] , 
        [charge].[charge_dt] , 
        [charge].[charge_amt] , 
        [charge].[charge_code] 
FROM    [dbo].[charge] 
        INNER JOIN [dbo].[member] 
        ON [member].[member_no] = [charge].[member_no] 
WHERE   CHOOSE(@Column, 
               [charge].[provider_no], 
               [charge].[category_no] ) = @Value; 
GO 

-- Query 3 = Leaf-level skew, but no CE at root
SELECT TOP (1000)
        [member].[member_no],
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
INNER JOIN [dbo].[charge]
        ON [provider].[provider_no] = [charge].[provider_no]
INNER JOIN [dbo].[member]
        ON [member].[member_no] = [charge].[member_no]
INNER JOIN [dbo].[region]
        ON [region].[region_no] = [member].[region_no]
INNER JOIN [dbo].[category]
        ON [category].[category_no] = [charge].[category_no];
GO

-- Checking estimated rows (from the plan) versus actual rows
SELECT  t.[text],
        p.[query_plan],
        s.[last_execution_time],
        p.[query_plan].value('(//@EstimateRows)[1]', 'varchar(128)') AS [estimated_rows],
        s.[last_rows]
FROM    sys.[dm_exec_query_stats] AS [s]
CROSS APPLY sys.[dm_exec_sql_text](sql_handle) AS [t]
CROSS APPLY sys.[dm_exec_query_plan](plan_handle) AS [p]
WHERE   DATEDIFF(mi, s.[last_execution_time], GETDATE()) < 1
GO



