USE [Credit];
GO

DECLARE @MovingTarget DATETIME = GETDATE();
DECLARE @PowerItUp BIGINT;

WHILE DATEADD(second, 20000, @MovingTarget) > GETDATE() 
    BEGIN
        EXEC dbo.compile_happy
    END
GO
