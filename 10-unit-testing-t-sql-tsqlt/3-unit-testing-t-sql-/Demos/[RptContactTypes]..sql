Create PROCEDURE [RptContactTypes].[test to check routine outputs no data in table given no input data]
AS
BEGIN
  --Assemble 
  --Isolate from the Interaction and InteractionType tables:
  EXEC tSQLt.FakeTable @TableName = N'dbo.InteractionType'
  
  EXEC tSQLt.FakeTable @TableName = N'dbo.Interaction'
      
  INSERT dbo.InteractionType
          ( InteractionTypeID, InteractionTypeText )
  VALUES	 (1,'Introduction')
			,(2,'Phone Call (Outbound)')
			,(3,'Complaint')
			,(4,'Sale')
			,(5,'Meeting')

 
IF object_id('RptContactTypes.Expected') IS NOT NULL
DROP TABLE RptContactTypes.Expected

CREATE TABLE RptContactTypes.Expected (
	InteractionTypeText varchar(100),
	Occurrences INT,
	TotalTimeMins int
	)

  --Act
SELECT * INTO RptContactTypes.Actual FROM dbo.RptContactTypes

  
  --Assert
  EXEC tSQLt.AssertEqualsTable @Expected = N'RptContactTypes.Expected', -- nvarchar(max)
      @Actual = N'RptContactTypes.Actual', -- nvarchar(max)
      @FailMsg = N'Data was returned where none was expected (no input data supplied).' -- nvarchar(max)
  
  
END;

