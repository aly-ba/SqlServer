ALTER PROCEDURE [RptContactTypes].[test to check routine outputs correct data in table given normal input data]
AS
BEGIN
  --Assemble 
--Insert test data into Interaction table (Faked in Setup Routine)  

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

--Insert Expected Values

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

