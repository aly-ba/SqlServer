use veronicas
go

create partition function PF_CustomersByName (varchar(50))
as range left
for values ('M');
go


CREATE PARTITION SCHEME CustomersPSchemeByName 
AS 
PARTITION PF_CustomersByName 
TO (fg_sales01, fg_sales02)


CREATE TABLE [Sales].[CustomersPartitionedByName](
	[CustomerNumber] int NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NOT NULL,
	[Phone] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Zip] [varchar](10) NULL,
	[Email] [varchar](50) NULL,
	[Birthdate] [varchar](50) NULL,
	[Anniversary] [varchar](50) NULL
) ON CustomersPSchemeByName ([LastName])

GO
 
 insert SALES.CustomersPartitionedByName (
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
	where object_id = object_id('sales.customersPartitionedByName')
	order by index_id, partition_number