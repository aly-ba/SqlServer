:CONNECT sql2k12-svr3
SELECT @@SERVERNAME;

-- Distribution Agent
-- Session ID?
SELECT	session_id, program_name,
		reads,
		writes,
		logical_reads
FROM sys.dm_exec_sessions
WHERE program_name LIKE '%SQL2K12-SVR1_Credit_Pub_Credit%';
GO

-- Event session to track waits by session
:CONNECT sql2k12-svr3
CREATE EVENT SESSION Replication_AGT_Waits 
ON SERVER 
ADD EVENT sqlos.wait_info(
	ACTION (sqlserver.session_id)
    WHERE ([package0].[equal_uint64]([sqlserver].[session_id],(61)) OR 
    [package0].[equal_uint64]([sqlserver].[session_id],(53))))
ADD TARGET package0.asynchronous_file_target
	(SET FILENAME = N'C:\SQLskills\ReplAGTStats.xel', -- CHECK that these are cleared
	 METADATAFILE = N'C:\SQLskills\ReplAGTStats.xem');

ALTER EVENT SESSION Replication_AGT_Waits 
ON SERVER STATE = START;
GO

-- Launch Monitor and wait for all trans to be fully distributed
:CONNECT sql2k12-svr3
ALTER EVENT SESSION Replication_AGT_Waits 
ON SERVER STATE = STOP;
GO

:CONNECT sql2k12-svr3
-- Raw data into intermediate table
-- (Make sure you've cleared out previous target files!)
SELECT CAST(event_data as XML) event_data
INTO #ReplicationAgentWaits_Stage_1
FROM sys.fn_xe_file_target_read_file
		('C:\SQLskills\ReplAGTStats*.xel',
		 'C:\SQLskills\ReplAGTStats*.xem',
		 NULL, NULL);

-- Aggregated data into intermediate table
-- #ReplicationAgentWaits		 
SELECT 
	event_data.value 
	('(/event/action[@name=''session_id'']/value)[1]', 'smallint') as session_id,
	event_data.value 
	('(/event/data[@name=''wait_type'']/text)[1]', 'varchar(100)') as wait_type,
	event_data.value 
	('(/event/data[@name=''duration'']/value)[1]', 'bigint') as duration,
	event_data.value 
	('(/event/data[@name=''signal_duration'']/value)[1]', 'bigint') as signal_duration,
	event_data.value 
	('(/event/data[@name=''completed_count'']/value)[1]', 'bigint') as completed_count
INTO #ReplicationAgentWaits_Stage_2
FROM #ReplicationAgentWaits_Stage_1;

-- Final result set
SELECT	session_id,
		wait_type,
		SUM(duration) total_duration,
		SUM(signal_duration) total_signal_duration,
		SUM(completed_count) total_wait_count
FROM #ReplicationAgentWaits_Stage_2
GROUP BY session_id,
		wait_type
ORDER BY session_id,
		SUM(duration) DESC;
GO

-- Cleanup

:CONNECT sql2k12-svr3
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE
GO

:CONNECT sql2k12-svr3
EXEC xp_cmdshell 'del c:\SQLskills\Repl*';
GO

:CONNECT sql2k12-svr3	 
DROP EVENT SESSION Replication_AGT_Waits ON SERVER;
GO