
use tempdb
go

create table xml_tab (id int, thexml xml)
go

-- This works correctly
INSERT INTO xml_tab VALUES(4,
'<?xml version="1.0" encoding="utf-8"?>
<doc1>
   <row au_id="111-11-1111"/>
</doc1>')

-- This fails, encoding does not agree w/variable type
INSERT INTO xml_tab VALUES(5,
N'<?xml version="1.0" encoding="utf-8"?>
<doc1>
   <row au_id="111-11-1111"></row>
</doc1>')
