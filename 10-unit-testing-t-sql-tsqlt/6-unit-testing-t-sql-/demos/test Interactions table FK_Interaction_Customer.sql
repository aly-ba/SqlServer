--Create the test class if it doesn't exist:

IF NOT EXISTS (SELECT * FROM tSQLt.TestClasses WHERE Name = 'Interaction')
EXEC tSQLt.NewTestClass @ClassName = N'Interaction' -- nvarchar(max)

GO

IF object_id('Interaction.[test FK_Interaction_Customer Invalid inputs]') IS NOT NULL
DROP PROC Interaction.[test FK_Interaction_Customer Invalid inputs] 
go
CREATE PROC Interaction.[test FK_Interaction_Customer Invalid inputs] AS

--Assemble
----Fake table
EXEC tSQLt.FakeTable @TableName = N'dbo.Interaction'
EXEC tSQLt.FakeTable @TableName = N'dbo.Customer'

EXEC tSQLt.ApplyConstraint @TableName = N'dbo.Interaction', -- nvarchar(max)
    @ConstraintName = N'FK_Interaction_Customer' -- nvarchar(max)
    
--Act
EXEC tSQLt.ExpectException -- we expect the next insert to be invalid:

INSERT dbo.Interaction
        ( 
          CustomerID           
        )
VALUES  ( 
          1  -- CustomerID - int
        )


GO

IF object_id('Interaction.[test FK_Interaction_Customer Valid inputs]') IS NOT NULL
DROP PROC Interaction.[test FK_Interaction_Customer Valid inputs] 
go
CREATE PROC Interaction.[test FK_Interaction_Customer Valid inputs] AS

--Assemble
----Fake table
EXEC tSQLt.FakeTable @TableName = N'dbo.Interaction'
EXEC tSQLt.FakeTable @TableName = N'dbo.Customer'

EXEC tSQLt.ApplyConstraint @TableName = N'dbo.Interaction', -- nvarchar(max)
    @ConstraintName = N'FK_Interaction_Customer' -- nvarchar(max)
    
INSERT dbo.Customer( CustomerID) -- Insert our valid Customer ID into faked table
VALUES  ( 1 )

--Act
EXEC tSQLt.ExpectNoException -- we expect the next insert to be   valid:

INSERT dbo.Interaction
        ( 
          CustomerID           
        )
VALUES  ( 
          1  -- CustomerID - int
        )


GO


--Run our tests
EXEC tSQLt.Run 'Interaction'