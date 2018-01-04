-- You can get the Credit database used in these demos from http://bit.ly/10fKpbS

USE [Credit]
GO

-- Revising generatestatement_legacy with TRY...CATCH 
IF OBJECT_ID('[dbo].[generatestatement_nextgen]') IS NOT NULL 
    BEGIN
        DROP PROCEDURE [dbo].[generatestatement_nextgen];
    END
GO

CREATE PROCEDURE [dbo].[generatestatement_nextgen]
    @member_no INT,
    @statement_dt DATETIME
AS 
BEGIN TRY
    
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @due_dt DATETIME;
    SELECT  @due_dt = DATEADD(day, 20, @statement_dt);
    DECLARE @statement_amt MONEY;
    DECLARE @ROWCOUNT INT;

    BEGIN TRANSACTION

    SELECT  @statement_amt = ISNULL(SUM([charge].[charge_amt]), 0)
    FROM    [dbo].[charge]
    WHERE   [charge].[member_no] = @member_no AND
            [charge].[statement_no] = 0 AND
            [charge].[charge_dt] <= @statement_dt;
	
    IF @statement_amt = 0 
        BEGIN
            RAISERROR('Statement amount is 0.', 16,1);
        END

    INSERT  [dbo].[statement]
            (member_no,
             statement_dt,
             due_dt,
             statement_amt,
             statement_code)
    VALUES  (@member_no,
             @statement_dt,
             @due_dt,
             @statement_amt,
             ' ');

    UPDATE  [dbo].[charge]
    SET     [charge].[statement_no] = @@IDENTITY
    WHERE   [charge].[member_no] = @member_no AND
            [charge].[statement_no] = 0 AND
            [charge].[charge_dt] <= @statement_dt;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH  

    IF @@TRANCOUNT <> 0 
        ROLLBACK TRANSACTION;
    
    SELECT  ERROR_LINE() AS [Error_Line],
            ERROR_MESSAGE() AS [Error_Message],
            ERROR_NUMBER() AS [Error_Number],
            ERROR_SEVERITY() AS [Error_Severity],
            ERROR_PROCEDURE() AS [Error_Procedure];

END CATCH      

GO

EXEC [dbo].[generatestatement_nextgen] 8842, '2013-09-22 10:43:38.223';
GO

-- What about using these outside of a CATCH block?
RAISERROR ('Will this produce error information via ERROR_LINE and the rest?', 16, 1);

SELECT  ERROR_LINE() AS [Error_Line],
        ERROR_MESSAGE() AS [Error_Message],
        ERROR_NUMBER() AS [Error_Number],
        ERROR_SEVERITY() AS [Error_Severity],
        ERROR_PROCEDURE() AS [Error_Procedure];

