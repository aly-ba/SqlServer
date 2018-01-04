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
        BEGIN
            ROLLBACK TRANSACTION
        END;
    
    RAISERROR ('Stored procedure "generatestatement_nextgen" failed',
	 16, -1);

END CATCH      

GO

-- Successful test
EXEC [dbo].[generatestatement_nextgen] 9672, '2013-10-13 10:46:39.597';
GO

-- Statement amount is zero
EXEC [dbo].[generatestatement_nextgen] 8842, '2013-09-22 10:43:38.223';
GO