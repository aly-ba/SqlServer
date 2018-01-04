USE CustomerManagement

EXEC tSQLt.NewTestClass @ClassName = N'LogInformation' -- nvarchar(max)
GO

CREATE PROC LogInformation.[test check log table is created if it does not exist] AS

--Assemble
--Remove existing object
EXEC tSQLt.RemoveObject @ObjectName = N'dbo.tbl_log' -- nvarchar(max)

--Act    
EXEC dbo.LogInformation @Msg = 'test message'

--Assert 
EXEC tSQLt.AssertObjectExists @ObjectName = N'dbo.tbl_log', -- nvarchar(max)
    @Message = N'dbo.tbl_log does not exist (should have been created on the fly)' -- nvarchar(max)

GO

CREATE PROC LogInformation.[test check parameter is required] AS

--Assemble
--Act    
EXEC tSQLt.ExpectException 
		@ExpectedSeverity = 16, 
		@ExpectedState = 4
		,@ExpectedMessage= 'Procedure or function ''LogInformation'' expects parameter ''@Msg'', which was not supplied.'
EXEC dbo.LogInformation 

--Assert 
-- Not needed if above expectation has been met.

GO

CREATE PROC LogInformation.[test check parameter accepts 100 character message] AS

--Assemble
DECLARE @Msg VARCHAR(100) = REPLICATE('a',100)
--Act    
EXEC tSQLt.ExpectNoException @Message = 'An exception was raised when a message of 100 characters was supplied.'
EXEC dbo.LogInformation @Msg = @Msg

--Assert 
-- Not needed if above expectation has been met.

GO


EXEC tSQLt.Run 'LogInformation'
