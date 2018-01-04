USE CompressionTest;
GO
--Direct output to the screen
DBCC TRACEON(3604);

SELECT * FROM dbo.TestFixedWidth; --Int, TinyInt, DateTime, Date, Char(8), Varchar(8)
--Find the page number. Look for page type 1
DBCC IND('CompressionTest',TestFixedWidth,1);
--Look at the page
DBCC PAGE('CompressionTest',1,105600,3) WITH TABLERESULTS;

SELECT * FROM TestSpecial; --Int, Bit, Int, NChar(8), Char(8), Char(12);
DBCC IND('CompressionTest',TestSpecial,1);
DBCC PAGE('CompressionTest',1,105608,3);


SELECT * FROM TestCluster; --15 Varchar(250), 15 INT, 15 Varchar(250), 15 INT
DBCC IND('CompressionTest',TestCluster,1);
DBCC PAGE('CompressionTest',1,105616,3);


