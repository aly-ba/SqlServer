
create table sometable  (
 somexml xml)

create trigger myt on jobs for insert
as
begin
declare @x xml
set @x = (select * from inserted for xml auto, type)
insert sometable values(@x)
end

insert jobs values('hi', 10, 10)

select * from sometable