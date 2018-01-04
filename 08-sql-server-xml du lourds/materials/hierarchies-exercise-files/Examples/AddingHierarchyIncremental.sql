update [personnel (parented)] set node = null;

-- incremental fill
with [sibs]
as
(select boss, 
employee, 
cast(row_number() over (partition by boss order by employee) as varchar) + '/' as sib
from [personnel (parented)]
where employee != boss
) 

--select * from [sibs
,[no node]
as
(
select  P2.node.ToString() + sibs.sib as node, P1.employee, 
P1.boss
from [personnel (parented)] as P1
join [personnel (parented)] P2
on P2.employee = P1.boss
join sibs on P1.employee = sibs.employee
where P2.node is not null
and P1.employee != P1.boss
and P1.node is null
UNION
select '/' as node, P1.employee, P1.boss from [personnel (parented)] as P1
where P1.employee = P1.boss and P1.node is null
UNION ALL
select [no node].node + sibs.sib as node, 
P.employee, P.boss
from [personnel (parented)] as P
join [no node] on [no node].employee = P.boss
join sibs on sibs.employee = P.employee
where P.employee != P.boss
)
--select * from [no node]
update TOP(3) [personnel (parented)] 
set node = [no node].node
 from  [personnel (parented)] as P join [no node]
 on P.employee = [no node].employee
 
select node.ToString(), * from [personnel (parented)]

 

