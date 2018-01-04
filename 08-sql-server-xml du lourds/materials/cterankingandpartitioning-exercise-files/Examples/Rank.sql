select * from employees

-- rank according to family name
select [first name], [last name],
rank() over (order by [last name]) as rn
from employees

 -- dense_rank according to family name
 select [first name], [last name],
 dense_rank() over (order by [last name]) as drn,
 rank() over (order by [last name]) as rn
 from employees
 
 