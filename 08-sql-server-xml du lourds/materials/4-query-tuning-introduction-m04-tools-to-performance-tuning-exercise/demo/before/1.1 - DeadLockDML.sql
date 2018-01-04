--------------------------------------------------------
-- Deadlock DML
--------------------------------------------------------
USE master;
GO
IF DATABASEPROPERTYEX ('TestDb', 'Version') > 0 
DROP DATABASE TestDB;
GO 
CREATE DATABASE TestDb;
GO
USE TestDb
GO
CREATE TABLE t1 (c1 INT);
INSERT INTO t1 VALUES (1);
GO
CREATE TABLE t2 (c1 INT);
INSERT INTO t2 VALUES (1);
GO
----------------------------------------------------
USE master
GO
ALTER DATABASE TestDB
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DROP DATABASE TestDB
GO