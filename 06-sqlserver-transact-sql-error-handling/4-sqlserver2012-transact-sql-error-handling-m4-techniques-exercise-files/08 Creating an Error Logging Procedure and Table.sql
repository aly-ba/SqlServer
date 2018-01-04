-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

USE [Credit]
GO

-- Error logging table
IF OBJECT_ID('[dbo].[Credit_Error_Log]') IS NOT NULL 
    BEGIN
        DROP TABLE [dbo].[Credit_Error_Log];
    END
GO

CREATE TABLE [dbo].[Credit_Error_Log]
(
 [Credit_Error_Log_ID] INT NOT NULL
                           PRIMARY KEY
                           IDENTITY(1, 1),
 [ERROR_DATE] DATETIME2 DEFAULT SYSDATETIME(),
 [ERROR_NUMBER] INT NULL,
 [ERROR_MESSAGE] NVARCHAR(4000) NULL,
 [ERROR_SEVERITY] INT NULL,
 [ERROR_STATE] INT NULL,
 [ERROR_LINE] INT NULL,
 [ERROR_PROCEDURE] NVARCHAR(128) NULL
);
GO

-- Error logging procedure
IF OBJECT_ID('[dbo].[Credit_Error_Log_Error_Handler]') IS NOT NULL 
    BEGIN
        DROP PROCEDURE [dbo].[Credit_Error_Log_Error_Handler];
    END
GO

CREATE PROCEDURE [dbo].[Credit_Error_Log_Error_Handler]
AS 
BEGIN TRY
	
	-- Stops the count of the number of rows affected messages 
    SET NOCOUNT ON;

	-- Automatically roll back the transaction when a run-time error occurs
	-- THROW honors this.  RAISERROR does not.
    SET XACT_ABORT ON;

	-- Non-transaction code here 
    BEGIN TRANSACTION;
        
    INSERT  INTO [dbo].[Credit_Error_Log]
            ([ERROR_NUMBER],
             [ERROR_MESSAGE],
             [ERROR_SEVERITY],
             [ERROR_STATE],
             [ERROR_LINE],
             [ERROR_PROCEDURE])
            SELECT  ERROR_NUMBER() AS [Error_Number],
                    ERROR_MESSAGE() AS [Error_Message],
                    ERROR_SEVERITY() AS [Error_Severity],
                    ERROR_STATE() AS [Error_State],
                    ERROR_LINE() AS [Error_Line],
                    ERROR_PROCEDURE() AS [Error_Procedure];

	-- Error information (if you want it returned as a result set)
    SELECT  ERROR_NUMBER() AS [Error_Number],
            ERROR_MESSAGE() AS [Error_Message],
            ERROR_SEVERITY() AS [Error_Severity],
            ERROR_STATE() AS [Error_State],
            ERROR_LINE() AS [Error_Line],
            ERROR_PROCEDURE() AS [Error_Procedure];

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
        
	-- 0 = no active transaction needing to be rolled back
    IF XACT_STATE() <> 0 
        ROLLBACK TRANSACTION;

    -- Error information (if you want it returned as a result set)
    SELECT  ERROR_NUMBER() AS [Error_Number],
            ERROR_MESSAGE() AS [Error_Message],
            ERROR_SEVERITY() AS [Error_Severity],
            ERROR_STATE() AS [Error_State],
            ERROR_LINE() AS [Error_Line],
            ERROR_PROCEDURE() AS [Error_Procedure];

    THROW; -- Uses THROW, so this assumes use of SQL Server 2012 

END CATCH
GO