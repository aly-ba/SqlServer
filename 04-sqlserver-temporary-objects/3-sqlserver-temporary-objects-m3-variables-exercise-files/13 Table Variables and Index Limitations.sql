-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

-- We can have indexes created along with CREATE TABLE
DECLARE @charge TABLE (
	[charge_no] INT PRIMARY KEY CLUSTERED,
	[member_no] INT NOT NULL,
	[provider_no] INT NOT NULL,
	[category_no] INT NOT NULL,
	[charge_dt] [datetime] NOT NULL,
	[charge_amt] [money] NOT NULL,
	[statement_no] INT NOT NULL UNIQUE NONCLUSTERED,
	[charge_code] CHAR(2) NOT NULL);


-- Does this work?
CREATE INDEX [tmp_charge_charge_amt] ON @charge ([charge_amt]);
GO

-- Note: SQL Server 2014 changes this story by allowing inline
-- non-unique clustered and nonclustered index definitions
