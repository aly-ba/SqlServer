USE Credit;
GO

-- Get the current job configuration values
EXECUTE sys.sp_cdc_help_jobs

-- Modify the capture job settings to default values
EXECUTE sys.sp_cdc_change_job 
	@job_type = N'capture',
    @maxscans = 10,
    @maxtrans = 500,
	@pollinginterval = 5;


-- Modify the capture job settings to increase the maxtrans to 5000 and decrease the pollinginterval to 1 second
-- This may reduce latency but also affect the transactions processed per second
EXECUTE sys.sp_cdc_change_job 
	@job_type = N'capture',
    @maxscans = 10,
    @maxtrans = 5000,
	@pollinginterval = 1;

-- Get the new job configuration values
EXECUTE sys.sp_cdc_help_jobs


-- Modify cleanup job settings to retain data for 21 days
DECLARE @days INT = 21;
DECLARE @minutes INT = @days*24*60;

EXECUTE sys.sp_cdc_change_job 
    @job_type = N'cleanup',
    @retention = @minutes;
GO

-- Get the new job configuration values
EXECUTE sys.sp_cdc_help_jobs


