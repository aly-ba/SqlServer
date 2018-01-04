select   * 
into [#pivoted receipts]
from (select id, cast([date] as date)  as [date], payment 
from [sales receipts]) as t   
pivot
(
count(id)
for [payment] in ([VISA], [AmEx], [MasterCard], Cash)
) as p

select * from [#pivoted receipts]


select *  from [#pivoted receipts]
UNPIVOT
([sales] for payment in (VISA, AmEx, MasterCard, Cash)) as p
 order by date, payment
  
   
select  cast([date] as date) as [date], count(*) as sale, [payment] from [sales receipts]
group by payment, cast([date] as date)
 order by date, payment
 
    











































































































