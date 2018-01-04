
<!-- saved from url=(0217)https://dl-web.dropbox.com/get/Pluralsight%20Courses%20%28DG%29/Unit%20Testing%20TSQL%20code%20with%20tSQLt/4%20-%20Assertions/demo/CheckAssertEqualsTable.sql?w=AAAyrWcFRhdqEuir07ULCAWfXUhhesqBuT18gCeEWO8Ijg&sjid=2966 -->
<html><head><meta http-equiv="Content-Type" content="text/html; charset=US-ASCII"></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">USE CustomerManagement

EXEC tSQLt.NewTestClass @ClassName = N'CheckAssertEqualsTable' -- nvarchar(max)
GO

CREATE PROCEDURE [CheckAssertEqualsTable].[test OneLessColinActualThanExpected]
AS
BEGIN
--Testing what happens when Actual has LESS columns than expected

  --Assemble
  
  CREATE TABLE [CheckAssertEqualsTable].Expected (
  Col1 int,  Col2 int,  col3 int)

  CREATE TABLE [CheckAssertEqualsTable].Actual (
  Col1 int,  Col2 int)

  INSERT [CheckAssertEqualsTable].Expected (col1,col2,col3) VALUES (1,2,3)
  INSERT [CheckAssertEqualsTable].Actual (col1,col2) VALUES (1,2)


  --Assert
  EXEC tSQLt.AssertEqualsTable @Expected = N'[CheckAssertEqualsTable].Expected', -- nvarchar(max)
      @Actual = N'[CheckAssertEqualsTable].Actual', -- nvarchar(max)
      @FailMsg = N'Expected had one col more than Actual' -- nvarchar(max)
  
  
END;
GO


CREATE PROCEDURE [CheckAssertEqualsTable].[test OneMoreColInActualThanExpected]
AS
BEGIN
--Testing what happens when Actual has MORE columns than expected
  --Assemble
  
  CREATE TABLE [CheckAssertEqualsTable].Expected (
  Col1 int,  Col2 int)

  CREATE TABLE [CheckAssertEqualsTable].Actual (
  Col1 int,  Col2 int,  Col3 int)

  INSERT [CheckAssertEqualsTable].Expected (col1,col2) VALUES (1,2)
  INSERT [CheckAssertEqualsTable].Actual (col1,col2,col3) VALUES (1,2,3)
  
  --Assert
  EXEC tSQLt.AssertEqualsTable @Expected = N'[CheckAssertEqualsTable].Expected', -- nvarchar(max)
      @Actual = N'[CheckAssertEqualsTable].Actual', -- nvarchar(max)
      @FailMsg = N'Expected had one col less than Actual' -- nvarchar(max)
  
END;


GO

CREATE PROCEDURE [CheckAssertEqualsTable].[test OneLessDataInActualColThanExpected]
AS
BEGIN
--Checking behaviour for unpopulated columns

  --Assemble
  
  CREATE TABLE [CheckAssertEqualsTable].Expected (
  Col1 int,  Col2 int,  col3 int)

  CREATE TABLE [CheckAssertEqualsTable].Actual (
  Col1 int,  Col2 int,  Col3 int)

  INSERT [CheckAssertEqualsTable].Expected (col1,col2,col3) VALUES (1,2,3)
  INSERT [CheckAssertEqualsTable].Actual (col1,col2) VALUES (1,2)
  
  INSERT [CheckAssertEqualsTable].Expected (col1,col2) VALUES (4,5)
  INSERT [CheckAssertEqualsTable].Actual (col1,col2,col3) VALUES (4,5,6)

  INSERT [CheckAssertEqualsTable].Expected (col1,col2) VALUES (7,8)
  INSERT [CheckAssertEqualsTable].Actual (col1,col2) VALUES (7,8)


  --Assert
  EXEC tSQLt.AssertEqualsTable @Expected = N'[CheckAssertEqualsTable].Expected', -- nvarchar(max)
      @Actual = N'[CheckAssertEqualsTable].Actual', -- nvarchar(max)
      @FailMsg = N'Data had one null col' -- nvarchar(max)
  
  
END;
GO

EXEC tSQLt.Run '[CheckAssertEqualsTable]'</pre></body></html>