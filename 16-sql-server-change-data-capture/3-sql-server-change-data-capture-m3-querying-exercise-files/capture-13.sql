USE Credit
GO

-- OPEN PROFILER AND COMPARE READS OVERHEAD



-- Getting transaction times for change table entries
-- Set the capture instance to lookup LSNs for
DECLARE @capture_instance sysname = 'dbo_charge';

-- Get the current min LSN for the capture instance based on datetime
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
	sys.fn_cdc_has_column_changed ( 'dbo_charge','charge_amt' , [__$update_mask] ) AS charge_amt_changed,
	sys.fn_cdc_has_column_changed ( 'dbo_charge','provider_no' , [__$update_mask] ) AS provider_no_changed
FROM cdc.fn_cdc_get_all_changes_dbo_charge (@from_lsn, @to_lsn, N'all update old');
GO

-- Getting transaction times for change table entries
-- Set the capture instance to lookup LSNs for
DECLARE @capture_instance sysname = 'dbo_charge';

-- Get the current min LSN for the capture instance based on datetime
DECLARE	@from_lsn binary(10) = sys.fn_cdc_get_min_lsn(@capture_instance),
		@to_lsn binary(10) = sys.fn_cdc_get_max_lsn();

DECLARE @charge_amt_ordinal INT = sys.fn_cdc_get_column_ordinal(@capture_instance, 'charge_amt'),
		@provider_no_ordinal INT = sys.fn_cdc_get_column_ordinal(@capture_instance, 'provider_no')

-- Get all changes from the capture instance within the LSN range
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
	sys.fn_cdc_is_bit_set ( @charge_amt_ordinal, [__$update_mask] ) AS charge_amt_changed,
	sys.fn_cdc_is_bit_set ( @provider_no_ordinal, [__$update_mask] ) AS provider_no_changed
FROM cdc.fn_cdc_get_all_changes_dbo_charge (@from_lsn, @to_lsn, N'all update old');
GO
