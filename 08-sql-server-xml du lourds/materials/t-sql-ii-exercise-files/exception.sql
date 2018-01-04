use tsql2;

create table people
(
id int primary key,
name varchar(50)
)

insert into people values
(1, 'Joe'),
(2, 'Jane'),
(3, 'Scott'),
(4, 'Stacy'),
(5, 'Linden'),
(6, 'Louis'),
(7, 'Linda')

select * from people

insert into people values (2, 'John')
insert into people values (200, 'Rex')


BEGIN TRAN
insert into people values (2, 'John')
insert into people values (300, 'Jayne')
COMMIT TRAN

select * from people

set xact_abort on
BEGIN TRAN
insert into people values (500, 'June')
insert into people values (2, 'John')
COMMIT TRAN



set xact_abort off

select * from people

declare @err int
begin tran
insert into people values (301, 'Mark')
set @err = @@error
if(@err != 0) goto error
insert into people values (2, 'John')
set @err = @@error
if(@err != 0) goto error
commit tran
goto next
error:
raiserror ('something bad happened', 16, 20);
if @@trancount > 0
rollback tran
next:

begin try
begin tran
insert into people values (301, 'Mark')
insert into people values (2, 'John')
commit tran
end try
begin catch
raiserror ('something bad happened', 16, 20);
if @@trancount > 0
rollback tran
end catch

select * from people


create trigger no400 on people
for insert
as
declare @400s int
select @400s = count(*) from inserted where id = 400
if @400s != 0
rollback transaction

begin tran
insert into people values (400, 'Mark')
insert into people values (2, 'John')
commit tran

begin tran
insert into people values (400, 'Mark')
if(@@error != 0) print 'error'
insert into people values (2, 'John')
commit tran

select * from people

begin try
begin tran
insert into people values (400, 'Mark')
insert into people values (2, 'John')
commit tran
end try
begin catch
raiserror ('something bad happened', 16, 20);
if @@trancount > 0
rollback tran
end catch

select * from people

set xact_abort on
begin try
begin tran
insert into people values (405, 'Mark')
insert into people values (2, 'John')
commit tran
end try
begin catch
if @@trancount > 0
rollback tran
raiserror ('something bad happened', 16, 20);
end catch
set xact_abort off

select * from people

create table #log
(
id int identity primary key,
message varchar(50)
)

set xact_abort on
begin try
begin tran
insert into people values (405, 'Mark')
insert into people values (2, 'John')
commit tran
end try
begin catch
if @@trancount > 0
rollback tran
insert into #log values ('something bad happened');
raiserror ('something bad happened', 16, 20);
end catch
set xact_abort off


select * from #log

set xact_abort on
begin try
begin tran
insert into people values (405, 'Mark')
insert into people values (2, 'John')
commit tran
end try
begin catch
raiserror ('something bad happened', 16, 20);
end catch
set xact_abort off

begin try
begin tran
insert into people values (405, 'Mark')
insert into people values (2, 'John')
commit tran
end try
begin catch
if @@trancount > 0
rollback tran
declare @em varchar(max);
set @em = ERROR_MESSAGE()
raiserror ('something bad happened: %s', 16, 20, @em);
end catch

begin try
begin tran
insert into people values (405, 'Mark')
insert into people values (2, 'John')
commit tran
end try
begin catch
if xact_state() = -1
rollback tran
if xact_state() = 1
rollback tran
declare @em varchar(max);
set @em = ERROR_MESSAGE()
raiserror ('something bad happened: %s', 16, 20, @em);
end catch


use tsql2;

create table people
(
id int primary key,
name varchar(50)
)

insert into people values
(1, 'Joe'),
(2, 'Jane'),
(3, 'Scott'),
(4, 'Stacy'),
(5, 'Linden'),
(6, 'Louis'),
(7, 'Linda')

select * from people

insert into people values (2, 'John')
insert into people values (200, 'Rex')


BEGIN TRAN
insert into people values (2, 'John')
insert into people values (300, 'Jayne')
COMMIT TRAN

select * from people

set xact_abort on
BEGIN TRAN
insert into people values (500, 'June')
insert into people values (2, 'John')
COMMIT TRAN



set xact_abort off

select * from people

declare @err int
begin tran
insert into people values (301, 'Mark')
set @err = @@error
if(@err != 0) goto error
insert into people values (2, 'John')
set @err = @@error
if(@err != 0) goto error
commit tran
goto next
error:
raiserror ('something bad happened', 16, 20);
if @@trancount > 0
rollback tran
next:

begin try
begin tran
insert into people values (301, 'Mark')
insert into people values (2, 'John')
commit tran
end try
begin catch
raiserror ('something bad happened', 16, 20);
if @@trancount > 0
rollback tran
end catch

select * from people


create trigger no400 on people
for insert
as
declare @400s int
select @400s = count(*) from inserted where id = 400
if @400s != 0
rollback transaction

begin tran
insert into people values (400, 'Mark')
if(@@error != 0) print 'error'
insert into people values (2, 'John')
commit tran

select * from people

begin try
begin tran
insert into people values (400, 'Mark')
insert into people values (2, 'John')
commit tran
end try
begin catch
raiserror ('something bad happened', 16, 20);
if @@trancount > 0
rollback tran
end catch

select * from people

set xact_abort on
begin try
begin tran
insert into people values (405, 'Mark')
insert into people values (2, 'John')
commit tran
end try
begin catch
if @@trancount > 0
rollback tran
raiserror ('something bad happened', 16, 20);
end catch
set xact_abort off

select * from people

create table #log
(
id int identity primary key,
message varchar(50)
)


set xact_abort on
begin try
begin tran
insert into people values (405, 'Mark')
insert into people values (2, 'John')
commit tran
end try
begin catch
insert into #log values ('something bad happened');
if @@trancount > 0
rollback tran
raiserror ('something bad happened', 16, 20);
end catch
set xact_abort off


select * from #log
set xact_abort on
begin try
begin tran
insert into people values (405, 'Mark')
insert into people values (2, 'John')
commit tran
end try
begin catch
raiserror ('something bad happened', 16, 20);
end catch
set xact_abort off

begin try
begin tran
insert into people values (405, 'Mark')
insert into people values (2, 'John')
commit tran
end try
begin catch
declare @message nvarchar(max);
declare @number int;
declare @severity int;
declare @state int;
declare @line int;
declare @procedure varchar(max);
set @message = error_message();
set @number = error_number();
set @severity = error_severity();
set @state = error_state();
set @line = error_line();
set @procedure = error_procedure();
if xact_state() = -1
begin
rollback tran
print 'uncommitable'
end
if xact_state() = 1
begin
print 'commitable tran'
commit tran
end
select @number as number, @severity as severity, @state as state, 
@procedure as [procedure], @line as line, @message as [message];

end catch


select * from people



raiserror('this is an error', 15, 1);




begin try
raiserror('this is an error', 11, 1);
end try
begin catch
print 'caught raiserror'
print ERROR_MESSAGE();
end catch














