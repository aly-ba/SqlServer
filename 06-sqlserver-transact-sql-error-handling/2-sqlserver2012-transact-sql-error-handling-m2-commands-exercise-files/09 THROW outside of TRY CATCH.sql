-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

USE [Credit]
GO


-- Using THROW outside of a TRY...CATCH

-- This will fail
THROW;
GO



-- Outside of a catch, use arguments
THROW 50001, 'This will work.', 1;
GO



-- But remember the semi-colon statement terminator prior to the THROW
PRINT 'Test'
THROW 50001, 'This will NOT work.', 1;
GO



PRINT 'Test';
THROW 50001, 'This will work.', 1;
GO



-- Notice that severity isn't an option (always 16)
THROW 50001, 'My error message', 1;
GO



-- Using character substitution
RAISERROR ('%i rows were expected from the %s table in the %s database.', 16, 1,
			20, 'dbo.Order', 'Credit');
GO
-- No direct THROW equivalent, but we can use FORMATMESSAGE (covered in the next module)
