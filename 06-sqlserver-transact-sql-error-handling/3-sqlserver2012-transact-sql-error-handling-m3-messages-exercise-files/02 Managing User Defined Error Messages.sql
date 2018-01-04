-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

-- Adding a user-defined message
EXEC sp_addmessage @msgnum = 75001, @severity = 16,
    @msgtext = 'Unexpected row count from the %s table.', 
	@lang = 'us_english',
    @with_log = 'FALSE';
GO



SELECT  [message_id],
        [language_id],
        [severity],
        [is_event_logged],
        [text]
FROM    sys.[messages] AS m
WHERE   [message_id] = 75001;
GO



-- Not providing an argument
RAISERROR (75001, 16, 1);



-- Providing an argument
RAISERROR (75001, 16, 1, 'dbo.Orders');



-- Modifying a message (really only one option here)
EXEC sp_altermessage @message_id = 75001, @parameter = 'WITH_LOG',
    @parameter_value = 'TRUE';
GO



SELECT  [message_id],
        [language_id],
        [severity],
        [is_event_logged],
        [text]
FROM    sys.[messages] AS m
WHERE   [message_id] = 75001;
GO



RAISERROR (75001, 16, 1, 'dbo.Orders');

-- Check the SQL Server error log and the Windows Application log



-- Dropping a message
EXEC sp_dropmessage @msgnum = 75001, @lang = 'us_english';
GO



SELECT  [message_id],
        [language_id],
        [severity],
        [is_event_logged],
        [text]
FROM    sys.[messages] AS m
WHERE   [message_id] = 75001;
GO