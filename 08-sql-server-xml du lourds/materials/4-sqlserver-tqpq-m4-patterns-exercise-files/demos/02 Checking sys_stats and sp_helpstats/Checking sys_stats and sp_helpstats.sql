USE [Credit];
GO

-- Checking statistics for a specific table
EXEC dbo.sp_helpstats 'charge';

-- Using the catalog view
SELECT  object_name([object_id]) AS [object_name],
		[object_id],
        [name],
        [stats_id],
        [auto_created],
        [user_created],
        [no_recompute]
FROM    sys.[stats] AS s
WHERE object_name([object_id]) = 'charge';

-- Confirming indexes for a table
EXEC dbo.sp_helpindex 'charge';