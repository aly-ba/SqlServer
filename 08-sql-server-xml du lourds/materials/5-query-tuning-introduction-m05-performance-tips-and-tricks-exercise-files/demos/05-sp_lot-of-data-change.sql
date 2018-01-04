/****************************************************************
Course by: 	Pinal Dave  (http://blog.sqlauthority.com)
			Vinod Kumar (http://blogs.extremeExperts.com)

	Script - http://bit.ly/columnstoreindex

Scripts for SQL Server Performance: Query Tuning ©Pluralsight.

Description: Example to show Data changes can recompile SPs

****************************************************************/

USE AdventureWorks2012
GO

-- identIFy recompiling SPs
CREATE PROCEDURE recompiled_procs
AS
BEGIN
    SET NOCOUNT ON;

	SELECT 
		sql_text.text,
		stats.sql_handle,
		stats.plan_generation_num,
		stats.creation_time,
		stats.execution_count,
		DB_NAME(sql_text.dbid) [DBName],
		OBJECT_NAME(sql_text.objectid) [ObjectName]
	FROM sys.dm_exec_query_stats stats
		Cross apply sys.dm_exec_sql_text(sql_handle) as sql_text
	WHERE stats.plan_generation_num > 1
		and sql_text.objectid IS NOT NULL
	ORDER BY stats.plan_generation_num desc
END
GO

CREATE PROCEDURE proc_recompile
AS
BEGIN
    SET NOCOUNT ON;

	IF OBJECT_ID('Person.NewContact') IS NOT NULL DROP TABLE [Person].[NewContact]
	
	CREATE TABLE [Person].[NewContact](
		[BusinessEntityID] [int] NOT NULL,
		[PersonID] [int] NOT NULL,
		[ContactTypeID] [int] NOT NULL,
		[rowguid] [uniqueidentIFier] ROWGUIDCOL  NOT NULL,
		[ModIFiedDate] [datetime] NOT NULL,
			 CONSTRAINT [myPK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeID] PRIMARY KEY CLUSTERED 
			(
				[BusinessEntityID] ASC,
				[PersonID] ASC,
				[ContactTypeID] ASC
			)ON [PRIMARY]
		) ON [PRIMARY]

	INSERT INTO Person.NewContact 
	  SELECT * FROM [Person].[BusinessEntityContact]
	  WHERE BusinessEntityID  <= 1000

	CREATE INDEX idx_BusinessEntityID ON Person.NewContact (BusinessEntityID)

	SELECT * FROM Person.NewContact
	   WHERE BusinessEntityID = 588

	INSERT INTO Person.NewContact 
	  SELECT * FROM [Person].[BusinessEntityContact]
	  WHERE BusinessEntityID > 1000

	SELECT * FROM Person.NewContact
	   WHERE BusinessEntityID = 1066
	
	SET CONCAT_NULL_YIELDS_NULL OFF
		
	SELECT * FROM Person.NewContact
	   WHERE BusinessEntityID = 1050
end
GO

-- remove all plans FROM plancache
DBCC freeproccache
GO

EXEC proc_recompile
EXEC recompiled_procs
EXEC proc_recompile
EXEC recompiled_procs
GO


-- Cleanup Time
IF OBJECT_ID('recompiled_procs') IS NOT NULL DROP procedure recompiled_procs
GO

IF OBJECT_ID('proc_recompile') IS NOT NULL DROP procedure proc_recompile
GO

IF OBJECT_ID('Person.NewContact') IS NOT NULL DROP TABLE  [Person].[NewContact]
GO