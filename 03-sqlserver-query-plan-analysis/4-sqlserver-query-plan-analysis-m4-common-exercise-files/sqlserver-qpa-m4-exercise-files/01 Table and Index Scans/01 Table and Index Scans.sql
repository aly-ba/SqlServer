USE Credit;
GO

-- Creating a demo table
SELECT  [category_no],
        [category_desc],
        [category_code]
INTO dbo.[caregory_demo]
FROM dbo.[category] AS c;
GO

-- Table Scan
SELECT [category_desc]
FROM dbo.[caregory_demo];
GO

-- Create a clustered index
CREATE UNIQUE CLUSTERED INDEX category_demo_category_no ON 
	dbo.[caregory_demo]( [category_no]);
GO

-- Index Scan
SELECT [category_desc]
FROM dbo.[caregory_demo];
GO

-- Cleanup
DROP TABLE dbo.[caregory_demo];
GO
