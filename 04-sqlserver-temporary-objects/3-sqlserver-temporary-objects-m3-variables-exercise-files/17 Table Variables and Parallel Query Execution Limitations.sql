-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

-- Let's look at the actual execution plan of this SELECT

SELECT  [m].[firstname],
        [m].[lastname],
        [c].[charge_no],
        [c].[charge_dt],
        SUM([c].[charge_amt]) AS [max_amount]
FROM    [dbo].[member] AS [m]
INNER JOIN [dbo].[charge] AS [c]
        ON [m].[member_no] = [c].[member_no]
WHERE   [c].[charge_amt] > 1000.00 AND
        [m].[region_no] = 2
GROUP BY [m].[firstname],
        [m].[lastname],
        [c].[charge_no],
        [c].[charge_dt]
HAVING  MAX([c].[charge_amt]) > 2000.00;
GO


-- Table variable to "capture" the results
-- Examine the query execution plan afterwards...

DECLARE @ResultSet TABLE
(
 [firstname] [varchar](15) NOT NULL,
 [lastname] [varchar](15) NOT NULL,
 [charge_no] [int] NOT NULL,
 [charge_dt] [datetime] NOT NULL,
 [max_amount] [money] NULL
);

INSERT  @ResultSet
        ([firstname],
         [lastname],
         [charge_no],
         [charge_dt],
         [max_amount])
        SELECT  [m].[firstname],
        [m].[lastname],
        [c].[charge_no],
        [c].[charge_dt],
        SUM([c].[charge_amt]) AS [max_amount]
		FROM    [dbo].[member] AS [m]
		INNER JOIN [dbo].[charge] AS [c]
				ON [m].[member_no] = [c].[member_no]
		WHERE   [c].[charge_amt] > 1000.00 AND
				[m].[region_no] = 2
		GROUP BY [m].[firstname],
				[m].[lastname],
				[c].[charge_no],
				[c].[charge_dt]
		HAVING  MAX([c].[charge_amt]) > 2000.00;
GO


