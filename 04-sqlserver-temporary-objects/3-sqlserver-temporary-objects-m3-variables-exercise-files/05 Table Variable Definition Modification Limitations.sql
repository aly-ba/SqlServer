-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

DECLARE @charge TABLE(
	[charge_no] INT PRIMARY KEY CLUSTERED IDENTITY(1,1),
	[member_no] INT NOT NULL,
	[provider_no] INT NOT NULL,
	[category_no] INT NOT NULL,
	[charge_dt] [datetime] NOT NULL,
	[charge_amt] [money] NOT NULL,
	[statement_no] INT NOT NULL UNIQUE NONCLUSTERED,
	[charge_code] CHAR(2) NOT NULL);


-- Does this work?
ALTER TABLE @charge
ADD [etl_movement_flag] BIT NULL;
GO