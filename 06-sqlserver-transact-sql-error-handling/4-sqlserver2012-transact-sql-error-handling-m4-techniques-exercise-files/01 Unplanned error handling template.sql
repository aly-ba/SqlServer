-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

USE [Credit]
GO

-- Check for SQL Server 2012 or greater 
IF LEFT(CONVERT(CHAR(2), SERVERPROPERTY('ProductVersion')), 2) >= '11' 
    BEGIN
        PRINT N'Create the SP';
    END
GO

-- Unplanned Error Handling Template
-- (As with any template, your logic needs may vary, but this is a starting point)

CREATE PROCEDURE [Unplanned_Error_Handling_Template] 
	@Input_Param_1 INT -- O:M input parameters
AS 
BEGIN TRY
	
	-- Stops the count of the number of rows affected messages 
    SET NOCOUNT ON;

	-- Automatically roll back the transaction when a run-time error	   occurs (THROW honors this.  RAISERROR does not.)
    SET XACT_ABORT ON;

	-- Non-transaction code here 

    BEGIN TRANSACTION;
        
	-- Transaction code here

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
        
	-- 0 = no active transaction needing to be rolled back
    IF XACT_STATE() <> 0 
        ROLLBACK TRANSACTION;

    -- Error information (if you want it returned as a result set)
    SELECT  ERROR_LINE() AS [Error_Line],
            ERROR_MESSAGE() AS [Error_Message],
            ERROR_NUMBER() AS [Error_Number],
            ERROR_SEVERITY() AS [Error_Severity],
            ERROR_PROCEDURE() AS [Error_Procedure];

    THROW; -- Uses THROW, so this assumes use of SQL Server 2012 

END CATCH
GO