USE [AdventureWorks2014]
GO
/*
First, run Adam Machanic's Thinking Big Adventure script
http://sqlblog.com/blogs/adam_machanic/archive/2011/10/17/thinking-big-adventure.aspx
*/

/*
Create three new tables based on Adam's tables
*/

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'bigTransactionHistoryPAGE') 
	DROP TABLE dbo.bigTransactionHistoryPAGE;
GO

CREATE TABLE [dbo].[bigTransactionHistoryPAGE](
	[TransactionID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[TransactionDate] [datetime] NULL,
	[Quantity] [int] NULL,
	[ActualCost] [money] NULL,
 CONSTRAINT [pk_bigTransactionHistoryPAGE] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (DATA_COMPRESSION = PAGE)
) 

GO

CREATE NONCLUSTERED INDEX [IX_ProductId_TransactionDate] 
	ON [dbo].[bigTransactionHistoryPAGE]
(
	[ProductID] ASC,
	[TransactionDate] ASC
)
INCLUDE ( 	[Quantity],
	[ActualCost]) WITH (DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'bigTransactionHistoryROW') 
	DROP TABLE dbo.bigTransactionHistoryROW;
GO

CREATE TABLE [dbo].[bigTransactionHistoryROW](
	[TransactionID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[TransactionDate] [datetime] NULL,
	[Quantity] [int] NULL,
	[ActualCost] [money] NULL,
 CONSTRAINT [pk_bigTransactionHistoryROW] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (DATA_COMPRESSION = ROW)
);
GO

CREATE NONCLUSTERED INDEX [IX_ProductId_TransactionDate] 
ON [dbo].[bigTransactionHistoryROW]
(
	[ProductID] ASC,
	[TransactionDate] ASC
)
INCLUDE ( 	[Quantity],
	[ActualCost]) WITH (DATA_COMPRESSION = ROW);
GO

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'bigTransactionHistoryTEST') 
	DROP TABLE dbo.bigTransactionHistoryTEST;
GO

CREATE TABLE [dbo].[bigTransactionHistoryTEST](
	[TransactionID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[TransactionDate] [datetime] NULL,
	[Quantity] [int] NULL,
	[ActualCost] [money] NULL,
 CONSTRAINT [pk_bigTransactionHistoryTEST] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (DATA_COMPRESSION = NONE)
);
GO

CREATE NONCLUSTERED INDEX [IX_ProductId_TransactionDate] 
ON [dbo].[bigTransactionHistoryTEST]
(
	[ProductID] ASC,
	[TransactionDate] ASC
)
INCLUDE ( 	[Quantity],
	[ActualCost]) WITH (DATA_COMPRESSION = NONE);
GO

INSERT INTO bigTransactionHistoryPAGE 
SELECT * FROM BigTransactionHistory;

INSERT INTO bigTransactionHistoryRow
SELECT * FROM BigTransactionHistory;




