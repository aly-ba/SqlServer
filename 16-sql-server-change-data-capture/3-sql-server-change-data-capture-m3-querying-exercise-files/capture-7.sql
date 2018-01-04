USE Credit;

-- Get capture instance name
SELECT *
FROM cdc.change_tables;

-- Set the capture instance to lookup LSNs for
DECLARE @capture_instance sysname = 'dbo_charge';

-- Get the current min LSN for the capture instance and the current max LSN
DECLARE	@from_lsn binary(10) = sys.fn_cdc_get_min_lsn(@capture_instance),
		@to_lsn binary(10) = sys.fn_cdc_get_max_lsn();

SELECT @from_lsn AS from_lsn, @to_lsn AS to_lsn;
GO


-- Get the current min LSN for the capture instance based on datetime
DECLARE	@from_lsn binary(10) = sys.fn_cdc_map_time_to_lsn('smallest greater than or equal', '2014-01-28 16:45:29.247'),
		@to_lsn binary(10) = sys.fn_cdc_get_max_lsn();

SELECT @from_lsn AS from_lsn, @to_lsn AS to_lsn;
GO
