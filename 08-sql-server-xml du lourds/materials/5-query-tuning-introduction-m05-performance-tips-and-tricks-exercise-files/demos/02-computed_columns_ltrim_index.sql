/****************************************************************
Course by: 	Pinal Dave  (http://blog.sqlauthority.com)
			Vinod Kumar (http://blogs.extremeExperts.com)

	Script - http://bit.ly/columnstoreindex

Scripts for SQL Server Performance: Query Tuning ©Pluralsight.

Description: How to use Computed Columns

****************************************************************/

USE tempdb
GO
if OBJECT_ID ('computed_table') is not null
	DROP TABLE computed_table
GO
CREATE TABLE computed_table (Lastname VARCHAR(50), description VARCHAR(200) )
GO
/*
 INSERT some sample data
*/
SET nocount ON
BEGIN Tran
DECLARE @i INT
SET @i = 0
WHILE @i < 100000
BEGIN
DECLARE @ch VARCHAR(10)
SET @ch = ' ' +  cast (@i AS VARCHAR(10) )  
INSERT INTO computed_table (Lastname,description) VALUES (@ch, replicate('a', 200))
SET @i = @i + 1
END
COMMIT Tran

GO
CREATE INDEX indx_Lastname ON computed_table(Lastname)
GO

GO
SET STATISTICS TIME ON
SET STATISTICS IO ON
SET STATISTICS PROFILE ON
GO
SELECT * FROM computed_table where ltrim(Lastname) = '0'
GO
SET STATISTICS PROFILE OFF
SET STATISTICS IO OFF
SET STATISTICS TIME OFF
GO

-- Adding index on computed columns
ALTER TABLE computed_table ADD computed_col AS ltrim(Lastname)
GO
CREATE INDEX indx_computed_col ON computed_table(computed_col)
GO

SET STATISTICS TIME ON
SET STATISTICS IO ON
SET STATISTICS PROFILE ON
GO
SELECT * FROM computed_table where ltrim(Lastname) = '0'
GO
SET STATISTICS PROFILE OFF
SET STATISTICS IO OFF
SET STATISTICS TIME OFF
GO