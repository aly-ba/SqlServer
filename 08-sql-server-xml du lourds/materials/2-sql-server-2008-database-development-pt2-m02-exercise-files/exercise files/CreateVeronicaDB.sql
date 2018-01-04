
USE master

DROP DATABASE veronicas

/****** Object:  Database [veronicas]    Script Date: 07/05/2009 17:26:44 ******/
CREATE DATABASE [veronicas] ON  PRIMARY 
( NAME = N'veronicas', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\veronicas.mdf' , SIZE = 9472KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
 FILEGROUP [FG_HR] 
( NAME = N'veronicas_HR', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\veronicas_HR.ndf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 

 FILEGROUP [FG_Sales01] 
( NAME = N'veronicas_Sales01.01', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\veronicas_Sales01.01.ndf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
( NAME = N'veronicas_Sales01.02', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\veronicas_Sales01.02.ndf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ),

FILEGROUP [FG_Sales02] 
( NAME = N'veronicas_Sales02.01', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\veronicas_Sales02.01.ndf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ), 
( NAME = N'veronicas_Sales02.02', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\veronicas_Sales02.02.ndf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )

 LOG ON 
( NAME = N'veronicas_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\veronicas_log.LDF' , SIZE = 29504KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [veronicas] SET COMPATIBILITY_LEVEL = 100
GO


IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [veronicas].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [veronicas] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [veronicas] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [veronicas] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [veronicas] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [veronicas] SET ARITHABORT OFF 
GO

ALTER DATABASE [veronicas] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [veronicas] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [veronicas] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [veronicas] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [veronicas] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [veronicas] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [veronicas] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [veronicas] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [veronicas] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [veronicas] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [veronicas] SET  ENABLE_BROKER 
GO

ALTER DATABASE [veronicas] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [veronicas] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [veronicas] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [veronicas] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [veronicas] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [veronicas] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [veronicas] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [veronicas] SET  READ_WRITE 
GO

ALTER DATABASE [veronicas] SET RECOVERY FULL 
GO

ALTER DATABASE [veronicas] SET  MULTI_USER 
GO

ALTER DATABASE [veronicas] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [veronicas] SET DB_CHAINING OFF 
GO

USE [veronicas]
GO

CREATE SCHEMA SALES
GO
CREATE SCHEMA HR
GO

CREATE TABLE [HR].[Benefits](
	[abc] [int] NULL
) ON [FG_HR]

GO

CREATE TABLE [HR].[Deductions](
	[abc] [int] NULL
) ON [FG_HR]

GO

CREATE TABLE [HR].[Employeees](
	[abc] [int] NULL
) ON [FG_HR]

GO

CREATE TABLE [Sales].[Flowers](
    [FlowerID] [varchar](10) ,
	[CommonName] [varchar](50) NULL,
	[DominateColor] [varchar](50) NULL,
	[SubordinateColor] [varchar](50) NULL,
	[Height] [varchar](50) NULL,
	[TempRange] [varchar](50) NULL,
	[Cost] [smallmoney] NULL,
	[SalesPrice] [smallmoney] NULL,
	[StockLevel] [varchar](50) NULL,
	[NextShipmentDate] [varchar](50) NULL,
	[Description] [varchar](150) NULL
 CONSTRAINT [PK_Flowers] PRIMARY KEY CLUSTERED 
(
	[FlowerID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 
) ON [FG_Sales01]

GO




/*********************************/



CREATE TABLE [Sales].[Customers](
	[CustomerNumber] int NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Phone] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Zip] [varchar](10) NULL,
	[Email] [varchar](50) NULL,
	[Birthdate] [varchar](50) NULL,
	[Anniversary] [varchar](50) NULL
	CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
	(
	[CustomerNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [FG_Sales01]
) ON [FG_Sales01]

GO

/********************************/



CREATE TABLE [Sales].[OrderDetails](
	[FlowerID] [varchar](10) NOT NULL,
	[OrderNumber] [varchar](10) NOT NULL,
	[Shipdate] [varchar](10) NULL,
	[Quantity] [varchar](10) NULL
) ON [FG_Sales01]

GO


/********************************/


CREATE TABLE [Sales].[Orders](
	[OrderNumber] [varchar](10) NOT NULL,
	[CustomerNumber] [varchar](10) NOT NULL,
	[OrderDate] [varchar](10) NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [FG_Sales01]
) ON [FG_Sales01]

GO

CREATE TABLE [Sales].[ClientFlowerMatch](
	[zip] [varchar](10) NOT NULL,
	[FlowerID] [varchar](10) NOT NULL,
	[Performance] [varchar](10) NULL
) ON [FG_Sales01]

GO



CREATE TABLE [SALES].[OrderStatus](
	[FlowerID] [nchar](10) NOT NULL,
	[OrderNumber] [nchar](10) NOT NULL,
	[Unshipped] [nchar](10) NOT NULL
) ON [FG_Sales01]

GO

SET ANSI_PADDING OFF
GO


BULK 
INSERT Sales.Flowers
        FROM 'c:\CourseFiles\Video03\FlowersData.csv'
            WITH
    (
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n'
    )
GO


BULK 
INSERT Sales.Customers
        FROM 'c:\CourseFiles\Video03\customersData.csv'
            WITH
    (
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n'
    )
GO


BULK 
INSERT Sales.Orders
        FROM 'c:\CourseFiles\Video03\ordersData.csv'
            WITH
    (
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n'
    )
GO


BULK 
INSERT Sales.OrderDetails
        FROM 'c:\CourseFiles\Video03\orderDetailsData.csv'
            WITH
    (
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n'
    )
GO


BULK 
INSERT Sales.ClientFlowerMatch
        FROM 'c:\CourseFiles\Video03\ClientFlowerMatchData.csv'
            WITH
    (
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n'
    )
GO

BULK 
INSERT Sales.OrderStatus
        FROM 'c:\CourseFiles\Video03\OrderStatus.csv'
            WITH
    (
                FIELDTERMINATOR = ',',
                ROWTERMINATOR = '\n'
    )
GO