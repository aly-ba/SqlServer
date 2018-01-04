--------------------------------------------------------
-- Connection 1:
--------------------------------------------------------
USE TestDB
GO
-- Connection 1:
BEGIN TRAN
UPDATE t1 SET c1 = 2;
GO

---- Connection 2:
--BEGIN TRAN
--UPDATE t2 SET c1 = 2;
--GO

-- Connection 1:
SELECT * FROM t2;
GO

---- Connection 2:
--SELECT * FROM t1;
--GO

