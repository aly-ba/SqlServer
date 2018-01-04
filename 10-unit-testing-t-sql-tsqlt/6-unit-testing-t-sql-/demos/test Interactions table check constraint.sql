EXEC tSQLt.NewTestClass 'Interaction'

GO


CREATE PROC Interaction.[test check constraint needs end after start] AS

--Assemble
----Fake table
EXEC tSQLt.FakeTable @TableName = N'dbo.Interaction'
----Apply constraint under test
EXEC tSQLt.ApplyConstraint @TableName = N'dbo.Interaction', -- nvarchar(max)
    @ConstraintName = N'chkInteractionsEndAfterStart' -- nvarchar(max)
    
--Act
EXEC tSQLt.ExpectException
INSERT dbo.Interaction
        ( InteractionStartDT ,
          InteractionEndDT
        )
VALUES  ( 
          '2013-11-02 11:40:18' , -- InteractionStartDT - datetime
          '2013-11-01 11:40:18'  -- InteractionEndDT - datetime
      )

--Assert

GO

CREATE PROC Interaction.[test check constraint with start before end] AS

--Assemble
----Fake table
EXEC tSQLt.FakeTable @TableName = N'dbo.Interaction'
----Apply constraint under test
EXEC tSQLt.ApplyConstraint @TableName = N'dbo.Interaction', -- nvarchar(max)
    @ConstraintName = N'chkInteractionsEndAfterStart' -- nvarchar(max)
    
--Act
EXEC tSQLt.ExpectNoException -- We don't expect an exception to this data
INSERT dbo.Interaction
        ( InteractionStartDT ,
          InteractionEndDT
        )
VALUES  ( 
          '2013-11-01 11:40:18' , -- InteractionStartDT - datetime
          '2013-11-01 12:30:00'  -- InteractionEndDT - datetime
      )

--Assert

GO


EXEC tSQLt.Run @TestName = N'Interaction' -- nvarchar(max)
