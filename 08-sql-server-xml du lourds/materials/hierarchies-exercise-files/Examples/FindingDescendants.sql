select name from [personnel (small)] 
where node.IsDescendantOf('/2/')=1;

-- just descenants
select name from [personnel (small)] 
where node.IsDescendantOf('/2/')=1
and node != '/2/';

 
-- direct descendants
select name from [personnel (small)] 
where node.IsDescendantOf('/2/')=1
and node.GetLevel()=2

declare @boss hierarchyid;
set @boss = '/3/1/';
select name from [personnel (small)] 
where node.IsDescendantOf(@boss)=1
and node.GetLevel()= @boss.GetLevel()+1;


 -- power metric
 select P1.name,
 (
 select count(*)-1 from [personnel (small)]
 where node.IsDescendantOf(P1.node)=1
 ) as power
 from [personnel (small)]  as P1
  
  
  


