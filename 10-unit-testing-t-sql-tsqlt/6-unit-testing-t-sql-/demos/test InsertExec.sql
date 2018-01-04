USE CustomerManagement

/* This code demonstrates that Insert Exec can 
capture multiple result sets, but only if those sets
 have the same metadata. */

GO

EXEC tSQLt.NewTestClass @ClassName = N'InsertExecTest' 
GO

CREATE PROC InsertExecTest.[test first result set] AS
--Assemble
CREATE TABLE InsertExecTest.Actual (a int,b int, c INT)
CREATE TABLE InsertExecTest.Expected  (a int,b int, c INT)
INSERT InsertExecTest.Expected VALUES (1,2,3)



--Act
INSERT InsertExecTest.Actual
EXEC tSQLt.ResultSetFilter @ResultsetNo = 1, -- int
    @Command = N'EXEC dbo.InsertExecTest' -- nvarchar(max)

--Assert
EXEC tSQLt.AssertEqualsTable 
	@Expected = N'InsertExecTest.Expected', -- nvarchar(max)
    @Actual = N'InsertExecTest.Actual' -- nvarchar(max)

GO

CREATE PROC InsertExecTest.[test second result set] AS
--Assemble
CREATE TABLE InsertExecTest.Actual (a int,b int, c INT, d int)
CREATE TABLE InsertExecTest.Expected  (a int,b int, c INT, d int)
INSERT InsertExecTest.Expected VALUES (4,5,6,7)



--Act
INSERT InsertExecTest.Actual
EXEC tSQLt.ResultSetFilter @ResultsetNo = 2, -- int
    @Command = N'EXEC dbo.InsertExecTest' -- nvarchar(max)

--Assert
EXEC tSQLt.AssertEqualsTable 
	@Expected = N'InsertExecTest.Expected', -- nvarchar(max)
    @Actual = N'InsertExecTest.Actual' -- nvarchar(max)

GO

EXEC tSQLt.Run 'InsertExecTest'