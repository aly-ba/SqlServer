
use tempdb
go

drop table xml_tab
go

create table xml_tab (
 id int identity primary key,
 xml_col xml
)
go

INSERT xml_tab  
  VALUES('<people><person name="curly"/></people>')
INSERT xml_tab 
  VALUES('<people><person name="larry"/></people>')
INSERT xml_tab 
  VALUES('<people><person name="moe"/></people>')
go

select * from xml_tab
go

select xml_col.value('(/people/person/@name)[1]', 'varchar(50)') as name
from xml_tab
go

INSERT xml_tab
  VALUES('<people><person name="bob"/><person name="mary"/></people>')
go

select * from xml_tab
go

-- how to get both bob and mary
-- nope
select xml_col.value('(/people/person/@name)[1]', 'varchar(50)') as name
from xml_tab
go

-- need nodes and cross apply
select id, xml_col,
       tab.col.value('.', 'varchar(50)') as name,
       tab.col.query('data(.)')
from xml_tab
cross apply
xml_col.nodes('/people/person/@name') as tab(col)
go

-- add some other interesting conditions
insert xml_tab values('<people><person name="a" /><person name="b" /><person name="c" /></people>')

insert xml_tab values('<people><person/></people>')

insert xml_tab values(NULL)

select id, xml_col,
       tab.col.value('.', 'varchar(50)') as name,
       tab.col.query('data(.)')
from xml_tab
cross apply
xml_col.nodes('/people/person/@name') as tab(col)

-- how to get null and empty rows
select id, xml_col,
       tab.col.value('.', 'varchar(50)') as name,
       tab.col.query('data(.)')
from xml_tab
outer apply
xml_col.nodes('/people/person/@name') as tab(col)