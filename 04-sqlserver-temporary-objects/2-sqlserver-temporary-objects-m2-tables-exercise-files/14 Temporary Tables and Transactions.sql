-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

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

-- Implicit transaction duration is for the duration of statement execution
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

-- Now let's see the duration for explicit transactions
BEGIN TRAN;

INSERT #charge
([member_no], [provider_no], [category_no], [charge_dt], 
[charge_amt], [statement_no], [charge_code])
VALUES
(8843, 484, 2, GETDATE(), 3263.00, 28843, 'CD');

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

-- Now let's roll back the transaction
ROLLBACK TRANSACTION;

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

-- Cleanup
DROP TABLE #charge;
GO