
declare @x xml = '
<people>
  <person><name>bob</name></person>
  <person><name id="2">mary</name></person>
  <person><name>fred</name></person>
  <person><name>anne</name><name>nancy</name><name id="1">mary</name></person>
  <person></person>
</people>
'

-- can't get all of the names with value
--select @x.value('/people/person/name', 'varchar(50)')
--select @x.value('(/people/person/name)[1]', 'varchar(50)')

-- can't get individual rows for each name
--select @x.query('/people/person/name')

-- list of person names, one per row, no matter how names per person
--select tab.col.value('text()[1]', 'varchar(50)') as name,
--       tab.col.query('.'),
--       tab.col.query('..')
--from @x.nodes('/people/person/name') as tab(col)

-- some additional information
select tab.col.value('name[.="mary"][1]', 'varchar(50)') as name,
       tab.col.value('name[.="mary"][1]/@id', 'int') as id,
       tab.col.query('.') as node
from @x.nodes('/people/person[name="mary"]') as tab(col)
order by id
