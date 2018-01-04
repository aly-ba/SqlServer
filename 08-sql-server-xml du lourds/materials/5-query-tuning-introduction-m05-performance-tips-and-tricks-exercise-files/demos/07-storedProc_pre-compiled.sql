/****************************************************************
Course by: 	Pinal Dave  (http://blog.sqlauthority.com)
			Vinod Kumar (http://blogs.extremeExperts.com)

	Script - http://bit.ly/columnstoreindex

Scripts for SQL Server Performance: Query Tuning ©Pluralsight.

Description: Script to show SP's execution plans 
				is not compiled while creation.

****************************************************************/

/* Exeercise to verify if stored procedure pre-compiled */
USE AdventureWorks2012
GO
-- Clean Cache
DBCC FREEPROCCACHE
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CompSP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CompSP]
GO
-- Create New Stored Procedure
CREATE PROCEDURE CompSP
AS
SELECT *
FROM HumanResources.Department
GO
-- Check the Query Plan for SQL Batch
-- You will find that there is no ObjectName with CompSP
SELECT cp.objtype AS PlanType,
       OBJECT_NAME(st.objectid,st.dbid) AS ObjectName,
       cp.refcounts AS ReferenceCounts,
       cp.usecounts AS UseCounts,
       st.text AS SQLBatch,
       qp.query_plan AS QueryPlan
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS st;
GO
/* Execute Stored Procedure */
EXEC CompSP
GO
-- Check the Query Plan for SQL Batch
-- You will find that there is one entry with name ObjectName with name CompSP
SELECT cp.objtype AS PlanType,
       OBJECT_NAME(st.objectid,st.dbid) AS ObjectName,
       cp.refcounts AS ReferenceCounts,
       cp.usecounts AS UseCounts,
       st.text AS SQLBatch,
       qp.query_plan AS QueryPlan
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS st;
GO

/* ----------------------------- */
-- Clean Cache
DBCC FREEPROCCACHE
GO
/* Case and Space Sensitive plan */
SELECT  * 
FROM HumanResources.Shift
GO 10

-- Check the Query Plan for SQL Batch
SELECT cp.objtype AS PlanType,
       OBJECT_NAME(st.objectid,st.dbid) AS ObjectName,
       cp.refcounts AS ReferenceCounts,
       cp.usecounts AS UseCounts,
       st.text AS SQLBatch,
       qp.query_plan AS QueryPlan
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) AS qp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS st;
GO
