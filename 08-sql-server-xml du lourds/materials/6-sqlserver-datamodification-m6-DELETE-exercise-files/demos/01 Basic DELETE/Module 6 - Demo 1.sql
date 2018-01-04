-- Module 6, Demo 1
-- Basic DELETE

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

USE [AdventureWorks2012];
GO

-- Create a table based on [HumanResources].[Employee]
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
INTO    [HumanResources].[EmployeeV2]
FROM    [HumanResources].[Employee];
GO

-- Validate row count in new table
SELECT  COUNT(*) AS [rowcount]
FROM    [HumanResources].[EmployeeV2];
GO

-- Deleting ALL rows
-- ** Be Careful **
DELETE  [HumanResources].[EmployeeV2];
GO

-- Validate row count
SELECT  COUNT(*) AS [rowcount]
FROM    [HumanResources].[EmployeeV2];
GO

-- Repopulate
INSERT  [HumanResources].[EmployeeV2]
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
        FROM    [HumanResources].[Employee];
GO

-- Validate row count
SELECT  COUNT(*) AS [rowcount]
FROM    [HumanResources].[EmployeeV2];
GO

-- Validate rows to be removed
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
FROM    [HumanResources].[EmployeeV2]
WHERE   [JobTitle] = 'Sales Representative'
GO

-- Deleting rows
DELETE  [HumanResources].[EmployeeV2]
WHERE   [JobTitle] = 'Sales Representative'
GO

-- Validate row count
SELECT  COUNT(*) AS [rowcount]
FROM    [HumanResources].[EmployeeV2];
GO

-- Validate removed rows
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
FROM    [HumanResources].[EmployeeV2]
WHERE   [JobTitle] = 'Sales Representative'
GO