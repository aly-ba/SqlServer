USE CustomerManagement

/* This code demonstrates that Insert Exec can 
capture multiple result sets, but only if those sets
 have the same metadata. */

GO


DECLARE @t TABLE  (a int,b int, c INT)

INSERT @t
EXEC dbo.InsertExecTest

SELECT * FROM @t

GO

----

DECLARE @t TABLE  (a int,b int, c INT
				,d INT
				)

INSERT @t
EXEC dbo.InsertExecTest

SELECT * FROM @t


