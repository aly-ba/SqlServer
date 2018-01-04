-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS


-- Adding a user-defined message
EXEC sp_addmessage @msgnum = 75001, @severity = 16,
    @msgtext = 'Unexpected row count from the %s table.', @lang = 'us_english',
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

-- Immediate usage
RAISERROR (75001, 16, 1, N'dbo.Orders');

-- Returning the formatted text without raising an error
SELECT FORMATMESSAGE ( 75001, N'dbo.Orders');

-- Using character substitution - you need to do it indirectly for THROW vs. RAISERROR
DECLARE @dbname NVARCHAR(128) = DB_NAME();
DECLARE @message NVARCHAR(2048)

SELECT @message = FORMATMESSAGE ( 75001,  @dbname + '.' + 'dbo.Orders');

THROW 75001, @message, 1;


-- Cleanup
EXEC sp_dropmessage @msgnum = 75001, @lang = 'us_english';
GO
