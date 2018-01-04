CREATE PROCEDURE RptContactTypes.SetUp AS

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

--Set Up Expected Data Table

IF object_id('RptContactTypes.Expected') IS NOT NULL
DROP TABLE RptContactTypes.Expected

CREATE TABLE RptContactTypes.Expected (
	InteractionTypeText varchar(100),
	Occurrences INT,
	TotalTimeMins int
	)
