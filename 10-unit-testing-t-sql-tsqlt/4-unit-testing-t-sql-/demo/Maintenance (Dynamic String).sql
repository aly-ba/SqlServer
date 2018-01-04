USE CustomerManagement

GO
IF object_ID('dbo.Maintenance_CalculateAverages') IS NOT NULL
DROP PROC dbo.Maintenance_CalculateAverages
GO
CREATE PROC dbo.Maintenance_CalculateAverages
 AS 
 --Stub Proc
 DECLARE @rnd CHAR(2) = FLOOR(RAND() * 100)
 DECLARE @delay VARCHAR(100) = '00:00:00.'+@rnd

WAITFOR DELAY @delay
GO

IF object_ID('dbo.Maintenance_CustomersTakingMoreTime') IS NOT NULL
DROP PROC dbo.Maintenance_CustomersTakingMoreTime
GO
CREATE PROC dbo.Maintenance_CustomersTakingMoreTime
 AS 
 --Stub Proc
WAITFOR DELAY '00:00:01'
GO


IF object_ID('dbo.Maintenance') IS NOT NULL
DROP PROC dbo.Maintenance
GO
CREATE PROCEDURE dbo.Maintenance @Message VARCHAR(MAX) OUTPUT 
AS
--Run Maintenance procedures, Report time taken
DECLARE @StartTime DATETIME
SET @StartTime = GETDATE()
SET @Message = 'Failed to complete.'
EXEC dbo.Maintenance_CalculateAverages

EXEC dbo.Maintenance_CustomersTakingMoreTime

SELECT @Message = 'Completed in '+CONVERT(VARCHAR(10),DATEDIFF(ms,@StartTime,GETDATE())) +' milliseconds'

GO

declare @Message VARCHAR(MAX)
EXECUTE dbo.Maintenance @Message = @Message OUTPUT
SELECT @Message

