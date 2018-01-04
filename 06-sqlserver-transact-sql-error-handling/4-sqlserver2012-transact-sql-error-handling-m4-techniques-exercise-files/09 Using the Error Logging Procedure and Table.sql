-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

USE [Credit]
GO


-- Using the error logging procedure
IF OBJECT_ID('[dbo].[Insert_Charge]') IS NOT NULL 
    BEGIN
        DROP PROCEDURE [dbo].[Insert_Charge];
    END
GO

CREATE PROCEDURE [dbo].[Insert_Charge]
    @member_no INT,
    @provider_no INT,
    @category_no INT,
    @charge_dt DATETIME,
    @charge_amt MONEY,
    @statement_no INT,
    @charge_code CHAR(2)
AS 
BEGIN TRY
	
	-- Stops the count of the number of rows affected messages 
    SET NOCOUNT ON;

	-- Automatically roll back the transaction when a run-time error occurs
	-- THROW honors this.  RAISERROR does not.
    SET XACT_ABORT ON;

    BEGIN TRANSACTION;
        
    INSERT  INTO [dbo].[charge]
            ([member_no],
             [provider_no],
             [category_no],
             [charge_dt],
             [charge_amt],
             [statement_no],
             [charge_code])
    VALUES  (@member_no,
             @provider_no,
             @category_no,
             @charge_dt,
             @charge_amt,
             @statement_no,
             @charge_code)

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
        
	-- 0 = no active transaction needing to be rolled back
    IF XACT_STATE() <> 0 
        ROLLBACK TRANSACTION;

    -- Error logging and a returned result set
    EXEC [dbo].[Credit_Error_Log_Error_Handler];

    THROW; -- Uses THROW, so this assumes use of SQL Server 2012 

END CATCH
GO

-- Unplanned Error Handling example
EXECUTE [dbo].[Insert_Charge] @member_no = 8842, @provider_no = 99999 -- This provider number doesn't exist
    , @category_no = 2, @charge_dt = '2013-07-31 18:10:53.970',
    @charge_amt = 14.45, @statement_no = 28842, @charge_code = 'ACT'
GO


-- Let's check the error handling log
SELECT  [Credit_Error_Log_ID],
        [ERROR_DATE],
        [ERROR_NUMBER],
        [ERROR_MESSAGE],
        [ERROR_SEVERITY],
        [ERROR_STATE],
        [ERROR_LINE],
        [ERROR_PROCEDURE]
FROM    [dbo].[Credit_Error_Log];
GO

