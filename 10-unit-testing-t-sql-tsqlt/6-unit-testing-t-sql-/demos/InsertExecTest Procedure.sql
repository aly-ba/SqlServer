USE CustomerManagement

/* This code demonstrates that Insert Exec can 
capture multiple result sets, but only if those sets
 have the same metadata. */

 
GO
IF OBJECT_ID('dbo.InsertExecTest') IS NOT NULL
DROP PROC dbo.InsertExecTest
GO
-----------One Result Set

CREATE PROC dbo.InsertExecTest AS

SELECT 1,2,3
GO


-----------Two result sets, same metadata


ALTER PROC dbo.InsertExecTest AS

SELECT 1,99,4
SELECT 4,5,6
GO


------------Three result sets, first two identical 

ALTER PROC dbo.InsertExecTest AS

SELECT 1,2,3
SELECT 1,2,3 --Same data as first set
SELECT 4,5,6
GO

-----------Three result sets, one with different metadata

ALTER PROC dbo.InsertExecTest AS

SELECT 1,2,3
SELECT 4,5,6,7
GO

DROP PROC dbo.InsertExecTest