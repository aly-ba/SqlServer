USE tempdb
GO
SELECT CAST(REPLACE(REPLACE(
XEventData.XEvent.value ('(data/value)[1]', 'varchar(max)'),
'<victim-list>', '<deadlock><victim-list>'),
'<process-list>', '</victim-list><process-list>')
AS XML) AS DeadlockStatements
FROM 
	(SELECT CAST (target_data AS XML) AS TargetData
	FROM sys.dm_xe_session_targets st
	INNER JOIN sys.dm_xe_sessions s ON s.address = st.event_session_address
	WHERE [name] = 'system_health') AS Data
CROSS APPLY TargetData.nodes ('//RingBufferTarget/event') AS XEventData (XEvent)
WHERE XEventData.XEvent.value('@name', 'varchar(4000)') = 'xml_deadlock_report';

