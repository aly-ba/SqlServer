ALTER PROCEDURE [RptContactTypes].[test to check routine outputs no data in table given no input data]
AS
BEGIN
  --Assemble 
  
  --Act
SELECT * INTO RptContactTypes.Actual FROM dbo.RptContactTypes

  
  --Assert
  EXEC tSQLt.AssertEqualsTable @Expected = N'RptContactTypes.Expected', -- nvarchar(max)
      @Actual = N'RptContactTypes.Actual', -- nvarchar(max)
      @FailMsg = N'Data was returned where none was expected (no input data supplied).' -- nvarchar(max)
  
  
END;

