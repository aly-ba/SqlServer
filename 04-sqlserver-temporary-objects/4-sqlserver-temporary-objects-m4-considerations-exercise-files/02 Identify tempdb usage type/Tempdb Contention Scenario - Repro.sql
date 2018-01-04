-- Adapted from Jonathan Kehayias
-- Source: http://www.simple-talk.com/sql/database-administration/optimizing-tempdb-configuration-with-sql-server-2012-extended-events/
USE [Credit];
GO

SET NOCOUNT ON;
GO

WHILE 1 = 1 
    BEGIN

        IF OBJECT_ID('tempdb..#charge') IS NOT NULL 
            BEGIN
                DROP TABLE #charge;
            END

	 CREATE TABLE #charge
	(
	 [charge_no] INT PRIMARY KEY CLUSTERED
					 IDENTITY(1, 1),
	 [member_no] INT NOT NULL,
	 [provider_no] INT NOT NULL,
	 [category_no] INT NOT NULL,
	 [charge_dt] [datetime] NOT NULL,
	 [charge_amt] [money] NOT NULL,
	 [statement_no] INT NOT NULL
						UNIQUE NONCLUSTERED,
	 [charge_code] CHAR(2) NOT NULL
	);


	INSERT  #charge
			([member_no],
			 [provider_no],
			 [category_no],
			 [charge_dt],
			 [charge_amt],
			 [statement_no],
			 [charge_code])
	SELECT [member_no],
			 [provider_no],
			 [category_no],
			 [charge_dt],
			 [charge_amt],
			 [statement_no],
			 [charge_code]
	FROM [Credit].[dbo].[charge];

    END 
GO