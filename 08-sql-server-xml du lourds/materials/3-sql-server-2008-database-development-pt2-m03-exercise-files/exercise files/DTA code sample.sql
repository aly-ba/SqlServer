use veronicas

select sales.Customers.FirstName, Customers.LastName, Customers.Address, Customers.City, Customers.State, Customers.Zip
from sales.Customers, sales.Orders
where Orders.CustomerNumber = Customers.CustomerNumber
and Orders.OrderNumber = '697'


select flowers.CommonName, OrderDetails.Quantity, Flowers.SalesPrice, OrderDetails.Quantity * Flowers.SalesPrice 'Sub Total'
from sales.OrderDetails, sales.flowers
where OrderDetails.FlowerID = Flowers.FlowerID
and OrderDetails.OrderNumber = '697'

select sum(Flowers.SalesPrice * OrderDetails.Quantity) as 'Total'
from sales.OrderDetails, sales.flowers
where OrderDetails.FlowerID = Flowers.FlowerID
and orderdetails.OrderNumber =  '697'
group by OrderDetails.OrderNumber