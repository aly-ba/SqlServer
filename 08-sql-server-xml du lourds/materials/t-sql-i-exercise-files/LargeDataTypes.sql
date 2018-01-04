use tsql1;

declare @text text
set @text = 'asdfasdf'
select @text

create table #largeDataType
(
id int primary key identity,
text text
)

alter table #largeDataType alter column text varchar(max)



insert into #largeDataType values ('some data')

select * from #largeDataType

update #largeDataType set text.write('lots', 0, 4)




declare @text text
select TOP 1 @text=text from #largeDataType

declare @text varchar(max);
set @text = 'asdfasdf';
select @text;

declare @text varchar(max);
set @text = REPLICATE(cast('asdfasdf' as varchar(max)), 8000);
select len(@text);

declare @text varchar(64000);
set @text = 'asdfasdf';
select @text;


declare @text varchar(max);
set @text = REPLICATE(cast('asdfasdf' as varchar(max)), 8000);
set @text.write('zzzzzzzz', 0, 8);
select @text;


declare @text varchar(max);
set @text = REPLICATE(cast('asdfasdf' as varchar(max)), 8000);
set @text.write('zzzzzzzz', 0, 1);
select @text;

declare @text varchar(max);
set @text = REPLICATE(cast('asdfasdf' as varchar(max)), 8000);
set @text.write('', 2, 3);
select @text;

declare @doc varbinary(max);
set @doc = (select * from OPENROWSET(BULK 
'D:\SqlVidCourse\Modules\T-SQL I\Examples\A big word document.docx', single_blob) AS a) 
select @doc

create table #docs
(
id int primary key identity,
doc varbinary(max)
)

insert into #docs  values((select * from OPENROWSET(BULK 
'D:\SqlVidCourse\Modules\T-SQL I\Examples\A big word document.docx', single_blob) AS a))

select * from #docs


exec sp_tableoption 'tempdb..#docs', 'large value types out of row', 1


use tempdb
exec sp_tableoption '#docs', 'large value types out of row', 1
use tsql1

















