-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS



-- User-defined message using msg_str, severity level 16, state 1
RAISERROR ('This is our user-defined error message, severity 16!', 
		16, 1);



-- User-defined message using msg_str, severity level 0, state 1
-- Informational messages with severity <= 10
RAISERROR ('This is our user-defined error message, severity 0!', 
		10, 1);



-- User-defined message using msg_str, severity level 11, state 1
RAISERROR ('This is our user-defined error message, severity 11!', 
		11, 1);



-- User-defined message using msg_str, severity level 19, state 1
-- Will it work?
RAISERROR ('This is our user-defined error message, severity 19!', 
		19, 1) WITH LOG;



-- What happens with severity level 20 and up?
RAISERROR ('This is our user-defined error message, severity 20!', 
		20, 1) WITH LOG;



-- We can also use a local variable
DECLARE @error_msg VARCHAR(2044) = 'This is our user-defined error message, severity 16!';
RAISERROR (@error_msg, 16, 1);
GO



-- Using character substitution
	-- d or i for signed integer
	-- o for unsigned octal
	-- s for string
	-- u for unsigned integer
	-- x or X for unsigned hexadecimal
RAISERROR ('%i rows were expected from the %s table in the %s database.', 16, 1,
			20, 'dbo.Order', 'Credit');



-- What happens if you exceed 2,047 characters?
DECLARE @error_msg VARCHAR(2048) = 
  REPLICATE('This message is too long and you will see an ellipsis. ',
                                             2048);

RAISERROR (@error_msg, 16, 1);
GO

-- We'll cover using msg_id with an error message in sys.messages

