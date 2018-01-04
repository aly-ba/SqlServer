create unique index idx_depth on [personnel (small)](node)

create index idx_breadth on [personnel (small)](node.GetLevel(), node)

alter table [personnel (small)]
add NodeLevel as node.GetLevel();


 create index idx_breadth on [personnel (small)](NodeLevel, node)
 
create trigger dbo.BossDelete ON [personnel (small)] for delete
as
if EXISTS 
(
select * from [personnel (small)] as P
join deleted
on P.node.IsDescendantOf(deleted.node)=1
and P.node != deleted.node
)
begin
   RAISERROR( 'has descendants', 10, 1  );
      Rollback transaction; 
      end
      
 
 delete [personnel (small)] where node='/1/'
 
delete [personnel (small)] where node='/1/3/3/1/'

create trigger dbo.PersonnelChange ON [personnel (small)] for insert, update
as
-- trigger fires if any inserted node lacks a parent
-- unless the node is '/'
if exists(
select node.ToString() from inserted
where not exists (select node from [personnel (small)] where node = inserted.node.GetAncestor(1))
and node != hierarchyid::GetRoot()
)
BEGIN
   RAISERROR( 'missing parent', 10, 1  );
      Rollback transaction;
      END
      
insert into [personnel (small)] values ('Markus', 10, '/1/2/3/4/5/6/')

insert into [personnel (small)] values ('Markus', 10, '/1/3/10/')

            