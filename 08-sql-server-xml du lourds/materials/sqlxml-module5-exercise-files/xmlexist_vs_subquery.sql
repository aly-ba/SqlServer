drop table xml_tab

create table xml_tab
(
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

SELECT * FROM xml_tab
go

select * from
(
SELECT xml_col.query('
   for $b in //person 
   where  $b/@name="moe"
   return <li>{ data($b/@name) } in record number {sql:column("xml_tab.id")}</li>
 ') as thecol
FROM xml_tab
) as d
where convert(varchar(100),thecol) > ''

select * from
(
SELECT xml_col.query('
   for $b in //person 
   where  $b/@name="moe"
   return <li>{ data($b/@name) } in record number {sql:column("xml_tab.id")}</li>
 ') as thecol
FROM xml_tab
) as d
where thecol.exist('/*') = 1

SELECT xml_col.query('
   for $b in //person 
   where  $b/@name="moe"
   return <li>{ data($b/@name) } in record number {sql:column("xml_tab.id")}</li>
 ') as thecol
FROM xml_tab
 where xml_col.exist('//person[@name = "moe"]') = 1
 
