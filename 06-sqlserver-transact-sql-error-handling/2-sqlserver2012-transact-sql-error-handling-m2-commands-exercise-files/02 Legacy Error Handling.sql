-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS

USE [Credit]
GO

-- Example of "legacy" error handling in SQL Server, pre-TRY...CATCH
IF OBJECT_ID('[dbo].[generatestatement_legacy]') IS NOT NULL 
    BEGIN
        DROP PROCEDURE [dbo].[generatestatement_legacy];
    END
GO

CREATE PROCEDURE [dbo].[generatestatement_legacy]
    @member_no INT,
    @statement_dt DATETIME
AS 
DECLARE @due_dt DATETIME;
SELECT  @due_dt = DATEADD(day, 20, @statement_dt);
DECLARE @statement_amt MONEY;
DECLARE @ERROR INT,
    @ROWCOUNT INT;

BEGIN TRANSACTION

SELECT  @statement_amt = ISNULL(SUM([charge].[charge_amt]), 0)
FROM    [dbo].[charge]
WHERE   [charge].[member_no] = @member_no AND
        [charge].[statement_no] = 0 AND
        [charge].[charge_dt] <= @statement_dt;
	
IF @statement_amt = 0 
    BEGIN
        PRINT 'Statement amount is 0.';
        SELECT  @ERROR = -1;
        GOTO RollbackTran
		
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

SELECT  @ERROR = @@ERROR;
IF @ERROR <> 0 
    BEGIN
        PRINT 'INSERT to "statement" failed.'      
        GOTO RollbackTran
    END

UPDATE  [dbo].[charge]
SET     [charge].[statement_no] = @@IDENTITY
WHERE   [charge].[member_no] = @member_no AND
        [charge].[statement_no] = 0 AND
        [charge].[charge_dt] <= @statement_dt;

SELECT  @ERROR = @@ERROR;
IF @ERROR <> 0 
    BEGIN
        PRINT 'UPDATE to "charge" failed.'      
        GOTO RollbackTran
    END      

COMMIT TRANSACTION
  
RollbackTran:
IF @ERROR <> 0 
    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('Stored procedure "generatestatement_legacy" failed', 16, -1)
        RETURN (-99)
    END

GO

-- Successful test
DECLARE @ReturnCode INT;
EXEC @ReturnCode = [dbo].[generatestatement_legacy] 9672,
    '2013-10-13 10:46:39.597';
SELECT  @ReturnCode AS [ReturnCode];
GO

-- Statement amount is zero
DECLARE @ReturnCode INT;
EXEC @ReturnCode = [dbo].[generatestatement_legacy] 8842,
    '2013-09-22 10:43:38.223';
SELECT  @ReturnCode;
GO

