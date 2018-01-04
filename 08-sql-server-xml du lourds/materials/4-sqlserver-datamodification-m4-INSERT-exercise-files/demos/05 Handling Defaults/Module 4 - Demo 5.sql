-- Module 4, Demo 4
-- Handling Defaults

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

EXEC sys.sp_help '[Person].[ContactType]';
GO

INSERT  INTO [Person].[ContactType]
        ( [Name] ,
          [ModifiedDate]
        )
VALUES  ( N'Database Administrator' ,
          DEFAULT
        );
GO

-- Create event logging table
CREATE TABLE [dbo].[LoadEventTable]
    (
      [LoadEventDT] INT PRIMARY KEY CLUSTERED
                        IDENTITY(1, 1) ,
      [Name] NVARCHAR(50) NOT NULL
                          DEFAULT 'ETL Process Complete' ,
      [ModifiedDate] [datetime] NOT NULL
                                DEFAULT GETDATE()
    );
GO

-- Does this work?
INSERT [dbo].[LoadEventTable]
DEFAULT VALUES;
GO

INSERT [dbo].[LoadEventTable]
DEFAULT VALUES;
GO

SELECT  [LoadEventDT] ,
        [Name] ,
        [ModifiedDate]
FROM    [dbo].[LoadEventTable];
GO

