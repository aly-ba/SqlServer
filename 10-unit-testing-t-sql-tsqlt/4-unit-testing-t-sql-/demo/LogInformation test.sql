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

EXEC tSQLt.Run 'LogInformation'
