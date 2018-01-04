--XML Data Type

USE [veronicas]
GO


CREATE TABLE [SALES].[OrdersXML](
	[OrderNumber] [int] NOT NULL,
	[CustomerNumber] [int] NOT NULL,
	[OrderDate] [varchar](15) NULL,
	[OrderInfo] XML
 ) ON [FG_Sales01]

GO

INSERT INTO [veronicas].[SALES].[OrdersXML]
           ([OrderNumber]
           ,[CustomerNumber]
           ,[OrderInfo])
     VALUES
           (5000
           ,5000
           ,(SELECT orders.OrderNumber
				  ,[CustomerNumber]
				  ,[OrderDate]
				  ,[FlowerID]
				  ,[Shipdate]
				  ,[Quantity]
			  FROM [veronicas].[SALES].[Orders] as Orders, 
			  [veronicas].[SALES].[OrderDetails] as OrderDetails
			  where Orders.OrderNumber = OrderDetails.OrderNumber 
			  and Orders.OrderNumber = 500
			  order by Orders.OrderNumber
			  for xml auto, elements, ROOT('Orders')))
go


select * from veronicas.SALES.OrdersXML
where OrderInfo.exist('/Orders/OrderDetails/FlowerID =  283')= 1

GO
