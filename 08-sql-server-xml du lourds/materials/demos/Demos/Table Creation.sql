USE CompressionTest;
GO

IF OBJECT_ID('ints') IS NOT NULL DROP TABLE [dbo].[ints];

CREATE TABLE [dbo].[ints](
	col1 INT, col2 INT, col3 INT);

INSERT INTO [dbo].[ints](col1, col2, col3)
SELECT TOP(100000) 
	ROW_NUMBER() OVER(ORDER BY NEWID()),
	ROW_NUMBER() OVER(ORDER BY NEWID()),
	ROW_NUMBER() OVER(ORDER BY NEWID())
FROM [dbo].[numbers];




IF OBJECT_ID('chars') IS NOT NULL DROP TABLE [dbo].[chars];
CREATE TABLE [dbo].[chars] (
	col1 NCHAR(150));

INSERT INTO [dbo].[chars] 
SELECT LEFT(a.[name] + c.[name],150) 
FROM [sys].[objects] a 
CROSS JOIN [sys].[objects] b 
CROSS JOIN [sys].[objects] c;







IF OBJECT_ID('nchars') IS NOT NULL DROP TABLE [dbo].[nchars];
CREATE TABLE [dbo].[nchars] (
	col1 NCHAR(150));

INSERT INTO [dbo].[nchars] 
SELECT LEFT(a.[name] + c.[name],150) 
FROM [sys].[objects] a 
CROSS JOIN [sys].[objects] b 
CROSS JOIN [sys].[objects] c;





IF OBJECT_ID('datetimes') IS NOT NULL DROP TABLE [dbo].[datetimes];
CREATE TABLE [dbo].[datetimes](
	col1 datetime2,
	col2 datetime2);

INSERT INTO [dbo].[datetimes](col1, col2)
SELECT TOP(100000) DATEADD(millisecond,[n],'1900-01-01'),
	'1900-01-01'
FROM [dbo].[numbers];






IF OBJECT_ID('uniqid') IS NOT NULL DROP TABLE [dbo].[uniqid];

CREATE TABLE [dbo].[uniqid] (
	col0 INT, col1 UNIQUEIDENTIFIER DEFAULT(NEWSEQUENTIALID()),
	col2 UNIQUEIDENTIFIER DEFAULT(NEWSEQUENTIALID()), 
	col3 UNIQUEIDENTIFIER DEFAULT(NEWSEQUENTIALID())
);

INSERT INTO [dbo].[uniqid](col0)
SELECT TOP(100000) [n] 
FROM [dbo].[numbers];





IF OBJECT_ID('xmls') IS NOT NULL DROP TABLE [dbo].[xmls];

CREATE TABLE [dbo].[xmls](
	col1 XML);

--Grabbing all the XML columns from AdventureWorks
INSERT INTO [dbo].[xmls] SELECT [XmlEvent] FROM[AdventureWorks2014].[dbo].[DatabaseLog]
INSERT INTO [dbo].[xmls] SELECT [CatalogDescription] FROM[AdventureWorks2014].[Production].[ProductModel]
INSERT INTO [dbo].[xmls] SELECT [Instructions] FROM[AdventureWorks2014].[Production].[ProductModel]
INSERT INTO [dbo].[xmls] SELECT [Demographics] FROM[AdventureWorks2014].[Sales].[Store]
INSERT INTO [dbo].[xmls] SELECT [Diagram] FROM[AdventureWorks2014].[Production].[Illustration]
INSERT INTO [dbo].[xmls] SELECT [Resume] FROM[AdventureWorks2014].[HumanResources].[JobCandidate]
INSERT INTO [dbo].[xmls] SELECT [AdditionalContactInfo] FROM[AdventureWorks2014].[Person].[Person]
INSERT INTO [dbo].[xmls] SELECT [Demographics] FROM[AdventureWorks2014].[Person].[Person]
INSERT INTO [dbo].[xmls] SELECT [AdditionalContactInfo] FROM[AdventureWorks2014].[HumanResources].[vEmployee]
INSERT INTO [dbo].[xmls] SELECT [Demographics] FROM[AdventureWorks2014].[Sales].[vIndividualCustomer]
--remove the NULLs
DELETE FROM [dbo].[xmls] WHERE col1 IS NULL;







IF OBJECT_ID('offrow') IS NOT NULL DROP TABLE [dbo].[offrow];
CREATE TABLE [dbo].[offrow] (
	col1 CHAR(50),
	col2 VARCHAR(MAX));

INSERT INTO [dbo].[offrow] (col1, col2)
SELECT TOP(100000) 'a',
	LEFT(REPLICATE(CAST([a].[name] AS VARCHAR(MAX)),8500),8500)
FROM [sys].[objects] AS a
CROSS JOIN [sys].[objects] AS b
CROSS JOIN [sys].[objects] AS c;







IF OBJECT_ID('maxes') IS NOT NULL DROP TABLE [dbo].[maxes];
CREATE TABLE [dbo].[maxes] (
	col1 VARCHAR(MAX),
	col2 VARCHAR(MAX));

INSERT INTO [dbo].[maxes] (col1, col2)
SELECT a.[name],c.[name]
FROM [sys].[objects] AS a
CROSS JOIN [sys].[objects] AS b
CROSS JOIN [sys].[objects] AS c;

	