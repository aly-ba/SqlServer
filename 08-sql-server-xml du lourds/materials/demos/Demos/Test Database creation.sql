USE [master]
GO

CREATE DATABASE [CompressionTest]
GO
ALTER DATABASE [CompressionTest] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CompressionTest] MODIFY FILE ( NAME = N'CompressionTest', SIZE = 921600KB )
GO
USE [CompressionTest];
GO
--Create the numbers table
--Itzik Ben-Gan Method
--http://sqlmag.com/sql-server/virtual-auxiliary-table-numbers
WITH
  L0   AS(SELECT 1 AS c UNION ALL SELECT 1),
  L1   AS(SELECT 1 AS c FROM L0 AS A CROSS JOIN L0 AS B),
  L2   AS(SELECT 1 AS c FROM L1 AS A CROSS JOIN L1 AS B),
  L3   AS(SELECT 1 AS c FROM L2 AS A CROSS JOIN L2 AS B),
  L4   AS(SELECT 1 AS c FROM L3 AS A CROSS JOIN L3 AS B),
  L5   AS(SELECT 1 AS c FROM L4 AS A CROSS JOIN L4 AS B),
  Nums AS(SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS n FROM L5)
SELECT n 
INTO [dbo].[numbers]
FROM Nums WHERE n <= 1000000;



