-- Where am I?
SELECT  @@SERVERNAME;
GO

-- Is there already a Distributor here?
EXEC sp_get_distributor;
GO

-- Add the distributor
EXEC sp_adddistributor @distributor = N'sql2k12-svr2',
    @password = N'4DDF5F1F!!'; 
GO


-- A few observations:
-- Database name is configurable
-- Keep note of the path for the data and log file
-- Default data file is just 5MBs so consider @data_file_size
EXEC sp_adddistributiondb @database = N'distribution',
    @data_folder = N'S:\SQLskills\DATA\', @log_folder = N'S:\SQLskills\DATA\',
    @log_file_size = 2, @min_distretention = 0, @max_distretention = 72,
    @history_retention = 48;
GO

-- Configuring a publisher to use the distribution db
USE distribution;
GO

EXEC sp_adddistpublisher @publisher = N'sql2k12-svr1',
    @distribution_db = N'distribution', @security_mode = 1,
    @working_directory = N'\\SQL2K12-SVR1\Backup\', @thirdparty_flag = 0, -- if SQL and not another product
    @publisher_type = N'MSSQLSERVER';
GO

-- Let's confirm what we created
EXEC sp_get_distributor;

SELECT  is_distributor,
        *
FROM    sys.servers
WHERE   name = 'repl_distributor' AND
        data_source = @@SERVERNAME;
GO

-- Which database is the distributor?
SELECT  name
FROM    sys.databases
WHERE   is_distributor = 1;

-- Specific to the database
EXEC sp_helpdistributiondb;
GO