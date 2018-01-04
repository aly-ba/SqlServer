-- add between

declare @leftNode hierarchyid
declare @rightNode hierarchyid
set @leftNode = '/2/2/';
set @rightNode = '/2/2.-1/';

with [between](node)
as
(
select @leftNode.GetAncestor(1).GetDescendant(@leftNode, @rightNode)
)
--select node.ToString() from [between]

insert into [personnel (small)] (name, [hourly rate], node)
values ('Between4', 100, (select node from [between]) )

select node.ToString(), * from [personnel (small)]


