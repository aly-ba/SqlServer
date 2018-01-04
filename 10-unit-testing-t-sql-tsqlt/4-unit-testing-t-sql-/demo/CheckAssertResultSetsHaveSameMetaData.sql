USE CustomerManagement

EXEC tSQLt.NewTestClass @ClassName = N'CheckAssertResultSetsHaveSameMetaData' -- nvarchar(max)
GO

CREATE PROCEDURE [CheckAssertResultSetsHaveSameMetaData].[test OneLessColinActualThanExpected]
AS
BEGIN
--Testing what happens when Actual has LESS columns than expected

  --Assemble
  
  CREATE TABLE [CheckAssertResultSetsHaveSameMetaData].Expected (
  Col1 int,  Col2 int,  col3 int)

  CREATE TABLE [CheckAssertResultSetsHaveSameMetaData].Actual (
  Col1 int,  Col2 int)

    --Assert
  EXEC tSQLt.AssertResultSetsHaveSameMetaData 
			@expectedCommand = N'Select * from [CheckAssertResultSetsHaveSameMetaData].Expected', 
		@actualCommand = N'Select * from [CheckAssertResultSetsHaveSameMetaData].Actual'
      
  
  
END;
GO


CREATE PROCEDURE [CheckAssertResultSetsHaveSameMetaData].[test OneMoreColInActualThanExpected]
AS
BEGIN
--Testing what happens when Actual has MORE columns than expected
  --Assemble
  
  CREATE TABLE [CheckAssertResultSetsHaveSameMetaData].Expected (
  Col1 int,  Col2 int)

  CREATE TABLE [CheckAssertResultSetsHaveSameMetaData].Actual (
  Col1 int,  Col2 int,  Col3 int)

 
  --Assert
  EXEC tSQLt.AssertResultSetsHaveSameMetaData 
			@expectedCommand = N'Select * from [CheckAssertResultSetsHaveSameMetaData].Expected', 
		@actualCommand = N'Select * from [CheckAssertResultSetsHaveSameMetaData].Actual'    
END;


GO

CREATE PROCEDURE [CheckAssertResultSetsHaveSameMetaData].[test OneLessDataInActualColThanExpected]
AS
BEGIN
--Checking behaviour for unpopulated columns

  --Assemble
  
  CREATE TABLE [CheckAssertResultSetsHaveSameMetaData].Expected (
  Col1 int,  Col2 int,  col3 int)

  CREATE TABLE [CheckAssertResultSetsHaveSameMetaData].Actual (
  Col1 int,  Col2 int,  Col3 int)

  INSERT [CheckAssertResultSetsHaveSameMetaData].Expected (col1,col2,col3) VALUES (1,2,3)
  INSERT [CheckAssertResultSetsHaveSameMetaData].Actual (col1,col2) VALUES (1,2)
  
  INSERT [CheckAssertResultSetsHaveSameMetaData].Expected (col1,col2) VALUES (4,5)
  INSERT [CheckAssertResultSetsHaveSameMetaData].Actual (col1,col2,col3) VALUES (4,5,6)

  INSERT [CheckAssertResultSetsHaveSameMetaData].Expected (col1,col2) VALUES (7,8)
  INSERT [CheckAssertResultSetsHaveSameMetaData].Actual (col1,col2) VALUES (7,8)


  --Assert
  EXEC tSQLt.AssertResultSetsHaveSameMetaData 
			@expectedCommand = N'Select * from [CheckAssertResultSetsHaveSameMetaData].Expected', 
		@actualCommand = N'Select * from [CheckAssertResultSetsHaveSameMetaData].Actual'
  
END;
GO
CREATE PROCEDURE [CheckAssertResultSetsHaveSameMetaData].[test Cols in different order]
AS
BEGIN
--Checking behaviour for columns in a different order

  --Assemble
  
  CREATE TABLE [CheckAssertResultSetsHaveSameMetaData].Expected (
  Col1 int,  Col2 int,  col3 int)

  CREATE TABLE [CheckAssertResultSetsHaveSameMetaData].Actual (
  Col1 int,  Col3 int,  Col2 int)

  --Assert
  EXEC tSQLt.AssertResultSetsHaveSameMetaData 
			@expectedCommand = N'Select * from [CheckAssertResultSetsHaveSameMetaData].Expected', 
		@actualCommand = N'Select * from [CheckAssertResultSetsHaveSameMetaData].Actual'
  
END;
GO

CREATE PROCEDURE [CheckAssertResultSetsHaveSameMetaData].[test Col3 has different datatype]
AS
BEGIN
--Checking behaviour for different data types

  --Assemble
  
  CREATE TABLE [CheckAssertResultSetsHaveSameMetaData].Expected (
  Col1 int,  Col2 int,  col3 int)

  CREATE TABLE [CheckAssertResultSetsHaveSameMetaData].Actual (
  Col1 int,  Col2 int,  col3 varchar(10))

  --Assert
  EXEC tSQLt.AssertResultSetsHaveSameMetaData 
			@expectedCommand = N'Select * from [CheckAssertResultSetsHaveSameMetaData].Expected', 
		@actualCommand = N'Select * from [CheckAssertResultSetsHaveSameMetaData].Actual'
  
END;
GO




EXEC tSQLt.Run '[CheckAssertResultSetsHaveSameMetaData]'