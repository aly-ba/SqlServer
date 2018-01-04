select * from employees

select [first name], [last name], [base rate],
rank() over (order by [base rate]) as rank
from employees
order by [last name], rank

--- partitioned by family
select [first name], [last name], [base rate],
rank() over (partition by [last name] order by [base rate])	as rank
from employees
order by [last name], rank

-- works with ntile
select [first name], [last name], [base rate],
ntile(4) over (partition by [last name] order by [base rate])	as quartile
from employees
order by [last name], quartile



