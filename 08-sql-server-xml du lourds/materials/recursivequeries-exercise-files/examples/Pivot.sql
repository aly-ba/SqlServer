sp_help [sales receipts]


select top 10 * from [sales receipts]

select count(*) from [sales receipts]

select * from [sales receipts]
pivot
(
count(id)
for [payment] in ([VISA], [AmEx], [MasterCard], Cash)
) as p
order by [date]	 

select * from (select id, cast([date] as date)  as [date], 
payment from [sales receipts]) as t
pivot
(
count(id)
for [payment] in ([VISA], [AmEx], [MasterCard], Cash)
) as p
order by [date]


select * from (select total, cast([date] as date)  as [date], 
payment from [sales receipts]) as t
pivot
(
sum(total)
for [payment] in ([VISA], [AmEx], [MasterCard], Cash)
) as p
order by [date]

select count(*), cast([date] as date) as [date], [payment] from [sales receipts]
group by payment, cast([date] as date)


select cast([date] as date) as [date],
count(case when payment = 'VISA' THEN 1 END) as VISA,
count(case when payment = 'AmEx' THEN 1 END) as AmEx,
count(case when payment = 'MasterCard' THEN 1 END) as MasterCard,
count(case when payment = 'Cash' THEN 1 END) as Cash
from [sales receipts]
group by cast([date] as date)
order by date



select id, cast([date] as date) as [date], payment  from [sales receipts]
pivot
(
count(id)
for [payment] in ([VISA], [AmEx], [MasterCard], Cash)
) as p
order by [date]	 




select date [date of sale],
[VISA] as [Visa International], 
Cash as Bucks,
AmEx as [American Express], 
MasterCard as [Master Card]
 from (select id, cast([date] as date)  as [date], 
payment from [sales receipts]) as t
pivot
(
count(id)
for [payment] in ([VISA], [AmEx], [MasterCard], Cash)
) as p
order by [date]


