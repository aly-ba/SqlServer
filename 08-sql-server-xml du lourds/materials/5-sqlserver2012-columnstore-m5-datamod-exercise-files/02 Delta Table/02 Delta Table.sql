-- You can get the AdventureWorksDW2012 database used in these demos from http://bit.ly/9hBGub

USE [AdventureWorksDW2012];
GO

-- Create a demo "delta" table
SELECT TOP 1000 *
INTO dbo.[Delta_FactInternetSales]
FROM dbo.[FactInternetSales];
GO

-- Our delta table is read-writable
UPDATE dbo.[Delta_FactInternetSales]
SET [DueDate] = GETDATE();
GO

-- And we can join the two tables via UNION ALL
-- Note that * sometimes * UNION ALL can inhibit batch execution mode
WITH [FactInternetSales_Unified] AS
	(SELECT [DueDate], [SalesAmount]
	FROM dbo.[Delta_FactInternetSales]
	UNION ALL
	SELECT [DueDate], [SalesAmount]
	FROM dbo.[FactInternetSales]
	)
SELECT [DueDate],
	   SUM([SalesAmount]) AS [SalesAmount]
FROM [FactInternetSales_Unified]
GROUP BY [DueDate]
ORDER BY [DueDate];
GO

-- Demo cleanup
DROP TABLE dbo.[Delta_FactInternetSales];
GO

