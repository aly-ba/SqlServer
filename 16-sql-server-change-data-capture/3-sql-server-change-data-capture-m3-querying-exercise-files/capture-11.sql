USE Credit;
GO

-- Get capture instance name
SELECT *
FROM cdc.change_tables;
GO

-- Load some example charges
EXECUTE dbo.load_charges @target_charge_count = 2;
GO

-- Set the capture instance to lookup LSNs for
DECLARE @capture_instance sysname = 'dbo_charge';

-- Get the current min LSN for the capture instance and the current max LSN
DECLARE	@from_lsn binary(10) = sys.fn_cdc_get_min_lsn(@capture_instance),
		@to_lsn binary(10) = sys.fn_cdc_get_max_lsn();

SELECT @From_lsn, @to_lsn

-- Get all changes from the capture instance within the LSN range
SELECT * 
FROM cdc.fn_cdc_get_all_changes_dbo_charge (@from_lsn, @to_lsn, N'all');
GO

-- Perform an update to one of the captured charges
UPDATE dbo.charge
SET charge_amt = 4621.00
WHERE charge_no = 2000001;
GO

-- Set the capture instance to lookup LSNs for
DECLARE @capture_instance sysname = 'dbo_charge';

-- Get the current min LSN for the capture instance and the current max LSN
DECLARE	@from_lsn binary(10) = sys.fn_cdc_get_min_lsn(@capture_instance),
		@to_lsn binary(10) = sys.fn_cdc_get_max_lsn();

-- Get all changes fro the capture instance within the LSN range
SELECT 
	[__$start_lsn],
	[__$seqval],
	[__$operation],
	CASE [__$operation] 
		WHEN 1 THEN 'Delete'
		WHEN 2 THEN 'INSERT'
		WHEN 3 THEN 'Update From Value'
		WHEN 4 THEN 'Update To Value'
	END AS [operation],
	[__$update_mask],
	charge_no,
	member_no,
	provider_no,
	category_no,
	charge_dt,
	charge_amt,
	statement_no,
	charge_code
FROM cdc.fn_cdc_get_all_changes_dbo_charge (@from_lsn, @to_lsn, N'all');


-- Get all changes fro the capture instance within the LSN range
SELECT 
	[__$start_lsn],
	[__$seqval],
	[__$operation],
	CASE [__$operation] 
		WHEN 1 THEN 'Delete'
		WHEN 2 THEN 'INSERT'
		WHEN 3 THEN 'Update From Value'
		WHEN 4 THEN 'Update To Value'
	END AS [operation],
	[__$update_mask],
	charge_no,
	member_no,
	provider_no,
	category_no,
	charge_dt,
	charge_amt,
	statement_no,
	charge_code
FROM cdc.fn_cdc_get_all_changes_dbo_charge (@from_lsn, @to_lsn, N'all update old');
GO


-- Getting NET changes NOTE! This has limited column list to show how to set up the table capture
-- Set the capture instance to lookup LSNs for
DECLARE @capture_instance sysname = 'dbo_charge_2';

-- Get the current min LSN for the capture instance and the current max LSN
DECLARE	@from_lsn binary(10) = sys.fn_cdc_get_min_lsn(@capture_instance),
		@to_lsn binary(10) = sys.fn_cdc_get_max_lsn();

-- Get all changes fro the capture instance within the LSN range
SELECT 
	[__$start_lsn],
	[__$operation],
	CASE [__$operation] 
		WHEN 1 THEN 'Delete'
		WHEN 2 THEN 'INSERT'
		WHEN 3 THEN 'Update From Value'
		WHEN 4 THEN 'Update To Value'
	END AS [operation],
	[__$update_mask],
	charge_no,
	charge_amt,
	charge_code
FROM cdc.fn_cdc_get_net_changes_dbo_charge_2 (@from_lsn, @to_lsn, N'all');
GO


-- Getting transaction times for change table entries
-- Set the capture instance to lookup LSNs for
DECLARE @capture_instance sysname = 'dbo_charge';

-- Get the current min LSN for the capture instance and the current max LSN
DECLARE	@from_lsn binary(10) = sys.fn_cdc_get_min_lsn(@capture_instance),
		@to_lsn binary(10) = sys.fn_cdc_get_max_lsn();

-- Get all changes fro the capture instance within the LSN range
SELECT 
	[__$start_lsn],
	[__$seqval],
	[__$operation],
	CASE [__$operation] 
		WHEN 1 THEN 'Delete'
		WHEN 2 THEN 'INSERT'
		WHEN 3 THEN 'Update From Value'
		WHEN 4 THEN 'Update To Value'
	END AS [operation],
	[__$update_mask],
	charge_no,
	member_no,
	provider_no,
	category_no,
	charge_dt,
	charge_amt,
	statement_no,
	charge_code,
	sys.fn_cdc_map_lsn_to_time([__$start_lsn]) AS [trans_time]
FROM cdc.fn_cdc_get_all_changes_dbo_charge (@from_lsn, @to_lsn, N'all update old');
GO


