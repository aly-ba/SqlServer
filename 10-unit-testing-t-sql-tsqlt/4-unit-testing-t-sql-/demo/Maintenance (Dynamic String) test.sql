USE CustomerManagement

EXEC tSQLt.NewTestClass @ClassName = N'Maintenance' -- nvarchar(max)

GO

CREATE PROC Maintenance.[test output parameter is correct]
AS
--Assemble

EXEC tSQLt.SpyProcedure @ProcedureName = N'dbo.Maintenance_CalculateAverages'
				,@CommandToExecute = N' 
						DECLARE @rnd CHAR(2) = FLOOR(RAND() * 100) 
						DECLARE @delay VARCHAR(100) = ''00:00:00.''+@rnd 
						WAITFOR DELAY @delay'
EXEC tSQLt.SpyProcedure @ProcedureName = N'dbo.Maintenance_CustomersTakingMoreTime'

--Act
declare @Actual VARCHAR(MAX)
EXECUTE dbo.Maintenance @Message = @Actual OUTPUT

--Assert
EXEC tSQLt.AssertLike @ExpectedPattern = N'Completed in % milliseconds', -- nvarchar(max)
    @Actual = @Actual, -- nvarchar(max)
    @Message = N'Expected message was not received in output variable.' -- nvarchar(max)

GO


EXEC tSQLt.Run 'Maintenance'

