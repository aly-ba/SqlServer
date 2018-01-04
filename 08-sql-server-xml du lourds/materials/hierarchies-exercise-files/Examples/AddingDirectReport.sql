-- add new employee 

declare @boss hierarchyid;
set @boss = '/2/';   --Mary

with [next direct report](node)
as
(
select @boss.GetDescendant(null, min(node)) from [personnel (small)]
where node.IsDescendantOf(@boss)=1 and node.GetLevel() = @boss.GetLevel()+1
)
--select node.ToString() from [next direct report]
insert into [personnel (small)] (name, [hourly rate], node)
values
('Jules4', 100, (select node from [next direct report])  )
 select node.ToString(), * from [personnel (small)]
 
 

