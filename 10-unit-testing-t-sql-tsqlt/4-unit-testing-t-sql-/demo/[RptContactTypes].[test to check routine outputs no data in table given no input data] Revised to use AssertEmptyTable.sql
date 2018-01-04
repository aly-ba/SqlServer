ALTER PROCEDURE [RptContactTypes].[test to check routine outputs no data in table given no input data]
AS
BEGIN
 --Assemble 
 /*  INSERT dbo.Interaction
        ( InteractionTypeID ,
          InteractionStartDT ,
          InteractionEndDT 
        )
VALUES  ( 
          5 , -- Meeting
          CONVERT(DATETIME,'2013-01-03 09:00:00',120),
          CONVERT(DATETIME,'2013-01-03 09:30:00',120) 
        )
		*/
  --Act
  
  --Assert
  
	EXEC tSQLt.AssertEmptyTable @TableName = N'dbo.RptContactTypes' -- nvarchar(max)  

END;

