
select node.ToString(), * from [personnel (small)]

declare @oldRoot hierarchyid
declare @newRoot hierarchyid


set @oldRoot = '/2.1.1/' -- Mary
set  @newRoot='/1/3/' -- now works for Joe

select node.GetReparentedValue(@oldRoot, @newRoot).ToString(), node.ToString(), * from [personnel (small)]
where   node.IsDescendantOf(@oldRoot)=1

update [personnel (small)] set node = node.GetReparentedValue(@oldRoot, @newRoot)
where node.IsDescendantOf(@oldRoot)=1




		 