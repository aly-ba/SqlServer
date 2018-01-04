
declare @x xml

create table xmltab (
 id int identity primary key,
 thexml xml)

insert xmltab values('<doc/><doc/>')

declare @x xml
set @x = '<doc/>'
print CONVERT(nvarchar,@x)

insert xmltab values(N'<doc></doc>')

insert xmltab values('1 2 3')

insert xmltab values(null)


INSERT INTO xmltab VALUES(CONVERT(XML,
'<?xml version="1.0" encoding="utf-16"?>
<doc1>
   <row au_id="111-11-1111"></row>
</doc1>
'))

select convert(varchar(max), thexml) from xmltab

select * from xmltab for xml auto