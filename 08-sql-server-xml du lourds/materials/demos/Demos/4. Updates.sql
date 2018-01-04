
--1000 updates of 1000 rows 

DBCC DROPCLEANBUFFERS;
GO
--1:48
DECLARE @Count INT = 0;
WHILE @Count < 1000 BEGIN 
	UPDATE dbo.bigTransactionHistoryTEST
	SET Quantity = Quantity + 1
	WHERE TransactionID BETWEEN @Count * 1000 + 1 AND (@Count + 1) * 1000;
	SET @Count = @Count + 1;
END;

DBCC DROPCLEANBUFFERS;
GO
--1:36
DECLARE @Count INT = 0;
WHILE @Count < 1000 BEGIN 
	UPDATE dbo.bigTransactionHistoryROW
	SET Quantity = Quantity + 1
	WHERE TransactionID BETWEEN @Count * 1000 + 1 AND (@Count + 1) * 1000;
	SET @Count = @Count + 1;
END;

DBCC DROPCLEANBUFFERS;
GO
--2:21
DECLARE @Count INT = 0;
WHILE @Count < 1000 BEGIN 
	UPDATE dbo.bigTransactionHistoryPAGE
	SET Quantity = Quantity + 1
	WHERE TransactionID BETWEEN @Count * 1000 + 1 AND (@Count + 1) * 1000;
	SET @Count = @Count + 1;
END;

