--Create test class (Note, this will remove any existing tests in this class if it exists)

EXEC tSQLt.NewTestClass @ClassName = N'RptContactsWithinPeriod' 
GO




CREATE PROC RptContactsWithinPeriod.SetUp AS

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

--Mock Util_GetFirstOfMonth
EXEC tSQLt.SpyProcedure @ProcedureName = 'dbo.Util_GetFirstOfMonth'
				,@CommandToExecute = 'set @FirstOfMonth = ''2013-01-01'' '

GO






CREATE PROC RptContactsWithinPeriod.[test Util_GetFirstOfMonth is called correctly]
AS

--Assemble
IF object_id('RptContactsWithinPeriod.Expected') IS NOT NULL
DROP TABLE RptContactsWithinPeriod.Expected

--Easy way of ensuring the format of the table is consistent with what SpyProcedure will return:
SELECT TOP 0 * INTO RptContactsWithinPeriod.Expected FROM dbo.Util_GetFirstOfMonth_SpyProcedureLog

INSERT RptContactsWithinPeriod.Expected ([Date]) 
	VALUES ('2013-01-05') --The value we expect to be passed in.

--Act
EXEC dbo.RptContactsWithinPeriod @WithinLastMonths = 1, @RunAsAt = '2013-01-05'

--Assert
EXEC tSQLt.AssertEqualsTable @Expected = N'RptContactsWithinPeriod.Expected', -- nvarchar(max)
    @Actual = N'dbo.Util_GetFirstOfMonth_SpyProcedureLog', -- nvarchar(max)
    @FailMsg = N'Not called with expected parameters' -- nvarchar(max)

GO

EXEC tSQLt.Run 'RptContactsWithinPeriod'