USE Credit;
GO

IF OBJECT_ID('cdc_lsn_tracking') IS NOT NULL
BEGIN
	DROP TABLE dbo.cdc_lsn_tracking;
END
GO

CREATE TABLE dbo.cdc_lsn_tracking
( capture_instance sysname,
  last_processed_lsn binary(10) )
GO

CREATE UNIQUE CLUSTERED INDEX UX_cdc_lsn_tracking ON dbo.cdc_lsn_tracking (capture_instance)
GO


IF OBJECT_ID('dbo.GetCDCProcessingRange') IS NOT NULL
BEGIN
	DROP PROCEDURE dbo.GetCDCProcessingRange;
END
GO

-- Process using dynamic sql for more flexibility
CREATE PROCEDURE dbo.GetCDCProcessingRange (@capture_instance sysname, @from_lsn binary(10) OUTPUT, @to_lsn binary(10) OUTPUT)
AS
BEGIN
	-- Validate that the capture_instance exists and raise an error if not
	IF NOT EXISTS (SELECT * FROM cdc.change_tables WHERE capture_instance = @capture_instance)
	BEGIN
		RAISERROR('The specified capture_instance is valid for the current cdc_configuration', 16, 1);
		RETURN;
	END

	-- Check if the capture instance exists in the tracking table and insert it if not
	IF NOT EXISTS (SELECT capture_instance FROM dbo.cdc_lsn_tracking WHERE capture_instance = @capture_instance)
	BEGIN
		INSERT INTO dbo.cdc_lsn_tracking (capture_instance) VALUES (@capture_instance);
	END

	-- Get the current min LSN for the capture instance
	SELECT	@from_lsn =  ISNULL(last_processed_lsn, sys.fn_cdc_get_min_lsn(@capture_instance)),
			-- Decrement the max lsn to limit our processing range
			@to_lsn =  sys.fn_cdc_decrement_lsn(sys.fn_cdc_get_max_lsn())
	FROM dbo.cdc_lsn_tracking
	WHERE capture_instance = @capture_instance;



END
GO


-- Get the current min LSN for the capture instance
DECLARE	@from_lsn binary(10),
		@to_lsn binary(10);

EXECUTE dbo.GetCDCProcessingRange @capture_instance = N'dbo_charge', @from_lsn = @from_lsn OUTPUT, @to_lsn = @to_lsn OUTPUT;

SELECT @from_lsn AS from_lsn, @to_lsn AS to_lsn;

-- Do processing of records -- TVF usage explained in next slide and demo


-- Update the lsn tracking table to reflect the last processed transaction lsn from the max LSN
UPDATE dbo.cdc_lsn_tracking
SET last_processed_lsn = @to_lsn
WHERE capture_instance = N'dbo_charge';
GO

-- Perform an update to one of the captured charges
UPDATE dbo.charge
SET charge_amt = 4622.00
WHERE charge_no = 2000001;
GO

-- Get the current min LSN for the capture instance
DECLARE	@from_lsn binary(10),
		@to_lsn binary(10);

EXECUTE dbo.GetCDCProcessingRange @capture_instance = N'dbo_charge', @from_lsn = @from_lsn OUTPUT, @to_lsn = @to_lsn OUTPUT;

SELECT @from_lsn AS from_lsn, @to_lsn AS to_lsn;

-- Do processing of records -- TVF usage explained in next slide and demo


-- Update the lsn tracking table to reflect the last processed transaction lsn from the max LSN
UPDATE dbo.cdc_lsn_tracking
SET last_processed_lsn = @to_lsn
WHERE capture_instance = N'dbo_charge';
GO



