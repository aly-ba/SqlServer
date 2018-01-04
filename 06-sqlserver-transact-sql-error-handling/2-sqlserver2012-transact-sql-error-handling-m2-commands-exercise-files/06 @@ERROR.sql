-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

-- Custom error message, severity 16
RAISERROR ('Sample error', 16, 1);
PRINT @@ERROR;
GO

-- Custom error message, severity 10, any error number?
RAISERROR ('Sample error', 10, 1);
PRINT @@ERROR;
GO

-- @@ERROR lifecycle and preservation
SELECT 1/0;
IF @@ERROR > 0
	-- Returns 0 if the previous statement encountered no errors
	PRINT @@ERROR;
GO

-- @@ERROR lifecycle and preservation comparison
SELECT 1/0;
DECLARE @Error INT = @@ERROR;
IF @Error > 0
	PRINT @Error;
GO