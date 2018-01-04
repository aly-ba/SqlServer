-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO



-- We can define IDENTITY columns for temporary tables
CREATE TABLE #charge(
	[charge_no] INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
	[member_no] INT NOT NULL,
	[provider_no] INT NOT NULL,
	[category_no] INT NOT NULL,
	[charge_dt] [datetime] NOT NULL,
	[charge_amt] [money] NOT NULL,
	[statement_no] INT NOT NULL UNIQUE NONCLUSTERED,
	[charge_code] CHAR(2) NOT NULL);
GO

-- Example INSERT
INSERT #charge
([member_no], [provider_no], [category_no], [charge_dt], 
[charge_amt], [statement_no], [charge_code])
VALUES
(8842, 484, 2, GETDATE(), 3263.00, 28842, 'CD');
GO

SELECT  [charge_no],
        [member_no],
        [provider_no],
        [category_no],
        [charge_dt],
        [charge_amt],
        [statement_no],
        [charge_code]
FROM #charge;
GO

-- As with a regular identity column, we can't do the following (by default)
INSERT #charge
([charge_no], [member_no], [provider_no], [category_no], [charge_dt], 
[charge_amt], [statement_no], [charge_code])
VALUES
(2, 8842, 484, 2, GETDATE(), 3263.00, 28843, 'CD');
GO


-- But we can also use IDENTITY INSERT
SET IDENTITY_INSERT [#charge] ON;
GO

-- Example INSERT
INSERT #charge
([charge_no], [member_no], [provider_no], [category_no], [charge_dt], 
[charge_amt], [statement_no], [charge_code])
VALUES
(2, 8842, 484, 2, GETDATE(), 3263.00, 28843, 'CD');
GO

SELECT  [charge_no],
        [member_no],
        [provider_no],
        [category_no],
        [charge_dt],
        [charge_amt],
        [statement_no],
        [charge_code]
FROM #charge;
GO

SET IDENTITY_INSERT [#charge] OFF;
GO


-- Cleanup
DROP TABLE #charge;
GO
