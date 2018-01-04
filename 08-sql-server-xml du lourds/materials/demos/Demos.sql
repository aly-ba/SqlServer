--Demo module 5

USE CompressionTest; 
GO 
 
--Look at "offrow" table
SELECT TOP(100) * FROM [dbo].[offrow];

--See LOB data pages
DBCC IND('CompressionTest','offrow',1);

EXEC sp_spaceused 'offrow'; --867096 KB

--compress the table 
ALTER TABLE offrow REBUILD WITH (DATA_COMPRESSION = PAGE);

--How big is the table now?
EXEC sp_spaceused 'offrow'; --861872 KB

--Create a new table
DROP TABLE IF EXISTS CompressFX;

--Compress the table
CREATE TABLE CompressFX(Col1 nchar(50), Col2 VARBINARY(MAX)) 
WITH(DATA_COMPRESSION = PAGE);

--Populate with rows from offrow table
INSERT INTO CompressFX(Col1, col2) 
SELECT Col1, COMPRESS(Col2) 
FROM offrow;

--How big is this table?
EXEC sp_spaceused 'CompressFX';


--Look for LOB data pages
DBCC IND('CompressionTest','CompressFX',1);




--Make sure that FULL TEXT feature has been installed
SELECT FULLTEXTSERVICEPROPERTY('IsFullTextInstalled');

USE [AdventureWorks2014]
GO

--new table
DROP TABLE IF EXISTS ProductsCompressFX;

CREATE TABLE [dbo].[ProductsCompressFX](
	[ProductID] [int] NOT NULL PRIMARY KEY,
	[Name] VARBINARY(MAX) NOT NULL,
	[ProductNumber] VARBINARY(MAX) NOT NULL,
	[Color] [nvarchar](15) NULL,
	[Size] [nvarchar](5) NULL
) ;


--Insert rows from ProductsPage
INSERT INTO ProductsCompressFX(ProductID, Name, ProductNumber, Color, Size)
SELECT ProductID, COMPRESS(Name), COMPRESS(ProductNumber), Color, Size 
FROM ProductsPage;

--View the data 
SELECT * 
FROM ProductsCompressFX;


--Use the DECOMPRESS function
SELECT ProductID, DECOMPRESS(Name) AS Name, DECOMPRESS(ProductNumber) AS ProductNumber,
	Color, Size
FROM ProductsCompressFX;

--Cast
SELECT ProductID, CAST(DECOMPRESS(Name)  AS NVARCHAR(MAX))AS Name,
	CAST(DECOMPRESS(ProductNumber) AS NVARCHAR(MAX)) AS ProductNumber,
	Color, Size
FROM ProductsCompressFX;

SELECT ProductID, CAST(DECOMPRESS(Name)  AS VARCHAR(MAX))AS Name,
	CAST(DECOMPRESS(ProductNumber) AS VARCHAR(MAX)) AS ProductNumber,
	Color, Size
FROM ProductsCompressFX;

--Add computed columns 
ALTER TABLE ProductsCompressFX 
	ADD UName AS(CAST(DECOMPRESS(Name) AS NVARCHAR(MAX))),
	UProductNumber AS (CAST(DECOMPRESS(ProductNumber) AS NVARCHAR(MAX)));

--View the computed columns
SELECT ProductID, UName, UProductNumber 
FROM ProductsCompressFX;

--Create a full text index with the wizard 

--Query using CONTAINS
SELECT ProductID, UName, UProductNumber 
FROM ProductsCompressFX 
WHERE CONTAINS(Uname,'Bike') OR CONTAINS(UProductNumber,'CA-5965');



USE CompressionTest;
GO

SET STATISTICS IO ON;
--Query both tables and compare logical reads
SELECT TOP(1000) Col1, Col2 
FROM offrow;

SELECT TOP(1000) Col1, CAST(DECOMPRESS(Col2) AS VARCHAR(MAX))
FROM CompressFX;


SET STATISTICS IO OFF;
SET STATISTICS TIME ON;

--Query both tables and compare time
SELECT TOP(1000) Col1, Col2 
FROM offrow;

SELECT TOP(1000) Col1, CAST(DECOMPRESS(Col2) AS VARCHAR(MAX))
FROM CompressFX;

DECLARE @Col2 VARCHAR(MAX);

--Increase rows 
SELECT  @Col2 =  Col2
FROM offrow;

SELECT @Col2 =  Col2
FROM CompressFX;

SELECT @Col2 =  CAST(DECOMPRESS(Col2) AS VARCHAR(MAX))
FROM CompressFX;







--Clean up
ALTER TABLE offrow REBUILD WITH(DATA_COMPRESSION = NONE);