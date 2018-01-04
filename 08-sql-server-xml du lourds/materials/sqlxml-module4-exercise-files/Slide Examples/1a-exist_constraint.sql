
use tempdb
go

CREATE FUNCTION dbo.checkperson(@data xml)
RETURNS BIT WITH SCHEMABINDING AS
BEGIN
RETURN @data.exist('/people/person')
END 
go 

CREATE TABLE xmltab(
  id INTEGER PRIMARY KEY,
  pdoc XML 
   CHECK (dbo.checkperson(pdoc)=1)
)
go

-- ok
insert xmltab values(
  1, '<people><person name="bob"/></people>')
-- fails, no persons
insert xmltab values(
  2, '<people><emp name="fred"/></people>')
