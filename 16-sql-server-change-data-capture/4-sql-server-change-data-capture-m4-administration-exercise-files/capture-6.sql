USE Credit;
GO

-- First Drop the second capture instance from dbo.charge

EXECUTE sys.sp_cdc_disable_table 
  @source_schema = 'dbo' , 
  @source_name = 'charge',
  @capture_instance = 'dbo_charge_2';


-- Now we can modify the table as needed
ALTER TABLE dbo.Charge
ADD AuditUser SYSNAME;
GO


-- Look at the dbo_charge tracking table - nothing changed
SELECT *
FROM [cdc].[dbo_charge_CT]
GO

-- Look for DDL Changes
EXECUTE [sys].[sp_cdc_get_ddl_history] @capture_instance = 'dbo_charge';
GO

-- Now we would update the target table to match as necessary
-- Then create a new capture instance
EXEC sys.sp_cdc_enable_table 
@source_schema = N'dbo',
@source_name = N'charge',
@role_name = N'cdc_admin',
@filegroup_name = 'cdc_ChangeTables',
@supports_net_changes = 1,
@capture_instance = N'dbo_charge_2';
GO

-- Look at the dbo_charge_2 tracking table 
SELECT *
FROM [cdc].[dbo_charge_2_CT]
GO

-- Modify process relying on dbo_charge and then drop that capture instance


-- Create changes and look at capture data


-- Perform an update to one of the captured charges
UPDATE dbo.charge
SET charge_amt = 4622.00
WHERE charge_no = 2000001;
GO

EXECUTE Process_CDC_changes @capture_instance = 'dbo_charge', @row_filter_option = 'all update old', @mark_processed = 1;
EXECUTE Process_CDC_changes @capture_instance = 'dbo_charge_2', @row_filter_option = 'all update old', @mark_processed = 1;

-- Perform an update to one of the captured charges
UPDATE dbo.charge
SET charge_amt = 4621.00
WHERE charge_no = 2000001;
GO

EXECUTE Process_CDC_changes @capture_instance = 'dbo_charge', @row_filter_option = 'all update old', @mark_processed = 1;
EXECUTE Process_CDC_changes @capture_instance = 'dbo_charge_2', @row_filter_option = 'all update old', @mark_processed = 1;

