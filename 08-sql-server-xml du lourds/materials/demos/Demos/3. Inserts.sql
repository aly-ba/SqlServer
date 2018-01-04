--1000 inserts of 1000

TRUNCATE TABLE dbo.bigTransactionHistoryROW;
TRUNCATE TABLE dbo.bigTransactionHistoryPAGE;
TRUNCATE TABLE dbo.bigTransactionHistoryTEST;

DBCC DROPCLEANBUFFERS;
GO
--2:40
DECLARE @Count INT = 0;
WHILE @Count < 1000 BEGIN 
	INSERT INTO dbo.bigTransactionHistoryTEST
	SELECT *
	FROM bigTransactionHistory
	WHERE TransactionID BETWEEN @Count * 1000 + 1 AND (@Count + 1) * 1000;
	SET @Count = @Count + 1;
END;

GO

DBCC DROPCLEANBUFFERS;
GO
--2:23
DECLARE @Count INT = 0;
WHILE @Count < 1000 BEGIN 
	INSERT INTO dbo.bigTransactionHistoryROW
	SELECT *
	FROM bigTransactionHistory
	WHERE TransactionID BETWEEN @Count * 1000 + 1 AND (@Count + 1) * 1000;
	SET @Count = @Count + 1;
END;

DBCC DROPCLEANBUFFERS;
GO
--2:14
DECLARE @Count INT = 0;
WHILE @Count < 1000 BEGIN 
	INSERT INTO dbo.bigTransactionHistoryPAGE
	SELECT *
	FROM bigTransactionHistory
	WHERE TransactionID BETWEEN @Count * 1000 + 1 AND (@Count + 1) * 1000;
	SET @Count = @Count + 1;
END;




