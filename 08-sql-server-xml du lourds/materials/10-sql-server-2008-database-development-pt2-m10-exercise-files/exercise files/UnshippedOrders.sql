SELECT     SALES.Customers.FirstName, SALES.Customers.LastName, SALES.Customers.Address, SALES.Customers.City, SALES.Customers.State, SALES.Customers.Zip, 
                      SALES.Orders.OrderDate, SALES.OrderStatus.Unshipped, SALES.Flowers.CommonName
FROM         SALES.OrderDetails INNER JOIN
                      SALES.Flowers ON SALES.OrderDetails.FlowerID = SALES.Flowers.FlowerID INNER JOIN
                      SALES.Orders ON SALES.OrderDetails.OrderNumber = SALES.Orders.OrderNumber INNER JOIN
                      SALES.Customers ON SALES.Orders.CustomerNumber = SALES.Customers.CustomerNumber INNER JOIN
                      SALES.OrderStatus ON SALES.Orders.OrderNumber = SALES.OrderStatus.FlowerID