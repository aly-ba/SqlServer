select * from employees

-- just rank accoding to base rate
select  [first name], [last name], [base rate],
 row_number() over (order by [base rate] desc)
 from employees
 
-- rank accoding to rounded base rate
select  [first name], [last name], round([base rate],0),
 row_number() over (order by round([base rate], 0) desc)
 from employees
 
-- mixing ranks
select  [first name], [last name], round([base rate],0),
row_number() over (order by round([base rate], 0) desc) as rate_rank,
row_number() over (order by location) as location_rank
from employees

-- try to page though employees
select  [first name], [last name], [base rate],
 row_number() over (order by [base rate] desc) as rn
 from employees where rn between 5 and 10
 
-- use CTE to enable paging
with rn
as
(select id, row_number() over (order by [base rate] desc) as rn
from employees
)
select [first name], [last name], [base rate], rn from
employees join rn on employees.id = rn.id
where rn between 5 and 10

-- can be wrapped into a function
create function getEmployeePage(@page int, @pageSize int)
returns table
as
return
with rn
as
(select id, row_number() over (order by [base rate] desc) as rn
from employees
)
select [first name], [last name], [base rate], rn from
employees join rn on employees.id = rn.id
where rn between  (@page - 1)*@pageSize and (@page*@pageSize)

-- then get page 
select * from dbo.getEmployeePage(1, 25)


  