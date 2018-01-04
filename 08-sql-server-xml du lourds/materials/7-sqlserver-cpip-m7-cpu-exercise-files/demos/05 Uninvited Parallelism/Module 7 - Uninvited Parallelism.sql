USE Credit;
GO

DECLARE @MovingTarget DATETIME = GETDATE();
DECLARE @PowerItUp BIGINT;

WHILE DATEADD(second, 20000, @MovingTarget) > GETDATE() 
    BEGIN
        EXEC sp_executesql N'SELECT charge_no FROM dbo.charge
	WHERE charge_dt = @charge_dt', N'@charge_dt datetime',
            @charge_dt = '1999-07-20 10:49:11.833';
    END
GO
