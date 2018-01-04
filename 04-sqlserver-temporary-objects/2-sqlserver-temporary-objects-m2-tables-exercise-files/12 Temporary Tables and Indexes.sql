-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

-- We can have indexes created along with CREATE TABLE
CREATE TABLE #charge(
	[charge_no] INT PRIMARY KEY CLUSTERED,
	[member_no] INT NOT NULL,
	[provider_no] INT NOT NULL,
	[category_no] INT NOT NULL,
	[charge_dt] [datetime] NOT NULL,
	[charge_amt] [money] NOT NULL,
	[statement_no] INT NOT NULL UNIQUE NONCLUSTERED,
	[charge_code] CHAR(2) NOT NULL);
GO

EXEC [tempdb].[sys].[sp_helpindex] #charge;
GO

-- CREATE INDEX example
CREATE INDEX [tmp_charge_charge_amt] ON #charge ([charge_amt]);
GO

EXEC [tempdb].[sys].[sp_helpindex] #charge;
GO


-- Cleanup
DROP TABLE [#charge];
GO
