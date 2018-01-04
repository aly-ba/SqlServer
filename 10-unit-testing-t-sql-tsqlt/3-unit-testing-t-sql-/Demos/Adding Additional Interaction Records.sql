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
          5 , -- Meeting
          CONVERT(DATETIME,'2013-10-22 10:00:00',120),
          CONVERT(DATETIME,'2013-10-22 10:30:00',120) ,
          N'Thirty Min Meeting'
UNION ALL 
select 10 ,
          60 ,
          2 , -- Phone Call
          CONVERT(DATETIME,'2013-10-22 10:05:00',120),
          CONVERT(DATETIME,'2013-10-22 10:50:00',120) ,
          N'Fourty Five Min Phone Call'


--Now run test again

EXEC tSQLt.Run 
'[RptContactTypes].[test to check routine outputs correct data in table given normal input data]'


--Run all tests in the class

EXEC tSQLt.Run 
'[RptContactTypes]'

