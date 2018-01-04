--Module 6: Implementation scripts
USE AdventureWorks2014;
GO

--Create a script to compress all indexes 
SELECT CONCAT('ALTER INDEX [',i.name,'] ON [',s.name,'].[',t.name,
     '] REBUILD WITH (DATA_COMPRESSION = PAGE);') AS Command
FROM sys.tables AS t 
JOIN sys.indexes AS i ON t.object_id = i.object_id
JOIN sys.schemas AS s on t.schema_id = s.schema_id
WHERE i.type IN (1,2)
UNION ALL
SELECT CONCAT('ALTER TABLE [',s.name,'].[',t.name,
    '] REBUILD WITH (DATA_COMPESSION = PAGE);') AS Command
FROM sys.tables AS t 
JOIN sys.indexes AS i ON t.object_id = i.object_id
JOIN sys.schemas AS s on t.schema_id = s.schema_id
WHERE i.type = 0;


--Special criteria
--Check existing partition level
--One row per table/index
WITH Commands AS (
	SELECT CONCAT('ALTER INDEX [',i.name,'] ON [',s.name,'].[',t.name,'] REBUILD WITH (DATA_COMPRESSION = PAGE);') AS Command
		,CONCAT('[',s.name,'].[',t.name,']') AS TableName
		,i.name AS IndexName
		,i.object_id
		,i.index_id
	FROM sys.tables AS t 
	JOIN sys.indexes AS i ON t.object_id = i.object_id
	JOIN sys.schemas AS s on t.schema_id = s.schema_id
	WHERE i.type IN (1,2)
	UNION ALL
	SELECT CONCAT('ALTER TABLE [',s.name,'].[',t.name,'] REBUILD WITH (DATA_COMPESSION = PAGE);') AS Command
		,CONCAT('[',s.name,'].[',t.name,']') AS TableName
		,i.name AS IndexName
		,i.object_id
		,i.index_id
	FROM sys.tables AS t 
	JOIN sys.indexes AS i ON t.object_id = i.object_id
	JOIN sys.schemas AS s on t.schema_id = s.schema_id
	WHERE i.type = 0)
SELECT DISTINCT Command, TableName 
FROM Commands 
JOIN sys.partitions AS P on Commands.object_id = P.object_id 
	AND Commands.index_id = p.index_id
WHERE TableName NOT IN 
	(SELECT CONCAT('[',s.name,'].[',t.name,']') AS TableName
	FROM sys.tables AS t 
	JOIN sys.schemas AS s on t.schema_id = s.schema_id
	WHERE s.name = 'SpecialTables')
	AND p.data_compression_desc <> 'PAGE';




--Create a table for a scheduled job
IF OBJECT_ID('CompressionWork') IS NOT NULL DROP TABLE CompressionWork;

CREATE TABLE CompressionWork(ID INT IDENTITY NOT NULL, TableName sysname,
	IndexName sysname, Command NVARCHAR(500), CompletionDate DATETIME2);

--insert rows
WITH Commands AS (
	SELECT CONCAT('ALTER INDEX [',i.name,'] ON [',s.name,'].[',t.name,'] REBUILD WITH (DATA_COMPRESSION = PAGE);') AS Command
		,CONCAT('[',s.name,'].[',t.name,']') AS TableName
		,i.name AS IndexName
		,i.object_id
		,i.index_id
	FROM sys.tables AS t 
	JOIN sys.indexes AS i ON t.object_id = i.object_id
	JOIN sys.schemas AS s on t.schema_id = s.schema_id
	WHERE i.type IN (1,2)
	UNION ALL
	SELECT CONCAT('ALTER TABLE [',s.name,'].[',t.name,'] REBUILD WITH (DATA_COMPESSION = PAGE);') AS Command
		,CONCAT('[',s.name,'].[',t.name,']') AS TableName
		,'HEAP' AS IndexName
		,i.object_id
		,i.index_id
	FROM sys.tables AS t 
	JOIN sys.indexes AS i ON t.object_id = i.object_id
	JOIN sys.schemas AS s on t.schema_id = s.schema_id
	WHERE i.type = 0)
INSERT INTO CompressionWork(TableName, IndexName,Command)
SELECT DISTINCT TableName, IndexName, Command 
FROM Commands 
JOIN sys.partitions AS P on Commands.object_id = P.object_id
	AND Commands.index_id = p.index_id
WHERE TableName NOT IN 
	(SELECT CONCAT('[',s.name,'].[',t.name,']') AS TableName
	FROM sys.tables AS t 
	JOIN sys.schemas AS s on t.schema_id = s.schema_id
	WHERE s.name = 'SpecialTables')
	AND p.data_compression_desc <> 'PAGE';

--Script to perform work
DECLARE @ID INT, @command nvarchar(500);
WHILE EXISTS(SELECT * FROM CompressionWork WHERE CompletionDate IS NULL) BEGIN 
	SELECT @ID = ID, @command = Command 
	FROM CompressionWork
	WHERE CompletionDate IS NULL
	ORDER BY ID DESC;

	EXEC sp_executesql @command 
	UPDATE CompressionWork 
	SET CompletionDate = GETDATE()
	WHERE ID = @ID;
END;

SELECT * 
FROM  Compressionwork;



