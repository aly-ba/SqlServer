SELECT [FlowerID]
      ,[CommonName] --as 'Name'
      ,[DominateColor]
      ,[SubordinateColor]
      ,[Height]
      ,[TempRange]
      ,[Cost]
      ,[SalesPrice]
      ,[StockLevel]
      ,[NextShipmentDate]
      ,[Description]
  FROM [veronicas].[SALES].[Flowers]
  WHERE FlowerID between 1 and 20
  FOR XML RAW --('Flower'), Root('Flowers')
GO

SELECT orders.OrderNumber
      ,[CustomerNumber] as Number
      ,[OrderDate] as "comment()"
      ,[FlowerID]
      ,[Shipdate]
      ,[Quantity]
  FROM [veronicas].[SALES].[Orders] as Orders, 
  [veronicas].[SALES].[OrderDetails] as OrderDetails
  where Orders.OrderNumber = OrderDetails.OrderNumber 
  --and Orders.OrderNumber between 500 and 502
  order by Orders.OrderNumber
  for xml path, ROOT('Orders')

