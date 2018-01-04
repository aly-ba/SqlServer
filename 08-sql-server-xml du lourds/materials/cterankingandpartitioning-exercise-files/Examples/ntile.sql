select * from employees

-- break into percentiles
select [first name], [last name], [base rate],
ntile(100) over (order by [base rate])   as percentile
from employees
order by percentile desc

-- number of tiles is expression
-- get approx 200 employees per tile
select [first name], [last name], [base rate],
ntile((select count(*)/200 from employees)) 
over (order by [base rate])   as [base tile]
from employees
order by [base tile]

