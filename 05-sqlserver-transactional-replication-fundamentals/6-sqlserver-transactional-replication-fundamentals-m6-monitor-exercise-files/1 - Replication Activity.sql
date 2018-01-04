USE [Credit];
GO

DECLARE @MovingTarget datetime = GETDATE();

WHILE DATEADD(second,20000, @MovingTarget)
	>GETDATE()
BEGIN
	
	UPDATE dbo.category
	SET category_code = 'NA'

	--WAITFOR DELAY '00:00:1';
	
END;

