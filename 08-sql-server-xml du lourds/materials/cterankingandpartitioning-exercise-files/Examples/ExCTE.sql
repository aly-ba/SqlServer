select * from shifts

select * from [plant locations]

select * from employees


-- trivial examples to illustrate syntax
with locations
as 
(select id, state, premium, [business sector] from [plant locations])
select * from locations
 
 
 
 with locations(plant, st, premium, sector)
 as 
 (select id, state, premium, [business sector] from [plant locations])
 select * from locations
  
  
  -- find the net premium by shift, by plant
  with [shift premiums]
  as
  (select id, premium from shifts),
  
  [local premiums](shift, plant, premium)
  as
  (select sp.id, pl.id, 
  sp.premium * pl.premium
  from [shift premiums] as sp cross join [plant locations] as pl)
  
  select pl.name, lp.shift, lp.premium
  from [plant locations] as pl join [local premiums] as lp
  on pl.id = lp.plant
  order by pl.name, lp.shift
  
-- calculate each employee pay relative to the
-- average pay of all employees in terms
-- of standard deviations

with [location shifts](shift_id, plant_id, premium)
as
(select shifts.id, [plant locations].id,
 shifts.premium * [plant locations].premium  
  from shifts cross join [plant locations])
  ,
  
  [employee rates] (id, rate) as
  (select employees.id, [base rate] * [location shifts].premium
  from employees join [location shifts]
  on employees.location = [location shifts].plant_id
  and employees.shift = [location shifts].shift_id
  )  ,
 stats (stdev_rate, avg_rate) as
 (select stdev(rate), avg(rate) from [employee rates])
 
 select employees.id, employees.[first name], employees.[last name],
 ([employee rates].rate - stats.avg_rate)/stats.stdev_rate
 from employees join [employee rates] on employees.id = [employee rates].id
 cross join stats
 order by [last name], [first name]
 
  
  
  
 
 
  
  