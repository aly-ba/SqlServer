USE Credit;
GO

SELECT * 
FROM cdc.lsn_time_mapping;

-- Find the mappings to capture instances being tracked
SELECT *, ROW_NUMBER() OVER (ORDER BY tran_begin_time) AS row_id
FROM cdc.lsn_time_mapping AS tm 
LEFT JOIN dbo.cdc_lsn_tracking AS lt 
	ON lt.capture_instance = 'dbo_charge' AND 
		sys.fn_cdc_increment_lsn(last_processed_lsn) = tm.start_lsn 

DECLARE @from_lsn binary(10) = 
DECLARE @capture_instance SYSNAME = 'dbo_charge';

EXECUTE sys.sp_cdc_cleanup_change_table 
	@capture_instance = @capture_instance, 
	@low_water_mark = @from_lsn,
	@threshold = 5000;


