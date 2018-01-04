-- Event session to track waits by session
CREATE EVENT SESSION RBAR_Waits 
ON SERVER 
ADD EVENT sqlos.wait_info(
	ACTION (sqlserver.session_id)
    WHERE ([package0].[equal_uint64]([sqlserver].[session_id],(53))))
ADD TARGET package0.asynchronous_file_target
	(SET FILENAME = N'C:\temp\RBARWaits.xel', 
	 METADATAFILE = N'C:\temp\RBARWaits.xem');

ALTER EVENT SESSION RBAR_Waits 
ON SERVER STATE = START;
GO

-- ** Run workload **

ALTER EVENT SESSION RBAR_Waits 
ON SERVER STATE = STOP;
GO

SELECT CAST(event_data as XML) event_data
INTO #RBAR_Stage_1
FROM sys.fn_xe_file_target_read_file
		('C:\temp\RBARWaits*.xel',
		 'C:\temp\RBARWaits*.xem',
		 NULL, NULL);

-- Aggregated data into intermediate table		 
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
INTO #RBAR_Stage_2
FROM #RBAR_Stage_1;

-- Final result set
SELECT	session_id,
		wait_type,
		SUM(duration) total_duration
FROM #RBAR_Stage_2
GROUP BY session_id,
		wait_type
ORDER BY session_id,
		SUM(duration) DESC;
GO

-- Cleanup
EXEC xp_cmdshell 'del c:\temp\RBARWaits*'
EXEC xp_cmdshell 'del c:\temp\QueryOutput*'
GO
 
DROP EVENT SESSION RBAR_Waits ON SERVER;
GO

DROP TABLE #RBAR_Stage_1
DROP TABLE #RBAR_Stage_2
GO