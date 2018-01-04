USE CustomerManagement

--Run Test

EXEC tSQLt.Run 
'[RptContactTypes].[test to check routine outputs correct data in table given normal input data]'

--Alter data in the database by adding an interaction

INSERT  [dbo].[Interaction]
        ( [StaffID] ,
          [CustomerID] ,
          [InteractionTypeID] ,
          [InteractionStartDT] ,
          [InteractionEndDT] ,
          [StaffNotes]
        )
select 10 ,
          61 ,
          5 , --Meeting
          CONVERT(DATETIME,'2013-10-21 10:00:00',120),
          CONVERT(DATETIME,'2013-10-21 10:30:00',120) ,
          N'Thirty Min Meeting'

--Now run test again

EXEC tSQLt.Run 
'[RptContactTypes].[test to check routine outputs correct data in table given normal input data]'


-- Display Resulting data in table
--SELECT * FROM Interaction WHERE InteractionStartDT =  CONVERT(DATETIME,'2013-10-21 10:00:00',120)