ALTER PROCEDURE [RptContactTypes].[test to check routine outputs correct data in table given normal input data]
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

  INSERT dbo.Interaction
        ( InteractionTypeID ,
          InteractionStartDT ,
          InteractionEndDT 
        )
VALUES  ( 
          5 , -- Meeting
          CONVERT(DATETIME,'2013-01-03 09:00:00',120),
          CONVERT(DATETIME,'2013-01-03 09:30:00',120) 
        )
		,( 
          5 , -- Meeting
          CONVERT(DATETIME,'2013-01-02 09:00:00',120),
          CONVERT(DATETIME,'2013-01-02 10:30:00',120) 
        )
		,( 
          2 , -- Phone Call (Outbound)
          CONVERT(DATETIME,'2013-01-03 09:01:00',120),
          CONVERT(DATETIME,'2013-01-03 09:13:00',120) 
        )


IF object_id('RptContactTypes.Expected') IS NOT NULL
DROP TABLE RptContactTypes.Expected

CREATE TABLE RptContactTypes.Expected (
	InteractionTypeText varchar(100),
	Occurrences INT,
	TotalTimeMins int
	)

  INSERT RptContactTypes.Expected VALUES 
	('Meeting',2,120), 
	('Phone Call (Outbound)',1,12)

  --Act
SELECT * INTO RptContactTypes.Actual FROM dbo.RptContactTypes

  
  --Assert
  EXEC tSQLt.AssertEqualsTable @Expected = N'RptContactTypes.Expected', -- nvarchar(max)
      @Actual = N'RptContactTypes.Actual', -- nvarchar(max)
      @FailMsg = N'The expected data was not returned.' -- nvarchar(max)
  
  
END;

