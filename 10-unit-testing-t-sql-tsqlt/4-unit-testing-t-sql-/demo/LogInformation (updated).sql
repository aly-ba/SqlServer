USE CustomerManagement
GO
ALTER PROC  dbo.LogInformation @Msg VARCHAR(100) AS
IF OBJECT_ID('dbo.tbl_log') IS NULL
CREATE TABLE dbo.tbl_log (
	LogID INT IDENTITY(1,1),
	LogMessage VARCHAR(100),
	Logged DATETIME NOT NULL DEFAULT GETDATE()
	)

GO

EXEC dbo.LogInformation 'test'