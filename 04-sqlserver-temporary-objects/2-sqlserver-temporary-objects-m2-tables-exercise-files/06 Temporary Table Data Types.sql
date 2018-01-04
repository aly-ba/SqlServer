-- You can get the Credit database used in these demos 
-- from http://bit.ly/10fKpbS


USE [Credit];
GO

-- Supported data types?
CREATE TABLE #ExampleDataTypes
(
 [col01] BIGINT,
 [col02] BINARY,
 [col03] BIT,
 [col04] CHAR(50),
 [col05] DATE,
 [col06] DATETIME,
 [col07] DATETIME2,
 [col08] DATETIMEOFFSET,
 [col09] DECIMAL(4, 2),
 [col10] FLOAT,
 [col11] GEOGRAPHY,
 [col12] GEOMETRY,
 [col13] HIERARCHYID,
 [col14] INT,
 [col15] MONEY,
 [col16] NCHAR(50),
 [col17] NUMERIC(4, 2),
 [col18] NVARCHAR(50),
 [col19] REAL,
 [col20] SMALLDATETIME,
 [col21] SMALLINT,
 [col22] SMALLMONEY,
 [col23] SQL_VARIANT,
 [col24] TIME,
 [col25] TIMESTAMP,
 [col26] TINYINT,
 [col27] UNIQUEIDENTIFIER,
 [col28] VARBINARY,
 [col29] VARCHAR(MAX),
 [col30] XML
);
GO

-- User data types?
CREATE TABLE #ExampleDataTypes2
(
 [col01] [dbo].[letter]
);
GO


-- If you really must use them, create it in tempdb
USE [tempdb];
GO

CREATE TYPE [dbo].[letter] FROM [char](1) NOT NULL;
GO


USE [Credit];
GO

-- Now it works
CREATE TABLE #ExampleDataTypes3
(
 [col01] [dbo].[letter]
);
GO

-- Cleanup
USE [Credit];

DROP TABLE [#ExampleDataTypes];
DROP TABLE [#ExampleDataTypes3];

USE [tempdb];

DROP TYPE [dbo].[letter];
GO