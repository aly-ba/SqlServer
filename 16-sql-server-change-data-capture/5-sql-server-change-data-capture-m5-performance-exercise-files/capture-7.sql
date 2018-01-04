USE Credit;
GO


IF OBJECT_ID('trg_charge_audituser') IS NOT NULL
BEGIN
	DROP TRIGGER trg_charge_audituser;
END
GO

-- Create a trigger to automatically set this for any insert or update  - NOTE THIS IS NOT A GOOD IDEA!
CREATE TRIGGER trg_charge_audituser
ON dbo.charge
AFTER INSERT, UPDATE
AS
BEGIN

	UPDATE c 
	SET AuditUser = SYSTEM_USER
	FROM dbo.charge AS c
	INNER JOIN inserted AS i on c.charge_no = i.charge_no;

END
GO

-- Perform an update to one of the captured charges
UPDATE dbo.charge
SET charge_amt = 462.00
WHERE charge_no = 2000000;
GO


-- Set the capture instance to lookup LSNs for
DECLARE @capture_instance sysname = 'dbo_charge_2';

-- Get the current min LSN for the capture instance and the current max LSN
DECLARE	@from_lsn binary(10) = sys.fn_cdc_get_min_lsn(@capture_instance),
		@to_lsn binary(10) = sys.fn_cdc_get_max_lsn();

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
	AuditUser
FROM cdc.fn_cdc_get_all_changes_dbo_charge_2 (@from_lsn, @to_lsn, N'all');
GO




-- Set the capture instance to lookup LSNs for
DECLARE @capture_instance sysname = 'dbo_charge_2';

-- Get the current min LSN for the capture instance and the current max LSN
DECLARE	@from_lsn binary(10) = sys.fn_cdc_get_min_lsn(@capture_instance),
		@to_lsn binary(10) = sys.fn_cdc_get_max_lsn();

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
	AuditUser
FROM cdc.fn_cdc_get_all_changes_dbo_charge_2 (@from_lsn, @to_lsn, N'all update old');
GO