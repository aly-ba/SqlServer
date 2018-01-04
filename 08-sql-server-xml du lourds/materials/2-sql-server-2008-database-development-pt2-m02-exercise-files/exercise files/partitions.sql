use veronicas
go

drop  partition function PF_Customers

create partition function PF_Customers (int)
as range left
for values (20000);
go


CREATE PARTITION SCHEME CustomersPScheme 
AS 
PARTITION PF_Customers 
TO (fg_sales01, fg_sales02)


CREATE TABLE [Sales].[CustomersPartitioned](
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
	CONSTRAINT [PK_CustomersPartitioned] PRIMARY KEY CLUSTERED 
	(
	[CustomerNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 
ON CustomersPScheme (Customernumber)
) ON CustomersPScheme (customernumber)

GO
 
 insert SALES.CustomersPartitioned (
 	 [CustomerNumber]
	,[FirstName]
	,[LastName]
	,[Phone]
	,[Address]
	,[City]
	,[State]
	,[Zip]
	,[Email]
	,[Birthdate]
	,[Anniversary])
	select
	 [CustomerNumber]
	,[FirstName]
	,[LastName]
	,[Phone]
	,[Address]
	,[City]
	,[State]
	,[Zip]
	,[Email]
	,[Birthdate]
	,[Anniversary]
	from SALES.Customers;
	
	select index_id, partition_number, rows
	from sys.partitions
	where object_id = object_id('sales.customersPartitioned')
	order by index_id, partition_number