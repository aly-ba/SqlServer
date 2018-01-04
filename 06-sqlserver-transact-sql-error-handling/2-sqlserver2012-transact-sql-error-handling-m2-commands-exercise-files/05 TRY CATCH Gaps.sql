-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

USE [Credit]
GO


--With a severity of 10 or lower in a TRY block.
BEGIN TRY

    RAISERROR ('This error will not pass to the CATCH block.', 10, 1);

END TRY
BEGIN CATCH

    PRINT 'Do I get called?';

END CATCH
GO


--With a severity of 20 or higher that terminates the database connection.
BEGIN TRY

    RAISERROR ('This error will not pass to the CATCH block.', 20, 1) WITH LOG;

END TRY
BEGIN CATCH

    PRINT 'Do I get called?';

END CATCH
GO


-- If you forget WITH LOG, it looks like it works, but it doesn't really

EXEC sp_cycle_errorlog;
GO

BEGIN TRY

    RAISERROR ('This error will not pass to the CATCH block.', 20, 1);

END TRY
BEGIN CATCH

    PRINT 'Do I get called?';

END CATCH
GO


-- Overall syntax error 
BEGIN TRY

	SELECT SELECT [category_code] 
	FROM [dbo].[category] AS c;

END TRY
BEGIN CATCH

	PRINT 'Do I get called?';

END CATCH
GO


-- Cancel execution
BEGIN TRY

    WAITFOR DELAY '05:00:00';

END TRY
BEGIN CATCH

    PRINT 'Do I get called?';

END CATCH
GO


-- Kill this session in a separate window
SELECT  @@SPID;
GO

BEGIN TRY

    WAITFOR DELAY '05:00:00';

END TRY
BEGIN CATCH

    PRINT 'Do I get called?';

END CATCH
GO

