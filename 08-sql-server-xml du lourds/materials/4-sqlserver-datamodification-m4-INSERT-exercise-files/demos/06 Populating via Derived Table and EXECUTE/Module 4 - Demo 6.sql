-- Module 4, Demo 5
-- Populating via Derived Table and EXEC

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012]
GO

-- Create new demo table
CREATE TABLE [Production].[ScrapReasonV2]
    (
      [ScrapReasonID] [smallint] IDENTITY(1, 1)
                                 NOT NULL ,
      [Name] [dbo].[Name] NOT NULL ,
      [ModifiedDate] [datetime] NOT NULL
                                DEFAULT GETDATE()
    );
GO

-- INSERT, SELECT
INSERT  INTO [Production].[ScrapReasonV2]
        ( [Name] ,
          [ModifiedDate]
        )
        SELECT  [Name] ,
                [ModifiedDate]
        FROM    [Production].[ScrapReason];
GO

SELECT  [ScrapReasonID] ,
        [Name] ,
        [ModifiedDate]
FROM    [Production].[ScrapReasonV2];
GO

-- INSERT, EXEC
EXEC [dbo].[uspGetManagerEmployees] @BusinessEntityID = 1;
GO

-- Create a table for the procedure output
CREATE TABLE [dbo].[ManagerEmployeesRptOutput]
    (
      [RecursionLevel] SMALLINT NULL ,
      [OrganizationNode] NVARCHAR(50) NOT NULL ,
      [ManagerFirstName] NVARCHAR(50) NOT NULL ,
      [ManagerLastName] NVARCHAR(50) NOT NULL ,
      [BusinessEntityID] INT NOT NULL ,
      [FirstName] NVARCHAR(50) NOT NULL ,
      [LastName] NVARCHAR(50) NOT NULL
    );
GO

USE [AdventureWorks2012]
GO

INSERT  INTO [dbo].[ManagerEmployeesRptOutput]
        ( [RecursionLevel] ,
          [OrganizationNode] ,
          [ManagerFirstName] ,
          [ManagerLastName] ,
          [BusinessEntityID] ,
          [FirstName] ,
          [LastName]
        )
        EXEC [dbo].[uspGetManagerEmployees] @BusinessEntityID = 1;
GO

SELECT  [RecursionLevel] ,
        [OrganizationNode] ,
        [ManagerFirstName] ,
        [ManagerLastName] ,
        [BusinessEntityID] ,
        [FirstName] ,
        [LastName]
FROM    [dbo].[ManagerEmployeesRptOutput];
GO

