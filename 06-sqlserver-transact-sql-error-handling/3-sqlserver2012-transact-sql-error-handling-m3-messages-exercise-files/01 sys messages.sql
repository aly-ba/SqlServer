-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS


SELECT  [message_id],
        [language_id],
        [severity],
        [is_event_logged],
        [text]
FROM sys.[messages] AS m
ORDER BY [message_id], [language_id];
GO