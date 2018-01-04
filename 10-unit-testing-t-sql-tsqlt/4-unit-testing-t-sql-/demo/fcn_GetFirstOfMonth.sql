USE CustomerManagement

EXEC tSQLt.NewTestClass @ClassName = N'fcn_GetFirstOfMonth'
GO


CREATE PROC [fcn_GetFirstOfMonth].[test with valid input date]
AS
--Assemble
DECLARE @Actual datetime, @Input date, @Expected datetime
SELECT @Input='2012-02-29', @Expected='2012-02-01'

--Act
SET @Actual=dbo.fcn_GetFirstOfMonth(@Input)

--Assert
EXEC tSQLt.AssertEquals @Expected = @Expected, -- sql_variant
    @Actual = @Actual, -- sql_variant
    @Message = N'Procedure did not return when fed 29th Feb on valid leap year' -- nvarchar(max)

GO
EXEC tSQLt.Run 'fcn_GetFirstOfMonth'