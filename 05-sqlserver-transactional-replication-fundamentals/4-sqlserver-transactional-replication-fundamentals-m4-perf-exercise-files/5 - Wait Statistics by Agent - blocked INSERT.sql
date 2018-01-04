:CONNECT SQL2K12-SVR1
USE [Credit]

INSERT [dbo].[category]
([category_desc])
VALUES ('Latency example - wait stats');
GO

-- Cleanup
DELETE [category]
WHERE [category_desc] LIKE '%wait%';
GO