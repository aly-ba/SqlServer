
use tempdb
go

drop table xml_tab
go

create table xml_tab (
 id int identity primary key,
 xml_col xml
)
go 
 
-- insert some rows
INSERT xml_tab  
VALUES('<people><person name="curly"/></people>')
INSERT xml_tab 
VALUES('<people><person name="larry"/></people>')
INSERT xml_tab 
  VALUES('<people><person name="moe"/></people>')
  
-- this query 
SELECT id, 
xml_col.value('(/people/person/@name)[1]',
              'varchar(50)') AS name
FROM xml_tab
  
 