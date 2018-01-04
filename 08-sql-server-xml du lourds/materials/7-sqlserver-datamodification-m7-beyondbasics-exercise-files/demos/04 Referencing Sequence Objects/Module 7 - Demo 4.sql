-- Module 7, Demo 4
-- Referencing Sequence Objects

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

CREATE SEQUENCE [dbo].[AdventureWorksSequence]
	AS INT
	START WITH 1
	INCREMENT BY 1
	NO CYCLE
	NO CACHE;
GO

-- Notice we're not using an IDENTITY property
-- for BusinessEntityID
CREATE TABLE [HumanResources].[EmployeeV2](
	[BusinessEntityID] [int] NOT NULL PRIMARY KEY CLUSTERED,
	[NationalIDNumber] [nvarchar](15) NOT NULL,
	[LoginID] [nvarchar](256) NOT NULL,
	[OrganizationNode] [hierarchyid] NULL,
	[OrganizationLevel]  AS ([OrganizationNode].[GetLevel]()),
	[JobTitle] [nvarchar](50) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[MaritalStatus] [nchar](1) NOT NULL,
	[Gender] [nchar](1) NOT NULL,
	[HireDate] [date] NOT NULL,
	[SalariedFlag] [dbo].[Flag] NOT NULL,
	[VacationHours] [smallint] NOT NULL,
	[SickLeaveHours] [smallint] NOT NULL,
	[CurrentFlag] [dbo].[Flag] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL);
GO

INSERT  INTO [HumanResources].[EmployeeV2]
        ( [BusinessEntityID] ,
          [NationalIDNumber] ,
          [LoginID] ,
          [OrganizationNode] ,
          [JobTitle] ,
          [BirthDate] ,
          [MaritalStatus] ,
          [Gender] ,
          [HireDate] ,
          [SalariedFlag] ,
          [VacationHours] ,
          [SickLeaveHours] ,
          [CurrentFlag] ,
          [rowguid] ,
          [ModifiedDate]
        )
        SELECT  NEXT VALUE FOR
					 [dbo].[AdventureWorksSequence],
                [NationalIDNumber] ,
                [LoginID] ,
                [OrganizationNode] ,
                [JobTitle] ,
                [BirthDate] ,
                [MaritalStatus] ,
                [Gender] ,
                [HireDate] ,
                [SalariedFlag] ,
                [VacationHours] ,
                [SickLeaveHours] ,
                [CurrentFlag] ,
                [rowguid] ,
                [ModifiedDate]
        FROM    [HumanResources].[Employee];
GO

-- Verify inserted rows
SELECT  [BusinessEntityID] ,
        [NationalIDNumber] ,
        [LoginID] ,
        [OrganizationNode] ,
        [OrganizationLevel] ,
        [JobTitle] ,
        [BirthDate] ,
        [MaritalStatus] ,
        [Gender] ,
        [HireDate] ,
        [SalariedFlag] ,
        [VacationHours] ,
        [SickLeaveHours] ,
        [CurrentFlag] ,
        [rowguid] ,
        [ModifiedDate]
FROM    [HumanResources].[EmployeeV2];
GO

-- We can continue incrementing independently of the table
-- for other objects, or even other result sets
SELECT NEXT VALUE FOR [dbo].[AdventureWorksSequence];
GO 50





