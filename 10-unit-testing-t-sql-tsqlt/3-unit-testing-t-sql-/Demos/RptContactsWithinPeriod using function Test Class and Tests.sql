--Create test class (Note, this will remove any existing tests in this class if it exists)

EXEC tSQLt.NewTestClass @ClassName = N'RptContactsWithinPeriodUsingFunction' 
GO




CREATE PROC RptContactsWithinPeriodUsingFunction.SetUp AS

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

--Isolate from Function:
	EXEC tSQLt.RemoveObject 'dbo.fcn_GetFirstOfMonth';
    EXEC ('CREATE FUNCTION dbo.fcn_GetFirstOfMonth (@Date DATE) RETURNS datetime AS 
			BEGIN RETURN ''2013-02-01 00:00:00''; END;');

--Set Up Expected Data Table

IF object_id('RptContactsWithinPeriodUsingFunction.Expected') IS NOT NULL
DROP TABLE RptContactsWithinPeriodUsingFunction.Expected

CREATE TABLE RptContactsWithinPeriodUsingFunction.Expected (
	InteractionTypeText varchar(100),
	Occurrences INT,
	TotalTimeMins int
	)

--Set Up Actual Data Table
IF object_id('RptContactsWithinPeriodUsingFunction.Actual') IS NOT NULL
DROP TABLE RptContactsWithinPeriodUsingFunction.Actual

CREATE TABLE RptContactsWithinPeriodUsingFunction.Actual (
	InteractionTypeText varchar(100),
	Occurrences INT,
	TotalTimeMins int
	)

GO


CREATE PROC RptContactsWithinPeriodUsingFunction.[test correct data is returned given normal input data]
AS

--Assemble

INSERT dbo.Interaction ( InteractionTypeID ,InteractionStartDT , InteractionEndDT  )
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
          5 , -- Meeting (Out of period  - too recent)
          CONVERT(DATETIME,'2013-02-02 09:00:00',120),
          CONVERT(DATETIME,'2013-02-02 10:30:00',120) 
        )
		,( 
          5 , -- Meeting (Out of period - too old)
          CONVERT(DATETIME,'2012-12-08 09:00:00',120),
          CONVERT(DATETIME,'2012-12-08 10:30:00',120) 
        )
		,( 
          2 , -- Phone Call (Outbound)
          CONVERT(DATETIME,'2013-01-03 09:01:00',120),
          CONVERT(DATETIME,'2013-01-03 09:13:00',120) 
        )

INSERT RptContactsWithinPeriodUsingFunction.Expected VALUES  --Data we expect to be passed in
	('Meeting',2,120), 
	('Phone Call (Outbound)',1,12)

--Act
INSERT RptContactsWithinPeriodUsingFunction.Actual
EXEC dbo.RptContactsWithinPeriodUsingFunction @WithinLastMonths = 1, @RunAsAt = '2013-02-05'

--Assert
EXEC tSQLt.AssertEqualsTable @Expected = N'RptContactsWithinPeriodUsingFunction.Expected', -- nvarchar(max)
    @Actual = N'RptContactsWithinPeriodUsingFunction.Actual', -- nvarchar(max)
    @FailMsg = N'The expected results were not returned' -- nvarchar(max)

GO

EXEC tSQLt.Run 'RptContactsWithinPeriodUsingFunction'